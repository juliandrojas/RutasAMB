import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../routes/domain/entities/route_result_entity.dart';
import '../../../routes/presentation/providers/routes_providers.dart';

class ResultsScreen extends ConsumerWidget {
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final String originName;
  final String destinationName;

  const ResultsScreen({
    super.key,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.originName,
    required this.destinationName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = SearchParams(
      originLat: originLat,
      originLng: originLng,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      originName: originName,
      destinationName: destinationName,
    );

    final results = ref.watch(routeResultsProvider(params));
    final filter = ref.watch(resultFilterProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar con info de la búsqueda ───────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            title: const Text(
              'Rutas sugeridas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TripSummaryRow(
                      icon: Icons.radio_button_checked,
                      color: Colors.white70,
                      text: originName,
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white38,
                        size: 16,
                      ),
                    ),
                    _TripSummaryRow(
                      icon: Icons.location_on,
                      color: Colors.white,
                      text: destinationName,
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),

          // ── Filtros ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Todas',
                    selected: filter == null,
                    onTap: () =>
                        ref.read(resultFilterProvider.notifier).state = null,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Directas',
                    selected: filter == RouteResultType.direct,
                    onTap: () => ref.read(resultFilterProvider.notifier).state =
                        RouteResultType.direct,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '1 transbordo',
                    selected: filter == RouteResultType.oneTransfer,
                    onTap: () => ref.read(resultFilterProvider.notifier).state =
                        RouteResultType.oneTransfer,
                    color: AppColors.tertiary,
                  ),
                ],
              ),
            ),
          ),

          // ── Lista de resultados ────────────────────────────────────
          results.when(
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => const _RouteCardSkeleton(),
                childCount: 4,
              ),
            ),
            error: (err, _) => SliverFillRemaining(
              child: _EmptyState(
                icon: Icons.search_off,
                title: 'No se encontraron rutas',
                subtitle:
                    'Intenta ampliar el radio de búsqueda o elige un punto de destino diferente.',
              ),
            ),
            data: (allResults) {
              final filtered = filter == null
                  ? allResults
                  : allResults.where((r) => r.type == filter).toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyState(
                    icon: Icons.directions_bus_filled,
                    title: 'Sin rutas para este filtro',
                    subtitle:
                        'Prueba con otro filtro o amplía el radio de búsqueda.',
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RouteResultCard(
                        result: filtered[index],
                        index: index,
                        onTap: () => context.push(
                          '${RouteNames.routeDetail}/${filtered[index].primaryRoute.id}',
                          extra: {
                            'originLat': originLat,
                            'originLng': originLng,
                            'destinationLat': destinationLat,
                            'destinationLng': destinationLng,
                            'boardingStopLat': filtered[index].boardingStop.lat,
                            'boardingStopLng': filtered[index].boardingStop.lng,
                            'alightingStopLat':
                                filtered[index].finalAlightingStop.lat,
                            'alightingStopLng':
                                filtered[index].finalAlightingStop.lng,
                          },
                        ),
                      ),
                    ),
                    childCount: filtered.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TripSummaryRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _TripSummaryRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 13, fontFamily: 'Inter'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? effectiveColor
              : effectiveColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? effectiveColor
                : effectiveColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : effectiveColor,
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _RouteResultCard extends StatelessWidget {
  final RouteResultEntity result;
  final int index;
  final VoidCallback onTap;

  const _RouteResultCard({
    required this.result,
    required this.index,
    required this.onTap,
  });

  Color get _typeColor => switch (result.type) {
    RouteResultType.direct => AppColors.secondary,
    RouteResultType.oneTransfer => AppColors.tertiary,
    RouteResultType.twoTransfers => Colors.grey,
  };

  String get _typeLabel => switch (result.type) {
    RouteResultType.direct => 'Directa',
    RouteResultType.oneTransfer => '1 transbordo',
    RouteResultType.twoTransfers => '2 transbordos',
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mins = result.estimatedMinutes.round();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300 + index * 60),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: tiempo + badge tipo ───────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.primaryRoute.name,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          result.primaryRoute.company,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.5),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$mins min',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel,
                          style: TextStyle(
                            color: _typeColor,
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // ── Paradas ────────────────────────────────────────────
              Row(
                children: [
                  _StopInfo(
                    icon: Icons.login,
                    color: AppColors.mapBoardingColor,
                    label: 'Aborda en',
                    name: result.boardingStop.name,
                  ),
                  const Spacer(),
                  _StopInfo(
                    icon: Icons.logout,
                    color: AppColors.mapAlightingColor,
                    label: 'Desciende en',
                    name: result.finalAlightingStop.name,
                    alignRight: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ── Métricas ───────────────────────────────────────────
              Row(
                children: [
                  _MetricChip(
                    icon: Icons.directions_walk,
                    label: '${(result.walkToBoarding / 1000 * 1000).round()} m',
                    color: cs.secondary,
                  ),
                  const SizedBox(width: 8),
                  _MetricChip(
                    icon: Icons.access_time,
                    label: '~$mins min',
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  _MetricChip(
                    icon: Icons.swap_horiz,
                    label: '${result.transferCount} transb.',
                    color: _typeColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopInfo extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String name;
  final bool alignRight;

  const _StopInfo({
    required this.icon,
    required this.color,
    required this.label,
    required this.name,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!alignRight) ...[
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
                fontFamily: 'Inter',
              ),
            ),
            if (alignRight) ...[
              const SizedBox(width: 4),
              Icon(icon, color: color, size: 12),
            ],
          ],
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: 130,
          child: Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteCardSkeleton extends StatelessWidget {
  const _RouteCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: cs.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
