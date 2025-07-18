import 'package:EngKid/presentation/management_space/profile/profile_child/profile_child_controlller.dart';
import 'package:get/get.dart';

class ProfileChildBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileChildController());
  }

}