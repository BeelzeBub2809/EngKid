import 'package:EngKid/presentation/management_space/profile/profile_parent/profile_parent_controller.dart';
import 'package:get/get.dart';

class ProfileParentBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ProfileParentController());
  }

}