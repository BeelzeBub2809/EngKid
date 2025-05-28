import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';

class PreferencesModule {
  void provides() {
    getIt.registerSingleton(SharedPreferencesManager());
  }
}
