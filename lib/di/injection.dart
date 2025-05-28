// ignore_for_file: always_use_package_imports

import 'package:get_it/get_it.dart';

import 'module/api_module.dart';
import 'module/preferences_module.dart';
import 'module/usecase_module.dart';

GetIt getIt = GetIt.instance;

class Injection {
  Injection._();
  static Future inject(String baseUrl) async {
    PreferencesModule().provides();
    await ApiModule().provides(baseUrl);
    UseCaseModule().provides();
  }
}
