import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/auto_notification/auto_notification.dart';
import 'package:EngKid/presentation/notification_system/notification_system_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';

class NotificationSystemScreen extends GetView<NotificationSystemController> {
  const NotificationSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        controller.getNofiKidSpace();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(LocalImage.backgroundBlue),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02,
                  ),
                  child: Row(
                    children: [
                      ImageButton(
                        onTap: () {
                          controller.getNofiKidSpace();
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeRight,
                            DeviceOrientation.landscapeLeft,
                          ]);
                          Get.back();
                        },
                        semantics: 'back',
                        pathImage: LocalImage.backNoShadow,
                        height: size.width * 0.08,
                        width: size.width * 0.08,
                      ),
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: Text(
                          'THÔNG BÁO',
                          style: TextStyle(
                            color: AppColor.red,
                            fontWeight: FontWeight.bold,
                            fontSize: Fontsize.large,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Container(
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColor.red, width: 2),
                    ),
                    child: TextField(
                      controller: controller.textEditingController,
                      focusNode: controller.focusNode,
                      textInputAction: TextInputAction.search,
                      cursorColor: Colors.black,
                      onChanged: (String value) {
                        controller.debouncedSearch();
                      },
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm thông báo...",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: Fontsize.normal,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.015,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: size.width * 0.05,
                        ),
                        suffixIcon: Obx(() => controller.textSearch.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.textEditingController.clear();
                                  controller.textSearch = "";
                                  controller.focusNode.unfocus();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.grey[400],
                                  size: size.width * 0.05,
                                ),
                              )
                            : const SizedBox.shrink()),
                      ),
                      enableSuggestions: true,
                      autocorrect: false,
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // Main content area
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFF4CAF50), width: 3),
                    ),
                    child: Column(
                      children: [
                        // Content area
                        Expanded(
                          child: Obx(() {
                            if (controller.isLoading) {
                              return Center(
                                child: LoadingDialog(
                                  sizeIndi: size.width * 0.15,
                                  color: AppColor.blue,
                                  des: "",
                                ),
                              );
                            }

                            final list = controller.getPaginatedNotifications();

                            if (list.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.notifications_none,
                                      size: size.width * 0.15,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    Text(
                                      'Chưa có thông báo nào',
                                      style: TextStyle(
                                        fontSize: Fontsize.normal,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.all(size.width * 0.04),
                                    itemCount: list.length,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                          height: size.height * 0.015);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final notification = list[index];
                                      DateTime dateTime = DateTime.parse(
                                          notification.createdAt);
                                      DateTime now = DateTime.now();
                                      Duration difference =
                                          now.difference(dateTime);
                                      int daysDifference = difference.inDays;

                                      late String timeText =
                                          "$daysDifference ${"day".tr}";
                                      if (daysDifference == 0) {
                                        int hoursDifference =
                                            difference.inHours;
                                        timeText =
                                            "$hoursDifference ${"hour".tr}";
                                        if (hoursDifference == 0) {
                                          int minutesDifference =
                                              difference.inMinutes;
                                          timeText =
                                              "$minutesDifference ${"minute".tr}";
                                          if (minutesDifference == 0) {
                                            int secondsDifference =
                                                difference.inSeconds;
                                            timeText =
                                                "$secondsDifference ${"second".tr}";
                                          }
                                        }
                                      }

                                      // Show all notifications without type filtering
                                      return Container(
                                        padding:
                                            EdgeInsets.all(size.width * 0.03),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: NotificationItem(
                                          notification: notification,
                                          controller: controller,
                                          type: 'thông báo',
                                          timeText: timeText,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // Pagination controls
                                if (controller.totalPages > 1)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04,
                                      vertical: size.height * 0.02,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Previous button
                                        InkWell(
                                          onTap: controller.currentPage > 1
                                              ? controller.goToPreviousPage
                                              : null,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.04,
                                              vertical: size.height * 0.01,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller.currentPage > 1
                                                  ? AppColor.blue
                                                  : Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  color:
                                                      controller.currentPage > 1
                                                          ? Colors.white
                                                          : Colors.grey[500],
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.01),
                                                Text(
                                                  'Trước',
                                                  style: TextStyle(
                                                    color:
                                                        controller.currentPage >
                                                                1
                                                            ? Colors.white
                                                            : Colors.grey[500],
                                                    fontSize: Fontsize.small,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Page indicator
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.04,
                                            vertical: size.height * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColor.blue.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Trang ${controller.currentPage}/${controller.totalPages}',
                                            style: TextStyle(
                                              color: AppColor.blue,
                                              fontSize: Fontsize.small,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        // Next button
                                        InkWell(
                                          onTap: controller.currentPage <
                                                  controller.totalPages
                                              ? controller.goToNextPage
                                              : null,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.04,
                                              vertical: size.height * 0.01,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller.currentPage <
                                                      controller.totalPages
                                                  ? AppColor.blue
                                                  : Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Sau',
                                                  style: TextStyle(
                                                    color:
                                                        controller.currentPage <
                                                                controller
                                                                    .totalPages
                                                            ? Colors.white
                                                            : Colors.grey[500],
                                                    fontSize: Fontsize.small,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.01),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: controller
                                                              .currentPage <
                                                          controller.totalPages
                                                      ? Colors.white
                                                      : Colors.grey[500],
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.controller,
    required this.type,
    required this.timeText,
  });

  final AutoNotification notification;
  final NotificationSystemController controller;

  final String type;
  final String timeText;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool isOverflowingTitle = false;
  bool isOverflowingContent = false;
  final GlobalKey _key = GlobalKey();
  double? width;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidth();
      _checkOverflow();
    });
  }

  void _getWidth() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      width = renderBox.size.width;
    });
  }

  void _checkOverflow() {
    if (width == null) return;
    final textPainterTitle = TextPainter(
      text: TextSpan(
        text: widget.notification.title,
        style: TextStyle(
          fontSize: Fontsize.smallest,
          fontWeight: FontWeight.w600,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width!);

    final textPainterContent = TextPainter(
      text: TextSpan(
        text: widget.notification.content,
        style: TextStyle(
          fontSize: Fontsize.normal,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width!);

    setState(() {
      isOverflowingTitle = textPainterTitle.didExceedMaxLines;
      isOverflowingContent = textPainterContent.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.notification.title != "")
            Obx(
              () => Text(
                widget.notification.title,
                maxLines: widget.controller.idShowMore
                        .contains(widget.notification.id)
                    ? null
                    : 1,
                overflow: widget.controller.idShowMore
                        .contains(widget.notification.id)
                    ? null
                    : TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xff333333),
                  fontSize: Fontsize.small,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: LibFunction.scaleForCurrentValue(
                size,
                16,
              ),
            ),
            child: Row(
              children: [
                Expanded(child: Container()),
                Text(
                  "${widget.timeText} trước",
                  style: TextStyle(
                    color: const Color(0xff666666),
                    fontSize: Fontsize.smallest,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Text(
              widget.notification.content,
              overflow:
                  widget.controller.idShowMore.contains(widget.notification.id)
                      ? null
                      : TextOverflow.ellipsis,
              maxLines:
                  widget.controller.idShowMore.contains(widget.notification.id)
                      ? null
                      : 1,
              style: TextStyle(
                color: const Color(0xff333333),
                fontSize: Fontsize.normal,
              ),
            ),
          ),
          if (isOverflowingTitle || isOverflowingContent)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (widget.controller.idShowMore
                        .contains(widget.notification.id)) {
                      final List<int> tmp = widget.controller.idShowMore
                          .where((id) => id != widget.notification.id)
                          .toList();
                      widget.controller.idShowMore = tmp;
                    } else {
                      widget.controller.idShowMore.add(widget.notification.id);
                    }
                  },
                  child: Obx(
                    () => Icon(
                      widget.controller.idShowMore
                              .contains(widget.notification.id)
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
