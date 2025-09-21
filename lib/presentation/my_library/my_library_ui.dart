import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/my_library/my_library_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class MyLibraryScreen extends GetView<MyLibraryController> {
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LocalImage.backgroundBlue),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                const Header(),
                Column(
                  children: [
                    RegularText(
                      "my_library",
                      maxLines: 1,
                      isUpperCase: true,
                      style: TextStyle(
                        color: AppColor.red,
                        fontWeight: FontWeight.w800,
                        fontSize: Fontsize.large,
                      ),
                    ),
                    Obx(
                      () => Column(
                        children: [
                          // Learning paths display with pagination
                          SizedBox(
                            height: 0.6 * size.height, // Fixed height container
                            child: Stack(
                              children: [
                                // Learning Path Cards - Horizontal Layout 1x4
                                Center(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        controller.currentPageItems.length,
                                        (index) {
                                          final item = controller
                                              .currentPageItems[index];
                                          return Container(
                                            width: size.width *
                                                0.18, // 15% of screen width per card
                                            height: size.height *
                                                0.6, // Fixed height for cards
                                            margin: EdgeInsets.symmetric(
                                              horizontal: size.width *
                                                  0.01, // Space between cards
                                            ),
                                            child: LearningPathCard(
                                              item: item,
                                              onTap: () => controller
                                                  .onPressLearningPath(item),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Left arrow at center left
                                if (controller.totalPages > 1)
                                  Positioned(
                                    left: 0.02 * size.width,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: controller.hasPreviousPage
                                            ? controller.previousPage
                                            : null,
                                        child: Opacity(
                                          opacity: controller.hasPreviousPage
                                              ? 1.0
                                              : 0.3,
                                          child: Image.asset(
                                            LocalImage.arrowLeft,
                                            width: 0.08 * size.width,
                                            height: 0.08 * size.width,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                // Right arrow at center right
                                if (controller.totalPages > 1)
                                  Positioned(
                                    right: 0.02 * size.width,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: controller.hasNextPage
                                            ? controller.nextPage
                                            : null,
                                        child: Opacity(
                                          opacity: controller.hasNextPage
                                              ? 1.0
                                              : 0.3,
                                          child: Image.asset(
                                            LocalImage.arrowRight,
                                            width: 0.08 * size.width,
                                            height: 0.08 * size.width,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ]),
            ),
            Positioned.fill(
                right: 0.03 * size.width,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        LocalImage.mascotWelcome,
                        height: 0.18 * size.width,
                        width: 0.12 * size.width,
                      ),
                    ],
                  ),
                )),
            Positioned.fill(
              left: 0.01 * size.width,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      ImageButton(
                        pathImage: LocalImage.backButton,
                        height: 0.075 * size.width,
                        width: 0.075 * size.width,
                        onTap: () {
                          controller.onBackPress();
                        },
                      ),
                    ],
                  )),
            ),
            // Page dots indicator at bottom of screen
            Obx(
              () => controller.totalPages > 1
                  ? Positioned(
                      bottom: 0.05 * size.height,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.totalPages,
                          (index) => GestureDetector(
                            onTap: () => controller.goToPage(index),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 0.008 * size.width,
                              ),
                              width: 0.015 * size.width, // Smaller size
                              height: 0.015 * size.width, // Smaller size
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.currentPage == index
                                    ? AppColor.blue
                                    : AppColor.gray.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class LearningPathCard extends StatelessWidget {
  const LearningPathCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final Map<String, dynamic> item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColor.blue.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 2, // Reduced flex for horizontal layout
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: AppColor.blue.withOpacity(0.1),
                ),
                child: Center(
                  child: Image.asset(
                    item['image'] ?? 'assets/images/elibrary_book_icon.png',
                    width:
                        size.width * 0.08, // Smaller icon for horizontal layout
                    height: size.width * 0.08,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.book,
                        size: size.width * 0.08,
                        color: AppColor.blue,
                      );
                    },
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              flex: 3, // More space for text content
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.015), // Smaller padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    RegularText(
                      item['name'] ?? 'Learning Path',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: Fontsize
                            .smaller, // Smaller font for horizontal layout
                        fontWeight: FontWeight.bold,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    SizedBox(height: size.height * 0.008),
                    // Description
                    Expanded(
                      child: RegularText(
                        item['description'] ??
                            'Khám phá và học tiếng Anh một cách thú vị',
                        maxLines: 7, // More lines for better text display
                        style: TextStyle(
                          fontSize: Fontsize.smaller *
                              0.8, // Smaller font for description
                          color: AppColor.gray,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserService userService = Get.find<UserService>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     ImageButton(
          //       onTap: () {
          //         // userService.onPressStarBoard(isValidate: false);
          //       },
          //       pathImage: LocalImage.numOfStar,
          //       width: 0.06 * size.width,
          //       height: 0.06 * size.width,
          //     ),
          //     RegularText('star_board_title'.tr, style: TextStyle(fontSize: Fontsize.smaller, color: AppColor.yellow),)
          //   ],
          // ),
          // SizedBox(
          //   width: 0.02 * size.height,
          // ),
          GestureDetector(
            onTap: () {
              // userService.onPressProfile();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(0.035 * size.height),
              ),
              padding: EdgeInsets.all(0.002 * size.height),
              width: 0.2 * size.width,
              height: 0.06 * size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.shapeAvatar),
                        fit: BoxFit.fill,
                      ),
                    ),
                    width: 0.055 * size.width,
                    height: 0.055 * size.width,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.04 * size.width),
                        child: CacheImage(
                          url: userService.currentUser.avatar,
                          width: 0.04 * size.width,
                          height: 0.04 * size.width,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 0.01 * size.width),
                  SizedBox(
                    width: 0.12 * size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RegularText(
                          userService.currentUser.name,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColor.red,
                            fontWeight: FontWeight.w800,
                            fontSize: Fontsize.small + 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
