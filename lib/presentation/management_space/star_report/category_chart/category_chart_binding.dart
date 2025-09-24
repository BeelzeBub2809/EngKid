import 'package:get/instance_manager.dart';

import 'category_chart_controller.dart';

class CategoryChartBinding extends Bindings {
  final int? learningPathId;

  CategoryChartBinding({this.learningPathId});

  @override
  void dependencies() {
    // Use provided learningPathId or default to -1
    final pathId = learningPathId ?? -1;

    // Delete existing controller if it exists (for hot reload)
    if (Get.isRegistered<CategoryChartController>()) {
      Get.delete<CategoryChartController>();
    }

    Get.put<CategoryChartController>(
      CategoryChartController(
        starBoardUseCases: Get.find(),
        learningPathId: pathId,
      ),
      permanent: false,
    );
  }
}
