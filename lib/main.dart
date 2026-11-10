import 'package:flutter/material.dart';

import 'app.dart';
import 'database/database_helper.dart';
import 'models/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // الإعدادات تُقرأ قبل أول إطار حتى لا يظهر التطبيق بلغة أو مظهر خاطئ للحظة.
  runApp(SpendWiseApp(initialSettings: await _loadSettings()));
}

Future<AppSettings> _loadSettings() async {
  try {
    return await DatabaseHelper.instance.getSettings();
  } catch (error) {
    debugPrint('SpendWise: could not load settings, using defaults ($error)');
    return const AppSettings();
  }
}
