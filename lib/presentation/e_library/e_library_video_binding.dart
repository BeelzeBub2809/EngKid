import 'package:EngKid/domain/ebook/entities/ebook.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/elibrary/elibrary.dart';

import 'e_library_video_controller.dart';

class ElibraryVideoBinding extends Bindings {
  @override
  void dependencies() {
      // Retrieve the book object from the arguments passed in the route
      final EBook book = Get.arguments as EBook;

    // Get.lazyPut<GradeController>(
    //   () => GradeController(),
    // );
    Get.put(ElibraryVideoController(book: book));

  }
}
