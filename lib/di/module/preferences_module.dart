import 'package:EzLish/data/core/local/share_preferences_manager.dart';
import 'package:EzLish/di/injection.dart';

class PreferencesModule {
  void provides() {
    getIt.registerSingleton(SharedPreferencesManager());
  }
}
