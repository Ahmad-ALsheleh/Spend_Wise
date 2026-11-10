import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import 'section_label.dart';
import 'segmented_toggle.dart';

/// اللوحة السفلية المفتوحة من زر ⚙️: اللغة والمظهر.
/// كل تغيير يُطبَّق فوراً (تنقلب اللوحة نفسها للعربية أو للداكن وهي مفتوحة).
class SettingsSheet extends StatefulWidget {
  final AppSettings settings;
  final ValueChanged<AppSettings> onChanged;

  const SettingsSheet({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required AppSettings settings,
    required ValueChanged<AppSettings> onChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => SettingsSheet(settings: settings, onChanged: onChanged),
    );
  }

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  // نسخة محلية: المسار المفتوح لا يُعاد بناؤه بإعدادات جديدة من الأعلى.
  late AppSettings _settings = widget.settings;

  void _update(AppSettings settings) {
    setState(() => _settings = settings);
    widget.onChanged(settings);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              strings.settings,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SectionLabel(strings.languageLabel),
            const SizedBox(height: 8),
            SegmentedToggle<AppLanguage>(
              options: [
                SegmentedToggleOption(
                  value: AppLanguage.system,
                  label: strings.systemOption,
                ),
                SegmentedToggleOption(
                  value: AppLanguage.english,
                  label: strings.englishLanguageName,
                ),
                SegmentedToggleOption(
                  value: AppLanguage.arabic,
                  label: strings.arabicLanguageName,
                ),
              ],
              selected: _settings.language,
              onChanged: (language) =>
                  _update(_settings.copyWith(language: language)),
            ),
            const SizedBox(height: 20),
            SectionLabel(strings.themeLabel),
            const SizedBox(height: 8),
            SegmentedToggle<ThemeMode>(
              options: [
                SegmentedToggleOption(
                  value: ThemeMode.system,
                  label: strings.systemOption,
                  icon: Icons.brightness_auto_outlined,
                ),
                SegmentedToggleOption(
                  value: ThemeMode.light,
                  label: strings.lightTheme,
                  icon: Icons.light_mode_outlined,
                ),
                SegmentedToggleOption(
                  value: ThemeMode.dark,
                  label: strings.darkTheme,
                  icon: Icons.dark_mode_outlined,
                ),
              ],
              selected: _settings.themeMode,
              onChanged: (mode) => _update(_settings.copyWith(themeMode: mode)),
            ),
          ],
        ),
      ),
    );
  }
}
