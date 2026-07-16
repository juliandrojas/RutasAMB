import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/company_filter_section.dart';

final _themeModeProvider = StateNotifierProvider<_ThemeModeNotifier, ThemeMode>(
  (ref) => _ThemeModeNotifier(),
);

class _ThemeModeNotifier extends StateNotifier<ThemeMode> {
  _ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getInt('theme_mode') ?? 0;
    state = ThemeMode.values[val];
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }
}

/// Expuesto globalmente para que main.dart pueda escucharlo
final themeModeProvider = _themeModeProvider;

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          // ── Sección: Apariencia ─────────────────────────────────────
          _SectionHeader(title: 'Apariencia'),
          _SettingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: cs.primary),
                ),
                const SizedBox(height: 12),
                _ThemeSelector(
                  current: themeMode,
                  onChanged: (m) => ref.read(themeModeProvider.notifier).set(m),
                ),
              ],
            ),
          ),

          // ── Sección: Búsqueda ───────────────────────────────────────
          _SectionHeader(title: 'Búsqueda'),
          _SettingCard(
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.radar,
                  title: 'Radio de búsqueda',
                  subtitle: '500 metros por defecto',
                  trailing: const Text(
                    '500 m',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const Divider(height: 1),
                _InfoTile(
                  icon: Icons.swap_horiz,
                  title: 'Máximo de transbordos',
                  subtitle: 'Número máximo de transbordos a sugerir',
                  trailing: const Text(
                    '2',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Sección: Empresas de Transporte ───────────────────────
          _SectionHeader(title: 'Empresas de Transporte'),
          const CompanyFilterSection(),

          // ── Sección: Acerca de ──────────────────────────────────────
          _SectionHeader(title: 'Acerca de'),
          _SettingCard(
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.directions_bus_filled,
                  title: 'Rutas AMB',
                  subtitle: 'Área Metropolitana de Bucaramanga',
                ),
                const Divider(height: 1),
                _InfoTile(
                  icon: Icons.info_outline,
                  title: 'Versión',
                  subtitle: 'Datos actualizados al 2025',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '1.0.0',
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                _InfoTile(
                  icon: Icons.source_outlined,
                  title: 'Fuente de datos',
                  subtitle: 'Área Metropolitana de Bucaramanga – amb.gov.co',
                ),
                const Divider(height: 1),
                // ── API Key notice ─────────────────────────────────
                // Padding(
                //   padding: const EdgeInsets.all(14),
                //   child: Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: Colors.amber.withValues(alpha: 0.1),
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: Colors.amber.withValues(alpha: 0.4),
                //       ),
                //     ),
                //     child: Row(
                //       children: [
                //         const Icon(Icons.key, color: Colors.amber, size: 18),
                //         const SizedBox(width: 10),
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               const Text(
                //                 'Google Maps API Key',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   fontFamily: 'Inter',
                //                   fontSize: 13,
                //                 ),
                //               ),
                //               const SizedBox(height: 3),
                //               Text(
                //                 'Reemplaza YOUR_GOOGLE_MAPS_API_KEY en:\nandroid/app/src/main/AndroidManifest.xml',
                //                 style: TextStyle(
                //                   fontSize: 11,
                //                   fontFamily: 'Inter',
                //                   color: Colors.grey.shade600,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.45),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final Widget child;
  const _SettingCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Padding(padding: const EdgeInsets.all(4), child: child),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: cs.primary, size: 18),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: trailing,
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSelector({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ThemeOption(
          icon: Icons.wb_sunny_outlined,
          label: 'Claro',
          selected: current == ThemeMode.light,
          onTap: () => onChanged(ThemeMode.light),
        ),
        const SizedBox(width: 8),
        _ThemeOption(
          icon: Icons.nightlight_outlined,
          label: 'Oscuro',
          selected: current == ThemeMode.dark,
          onTap: () => onChanged(ThemeMode.dark),
        ),
        const SizedBox(width: 8),
        _ThemeOption(
          icon: Icons.phone_android,
          label: 'Sistema',
          selected: current == ThemeMode.system,
          onTap: () => onChanged(ThemeMode.system),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? cs.primaryContainer
                : cs.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? cs.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected
                      ? cs.primary
                      : cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
