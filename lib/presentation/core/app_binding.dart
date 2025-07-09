import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/core/elibrary_service.dart';
import 'package:EngKid/presentation/e_library/e_library_video_binding.dart';
import 'package:get/get.dart';

import 'network_service.dart';
import 'topic_service.dart';
import 'user_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkService());
    Get.put(UserService(appUseCases: Get.find(), childProfilesUsecases: Get.find()));
    Get.put(TopicService(appUseCases: Get.find()));
    Get.put(ElibraryService(appUseCases: Get.find(), eBookUsecases: Get.find(), eBookCategoryUsecases: Get.find()));
    Get.put(QuizUseCases());
    // Get.put(PurchaseService(appUseCases: Get.find()));
  }
}
