import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'database/database_helper.dart';
import 'models/app_settings.dart';
import 'screens/root_shell.dart';
import 'utils/app_strings.dart';
import 'utils/app_theme.dart';

/// جذر التطبيق: يملك إعدادات اللغة والمظهر ويعيد بناء MaterialApp عند تغييرها.
class SpendWiseApp extends StatefulWidget {
  final AppSettings initialSettings;

  const SpendWiseApp({
    super.key,
    this.initialSettings = const AppSettings(),
  });

  @override
  State<SpendWiseApp> createState() => _SpendWiseAppState();
}

class _SpendWiseAppState extends State<SpendWiseApp> {
  late AppSettings _settings = widget.initialSettings;

  /// يطبّق الاختيار فوراً ثم يحفظه بقاعدة البيانات.
  Future<void> _changeSettings(AppSettings settings) async {
    if (settings == _settings) return;
    setState(() => _settings = settings);
    try {
      await DatabaseHelper.instance.saveSettings(settings);
    } catch (error) {
      debugPrint('SpendWise: could not save settings ($error)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppStrings.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _settings.themeMode,
      locale: _settings.locale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.systemOverlayStyle(Theme.of(context).brightness),
        child: child!,
      ),
      home: RootShell(settings: _settings, onSettingsChanged: _changeSettings),
    );
  }
}
