import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../history/domain/repositories/history_repository.dart';
import '../../../../core/di/injection_container.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _destController = TextEditingController();
  final _originController = TextEditingController();

  double? _originLat, _originLng, _destLat, _destLng;
  bool _loadingLocation = false;

  // Sugerencias de lugares del AMB para demo
  static const _suggestions = [
    _Place('Parque Santander', 7.1080, -73.1210),
    _Place('Universidad Industrial de Santander (UIS)', 7.1250, -73.1190),
    _Place('C.C. Cabecera del Llano', 7.1079, -73.1158),
    _Place('C.C. Lagos del Cacique', 7.0885, -73.1097),
    _Place('Terminal de Transportes', 7.0930, -73.1195),
    _Place('Floridablanca Parque', 7.0630, -73.0870),
    _Place('Girón Parque Principal', 7.0728, -73.1698),
    _Place('Piedecuesta Centro', 6.9899, -73.0497),
    _Place('Hospital Universitario de Santander', 7.1198, -73.1227),
    _Place('Gobernación de Santander', 7.1198, -73.1227),
    _Place('C.C. Cañaveral', 7.0750, -73.0950),
    _Place('Aeropuerto Palonegro', 7.1284, -73.1848),
    _Place('Parque del Agua', 7.1150, -73.1300),
    _Place('UNAB', 7.1170, -73.1176),
    _Place('Bucaramanga Centro', 7.1000, -73.1200),
  ];

  List<_Place> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _detectCurrentLocation();
    _filteredSuggestions = _suggestions.take(6).toList();
  }

  Future<void> _detectCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _originController.text = 'Mi ubicación (sin permiso GPS)';
          _originLat = AppConstants.ambCenterLat;
          _originLng = AppConstants.ambCenterLng;
          _loadingLocation = false;
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      setState(() {
        _originLat = pos.latitude;
        _originLng = pos.longitude;
        _originController.text = 'Mi ubicación actual';
        _loadingLocation = false;
      });
    } catch (_) {
      setState(() {
        _originController.text = 'Mi ubicación (error GPS)';
        _originLat = AppConstants.ambCenterLat;
        _originLng = AppConstants.ambCenterLng;
        _loadingLocation = false;
      });
    }
  }

  void _onDestinationChanged(String value) {
    if (value.isEmpty) {
      setState(() => _filteredSuggestions = _suggestions.take(6).toList());
      return;
    }
    setState(() {
      _filteredSuggestions = _suggestions
          .where((p) => p.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _selectDestination(_Place place) {
    setState(() {
      _destController.text = place.name;
      _destLat = place.lat;
      _destLng = place.lng;
      _filteredSuggestions = [];
    });

    // Disparar búsqueda automática si ya tenemos el origen
    if (_originLat != null) {
      _search();
    }
  }

  Future<void> _search() async {
    if (_originLat == null || _destLat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un destino primero')),
      );
      return;
    }

    // Guardar en historial
    try {
      await ref
          .read(historyRepositoryProvider)
          .addEntry(
            SearchHistoryEntry(
              originName: _originController.text,
              originLat: _originLat!,
              originLng: _originLng!,
              destinationName: _destController.text,
              destinationLat: _destLat!,
              destinationLng: _destLng!,
              timestamp: DateTime.now(),
            ),
          );
    } catch (_) {}

    if (!mounted) return;
    context.push(
      RouteNames.results,
      extra: {
        'originLat': _originLat,
        'originLng': _originLng,
        'destinationLat': _destLat,
        'destinationLng': _destLng,
        'originName': _originController.text,
        'destinationName': _destController.text,
      },
    );
  }

  @override
  void dispose() {
    _destController.dispose();
    _originController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── AppBar con degradado ────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('¿A dónde vas?'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
              ),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Tarjeta de búsqueda ─────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Origen
                          _RouteInputField(
                            controller: _originController,
                            label: 'Origen',
                            icon: Icons.radio_button_checked,
                            iconColor: AppColors.mapBoardingColor,
                            readOnly: true,
                            trailing: _loadingLocation
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.my_location,
                                      size: 20,
                                    ),
                                    onPressed: _detectCurrentLocation,
                                    color: cs.primary,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  width: 2,
                                  height: 20,
                                  color: cs.outlineVariant,
                                ),
                              ],
                            ),
                          ),
                          // Destino
                          _RouteInputField(
                            controller: _destController,
                            label: 'Destino',
                            icon: Icons.location_on,
                            iconColor: AppColors.mapAlightingColor,
                            onChanged: _onDestinationChanged,
                            autofocus: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Botón buscar ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _destLat != null ? _search : null,
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar rutas'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Sugerencias ────────────────────────────────────
                  if (_filteredSuggestions.isNotEmpty) ...[
                    Text(
                      _destController.text.isEmpty
                          ? 'Lugares populares'
                          : 'Sugerencias',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._filteredSuggestions.map(
                      (place) => _SuggestionTile(
                        place: place,
                        onTap: () => _selectDestination(place),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: constant_identifier_names
const AppConstants = _AppConst();

class _AppConst {
  const _AppConst();
  double get ambCenterLat => 7.1198;
  double get ambCenterLng => -73.1227;
}

class _RouteInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool readOnly;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const _RouteInputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.readOnly = false,
    this.trailing,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            autofocus: autofocus,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final _Place place;
  final VoidCallback onTap;

  const _SuggestionTile({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.search, color: cs.onSurface.withOpacity(0.5), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                place.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.north_west,
              color: cs.onSurface.withOpacity(0.4),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _Place {
  final String name;
  final double lat;
  final double lng;
  const _Place(this.name, this.lat, this.lng);
}
