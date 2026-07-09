import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../routes/presentation/providers/routes_providers.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../routes/domain/entities/route_entity.dart';

class RouteDetailScreen extends ConsumerStatefulWidget {
  final String routeId;
  final Map<String, dynamic>? searchExtra;

  const RouteDetailScreen({super.key, required this.routeId, this.searchExtra});

  @override
  ConsumerState<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends ConsumerState<RouteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final routeAsync = ref.watch(routeDetailProvider(widget.routeId));
    final favState = ref.watch(favoritesNotifierProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: routeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (route) {
          final isFav = favState.maybeWhen(
            data: (favs) => favs.any((r) => r.id == route.id),
            orElse: () => false,
          );

          return Stack(
            children: [
              // ── Mapa ─────────────────────────────────────────────
              _RouteMap(route: route, searchExtra: widget.searchExtra),

              // ── AppBar flotante ───────────────────────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: cs.surface,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: cs.surface,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.bookmark : Icons.bookmark_outline,
                          color: isFav ? cs.primary : null,
                        ),
                        onPressed: () {
                          ref
                              .read(favoritesNotifierProvider.notifier)
                              .toggle(route);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFav
                                    ? 'Eliminado de favoritos'
                                    : 'Guardado en favoritos',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ── Panel inferior deslizable ─────────────────────────
              DraggableScrollableSheet(
                initialChildSize: 0.38,
                minChildSize: 0.2,
                maxChildSize: 0.85,
                builder: (context, controller) => Container(
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: cs.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // ── Cabecera de ruta ───────────────────────────
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.directions_bus_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _CodeBadge(code: route.code),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        route.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  route.company,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: cs.onSurface.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Métricas rápidas ───────────────────────────
                      Row(
                        children: [
                          _QuickMetric(
                            icon: Icons.timelapse,
                            label: 'Frecuencia',
                            value: route.frequency,
                          ),
                          const SizedBox(width: 8),
                          _QuickMetric(
                            icon: Icons.straighten,
                            label: 'Longitud',
                            value: '${route.lengthKm} km',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      // ── Recorrido textual ──────────────────────────
                      _InfoSection(
                        title: 'Recorrido',
                        content: route.textualRoute,
                        icon: Icons.route,
                      ),

                      const SizedBox(height: 12),

                      // ── Horario ────────────────────────────────────
                      _InfoSection(
                        title: 'Horario de servicio',
                        content: route.schedule,
                        icon: Icons.schedule,
                      ),

                      const SizedBox(height: 12),

                      // ── Barrios ────────────────────────────────────
                      _InfoSection(
                        title: 'Barrios principales',
                        icon: Icons.location_city,
                        chips: route.neighborhoods,
                      ),

                      const SizedBox(height: 16),

                      // ── Paradas ────────────────────────────────────
                      _StopsTimeline(route: route),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RouteMap extends StatelessWidget {
  final RouteEntity route;
  final Map<String, dynamic>? searchExtra;

  const _RouteMap({required this.route, this.searchExtra});

  @override
  Widget build(BuildContext context) {
    // Construir polylines y markers
    final polylinePoints = route.coordinates
        .map((c) => LatLng(c.lat, c.lng))
        .toList();

    final routeColor = _hexToColor(route.color ?? '#1565C0');

    final Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylinePoints,
        color: routeColor,
        width: 5,
        patterns: [],
      ),
    };

    final Set<Marker> markers = {};

    // Parada de abordaje
    if (searchExtra != null) {
      final bLat = searchExtra!['boardingStopLat'] as double?;
      final bLng = searchExtra!['boardingStopLng'] as double?;
      final aLat = searchExtra!['alightingStopLat'] as double?;
      final aLng = searchExtra!['alightingStopLng'] as double?;

      if (bLat != null && bLng != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('boarding'),
            position: LatLng(bLat, bLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: const InfoWindow(title: 'Punto de abordaje'),
          ),
        );
      }
      if (aLat != null && aLng != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('alighting'),
            position: LatLng(aLat, aLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: const InfoWindow(title: 'Punto de descenso'),
          ),
        );
      }
    }

    // Paradas intermedias
    for (int i = 0; i < route.stops.length; i++) {
      final s = route.stops[i];
      if (markers.any(
        (m) =>
            (m.position.latitude - s.lat).abs() < 0.0001 &&
            (m.position.longitude - s.lng).abs() < 0.0001,
      )) {
        continue;
      }
      markers.add(
        Marker(
          markerId: MarkerId('stop_$i'),
          position: LatLng(s.lat, s.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: s.name, snippet: s.address),
        ),
      );
    }

    final initialPos = polylinePoints.isNotEmpty
        ? polylinePoints[polylinePoints.length ~/ 2]
        : const LatLng(7.1198, -73.1227);

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialPos, zoom: 13),
      polylines: polylines,
      markers: markers,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}

class _CodeBadge extends StatelessWidget {
  final String code;
  const _CodeBadge({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _QuickMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: cs.primary),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.55),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final List<String>? chips;

  const _InfoSection({
    required this.title,
    this.content,
    required this.icon,
    this.chips,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: cs.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: cs.primary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (content != null)
          Text(
            content!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.8),
            ),
          ),
        if (chips != null)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: chips!
                .map(
                  (n) => Chip(
                    label: Text(
                      n,
                      style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    backgroundColor: cs.secondaryContainer,
                    labelStyle: TextStyle(color: cs.onSecondaryContainer),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _StopsTimeline extends StatelessWidget {
  final RouteEntity route;

  const _StopsTimeline({required this.route});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.stop_circle_outlined, size: 16, color: cs.primary),
            const SizedBox(width: 6),
            Text(
              'Paradas',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: cs.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...route.stops.asMap().entries.map((e) {
          final isFirst = e.key == 0;
          final isLast = e.key == route.stops.length - 1;
          final stop = e.value;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isFirst
                              ? AppColors.mapBoardingColor
                              : isLast
                              ? AppColors.mapAlightingColor
                              : cs.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.surface, width: 2),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(width: 2, color: cs.outlineVariant),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (stop.address != null)
                          Text(
                            stop.address!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.5),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
