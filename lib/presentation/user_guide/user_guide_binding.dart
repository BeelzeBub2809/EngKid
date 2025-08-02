import 'package:EngKid/presentation/user_guide/user_guide_controller.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/app_usecases.dart';

class UserGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserGuideController>(
      () => UserGuideController(
        appUseCases: Get.find<AppUseCases>(),
      ),
    );
  }
}
