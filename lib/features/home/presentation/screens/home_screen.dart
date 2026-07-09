import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rutas_amb/features/routes/presentation/providers/routes_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _locationLoading = true;

  static const _initialCamera = CameraPosition(
    target: LatLng(AppConstants.ambCenterLat, AppConstants.ambCenterLng),
    zoom: AppConstants.ambDefaultZoom,
  );

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  Future<void> _requestLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationLoading = false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() => _locationLoading = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      setState(() {
        _currentPosition = pos;
        _locationLoading = false;
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(pos.latitude, pos.longitude),
          AppConstants.ambDetailZoom,
        ),
      );
    } catch (_) {
      setState(() => _locationLoading = false);
    }
  }

  Set<Marker> get _markers {
    if (_currentPosition == null) return {};
    return {
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'Tu ubicación'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // ── Mapa ───────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: _initialCamera,
            onMapCreated: (c) => _mapController = c,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: _markers,
            mapToolbarEnabled: false,
          ),

          // ── Barra de búsqueda flotante ─────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: _SearchBar(),
          ),

          // ── FAB: centrar en mi ubicación ───────────────────────────
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'center_location',
                  onPressed: _requestLocation,
                  backgroundColor: cs.surface,
                  foregroundColor: cs.primary,
                  elevation: 4,
                  child: _locationLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        )
                      : const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: 'search_route',
                  onPressed: () => context.push(RouteNames.search),
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar ruta'),
                  elevation: 6,
                ),
              ],
            ),
          ),

          // ── Header con branding ────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 82,
            left: 16,
            child: _NearbyBadge(),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push(RouteNames.search),
      child: Material(
        elevation: 8,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_bus,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '¿A dónde vas hoy?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Icon(Icons.search, color: cs.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearbyBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoutes = ref.watch(allRoutesProvider);
    return allRoutes.maybeWhen(
      data: (routes) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.route, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              '${routes.length} rutas disponibles',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
