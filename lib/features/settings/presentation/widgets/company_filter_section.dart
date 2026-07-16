// ─────────────────────────────────────────────────────────────────────────────
// UI – Sección de filtro por empresa para SettingsScreen
//
// Widget autónomo ConsumerWidget que:
//   • Muestra la lista de empresas con un Switch animado por cada una.
//   • Incluye botones de acceso rápido "Activar todas" / "Desactivar todas".
//   • Muestra una advertencia cuando ninguna empresa está activa.
//   • Se integra en _SettingCard y sigue el design system de la app.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rutas_amb/features/settings/data/company_filter_provider.dart';

// ── Iconos por empresa ────────────────────────────────────────────────────────
const Map<String, IconData> _companyIcons = {
  'Unitransa': Icons.directions_bus,
  'Cotrander': Icons.airport_shuttle,
  'Lusitania': Icons.commute,
  'San Juan': Icons.directions_transit,
  'Flota Cacique': Icons.bus_alert,
};

// ── Colores de acento por empresa ─────────────────────────────────────────────
const Map<String, Color> _companyColors = {
  'Unitransa': Color(0xFF1E88E5), // Azul
  'Cotrander': Color(0xFF43A047), // Verde
  'Lusitania': Color(0xFFE53935), // Rojo
  'San Juan': Color(0xFFFB8C00), // Naranja
  'Flota Cacique': Color(0xFF8E24AA), // Púrpura
};

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET PRINCIPAL EXPORTADO
// ─────────────────────────────────────────────────────────────────────────────

/// Sección completa de filtro por empresa para incluir en [SettingsScreen].
///
/// Uso:
/// ```dart
/// // En el ListView de SettingsScreen:
/// _SectionHeader(title: 'Empresas de Transporte'),
/// const CompanyFilterSection(),
/// ```
class CompanyFilterSection extends ConsumerWidget {
  const CompanyFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterMap = ref.watch(companyFilterProvider);
    final notifier = ref.read(companyFilterProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    // Muestra indicador de carga mientras SharedPreferences no respondió.
    if (filterMap.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _CompanyCardShell(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ),
      );
    }

    final companies = filterMap.keys.toList();
    final allEnabled = notifier.allEnabled;
    final noneEnabled = !notifier.hasActiveCompanies;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _CompanyCardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Acciones rápidas ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mostrar rutas de',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  Row(
                    children: [
                      _QuickActionChip(
                        label: 'Todas',
                        active: allEnabled,
                        onTap: notifier.enableAll,
                      ),
                      const SizedBox(width: 6),
                      _QuickActionChip(
                        label: 'Ninguna',
                        active: noneEnabled,
                        onTap: notifier.disableAll,
                        danger: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, indent: 12, endIndent: 12),

            // ── Lista de empresas ────────────────────────────────────────
            ...companies.asMap().entries.map((entry) {
              final index = entry.key;
              final company = entry.value;
              final isEnabled = filterMap[company] ?? true;
              final icon = _companyIcons[company] ?? Icons.directions_bus;
              final color = _companyColors[company] ?? cs.primary;

              return Column(
                children: [
                  _CompanyTile(
                    company: company,
                    icon: icon,
                    accentColor: color,
                    isEnabled: isEnabled,
                    onToggle: () => notifier.toggle(company),
                  ),
                  if (index < companies.length - 1)
                    const Divider(height: 1, indent: 60, endIndent: 12),
                ],
              );
            }),

            // ── Advertencia: ninguna empresa activa ──────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: noneEnabled
                  ? _NoneActiveWarning(key: const ValueKey('warning'))
                  : const SizedBox.shrink(key: ValueKey('no-warning')),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUBWIDGETS PRIVADOS
// ─────────────────────────────────────────────────────────────────────────────

/// Contenedor con estilo de tarjeta del design system de la app.
class _CompanyCardShell extends StatelessWidget {
  final Widget child;
  const _CompanyCardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Padding(padding: const EdgeInsets.all(4), child: child),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Tile de una empresa con ícono de acento y Switch animado.
class _CompanyTile extends StatelessWidget {
  final String company;
  final IconData icon;
  final Color accentColor;
  final bool isEnabled;
  final VoidCallback onToggle;

  const _CompanyTile({
    required this.company,
    required this.icon,
    required this.accentColor,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isEnabled ? 1.0 : 0.5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isEnabled
                ? accentColor.withValues(alpha: 0.15)
                : cs.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isEnabled
                ? accentColor
                : cs.onSurface.withValues(alpha: 0.35),
          ),
        ),
        title: Text(
          company,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isEnabled
                ? cs.onSurface
                : cs.onSurface.withValues(alpha: 0.45),
          ),
        ),
        subtitle: Text(
          isEnabled ? 'Rutas visibles' : 'Rutas ocultas',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isEnabled
                ? accentColor.withValues(alpha: 0.8)
                : cs.onSurface.withValues(alpha: 0.35),
          ),
        ),
        trailing: Switch.adaptive(
          value: isEnabled,
          onChanged: (_) => onToggle(),
          activeThumbColor: accentColor,
        ),
        onTap: onToggle,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Chip de acción rápida (Todas / Ninguna).
class _QuickActionChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool danger;

  const _QuickActionChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final activeColor = danger ? Colors.redAccent : cs.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? activeColor.withValues(alpha: 0.12)
              : cs.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Inter',
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? activeColor : cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Advertencia que aparece cuando el usuario desactiva todas las empresas.
class _NoneActiveWarning extends StatelessWidget {
  const _NoneActiveWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.45)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No se mostrarán rutas de ninguna empresa. Activa al menos una.',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Inter',
                  color: Colors.amber.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
