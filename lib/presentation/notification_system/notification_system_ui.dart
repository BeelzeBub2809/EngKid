import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/auto_notification/auto_notification.dart';
import 'package:EngKid/presentation/notification_system/notification_system_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:sizer/sizer.dart';

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
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (controller.focusNode.hasFocus) {
                  controller.focusNode.unfocus();
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(LocalImage.spaceBg),
                    fit: BoxFit.fill,
                  ),
                ),
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: LibFunction.scaleForCurrentValue(
                          size,
                          72,
                          desire: 1,
                        ),
                      ),
                      Container(
                        width: 0.85 * size.width,
                        height: 0.06 * size.height,
                        margin: EdgeInsets.only(top: size.width * 0.03),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(LocalImage.boxSearchMessage),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: TextField(
                            controller: controller.textEditingController,
                            obscureText: false,
                            focusNode: controller.focusNode,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            onChanged: (String value) {
                              controller.textSearch = value;
                            },
                            decoration: InputDecoration(
                              hintText: "".tr,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(
                                  color: AppColor.gray,
                                  fontSize: Fontsize.smaller,
                                  fontWeight:
                                      FontWeight.w500), // Màu của placeholder
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: Colors
                                      .transparent, // Màu cho border bình thường
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors
                                      .transparent, // Màu cho border khi focus
                                  width: 0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors
                                      .transparent, // Màu cho border khi không focus
                                  width: 0,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: EdgeInsets.all(
                                  LibFunction.scaleForCurrentValue(size, 64)),
                              labelText: "",
                              fillColor: Colors.transparent,
                              filled: true,
                              labelStyle: const TextStyle(
                                color: AppColor.gray,
                              ),
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: Obx(() => controller.textSearch != ""
                                  ? InkWell(
                                      onTap: () {
                                        controller.textEditingController.text =
                                            "";
                                        controller.textSearch = "";
                                        controller.focusNode.unfocus();
                                      },
                                      child: const Icon(Icons.close,
                                          color: Colors.grey))
                                  : const SizedBox.shrink()),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.02 * size.height,
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: LibFunction.scaleForCurrentValue(
                                size,
                                24,
                                desire: 1,
                              ),
                            ),
                            child: Container(
                              width: size.width,
                              height: 0.8 * size.height,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.01 * size.width),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(LocalImage.feedbackFormBg),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Obx(
                                        () => InkWell(
                                          onTap: () {
                                            controller.tabActive = 0;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 64),
                                              // vertical: LibFunction.scaleForCurrentValue(size, 16),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 12),
                                            ),
                                            height: LibFunction
                                                .scaleForCurrentValue(
                                              size,
                                              46,
                                              desire: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller.tabActive == 0
                                                  ? AppColor.red
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.04 * size.width),
                                              border: Border.all(
                                                width: 1,
                                                color: controller.tabActive == 0
                                                    ? AppColor.red
                                                    : AppColor.gray,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "important".tr,
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                0
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: Fontsize.smallest,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "(${controller.systemNotifications.where((element) => element.notiType == 0 && element.type == 2).length})",
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                0
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: 7.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => InkWell(
                                          onTap: () {
                                            controller.tabActive = 1;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 64),
                                              // vertical: LibFunction.scaleForCurrentValue(size, 16),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 12),
                                            ),
                                            height: LibFunction
                                                .scaleForCurrentValue(
                                              size,
                                              46,
                                              desire: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller.tabActive == 1
                                                  ? AppColor.red
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.04 * size.width),
                                              border: Border.all(
                                                width: 1,
                                                color: controller.tabActive == 1
                                                    ? AppColor.red
                                                    : AppColor.gray,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "btvn".tr,
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                1
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: Fontsize.smallest,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "(${controller.systemNotifications.where((element) => element.notiType == 1 && element.type == 2).length})",
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                1
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: 7.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => InkWell(
                                          onTap: () {
                                            controller.tabActive = 2;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 64),
                                              // vertical: LibFunction.scaleForCurrentValue(size, 16),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 12),
                                            ),
                                            height: LibFunction
                                                .scaleForCurrentValue(
                                              size,
                                              46,
                                              desire: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller.tabActive == 2
                                                  ? AppColor.red
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.04 * size.width),
                                              border: Border.all(
                                                width: 1,
                                                color: controller.tabActive == 2
                                                    ? AppColor.red
                                                    : AppColor.gray,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "reading_process".tr,
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                2
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: Fontsize.smallest,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "(${controller.systemNotifications.where((element) => element.notiType == -1 && element.type == 1).length})",
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                2
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: 7.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => InkWell(
                                          onTap: () {
                                            controller.tabActive = 3;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 64),
                                              // vertical: LibFunction.scaleForCurrentValue(size, 16),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: LibFunction
                                                  .scaleForCurrentValue(
                                                      size, 12),
                                            ),
                                            height: LibFunction
                                                .scaleForCurrentValue(
                                              size,
                                              46,
                                              desire: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller.tabActive == 3
                                                  ? AppColor.red
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.04 * size.width),
                                              border: Border.all(
                                                width: 1,
                                                color: controller.tabActive == 3
                                                    ? AppColor.red
                                                    : AppColor.gray,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "interact".tr,
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                3
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: Fontsize.smallest,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "(${controller.systemNotifications.where((element) => element.notiType == -1 && element.type == 2).length})",
                                                  style: TextStyle(
                                                    color:
                                                        controller.tabActive ==
                                                                3
                                                            ? Colors.white
                                                            : const Color(
                                                                0xff606060),
                                                    fontSize: 7.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: LibFunction.scaleForCurrentValue(
                                      size,
                                      12,
                                      desire: 1,
                                    ),
                                  ),
                                  Obx(
                                    () => controller.isLoading
                                        ? Expanded(
                                            child: LoadingDialog(
                                              sizeIndi: 0.2 * size.width,
                                              color: AppColor.blue,
                                              des: "",
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      final list = controller.getListByTab(
                                        controller.systemNotifications,
                                        controller.textSearch,
                                      );
                                      // controller.feedbacks
                                      //     .where((element) =>
                                      //         (controller.listType == "important" &&
                                      //             element.isImportant == 1) ||
                                      //         controller.listType != "important")
                                      //     .toList();
                                      return controller.isLoading
                                          ? const SizedBox.shrink()
                                          : ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              // reverse: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: list.length,
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: 0.01 * size.height,
                                                );
                                              },
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 0.1 * size.width,
                                              ),
                                              itemBuilder: (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                final notification =
                                                    list[index];
                                                DateTime dateTime =
                                                    DateTime.parse(
                                                        notification.createdAt);

                                                DateTime now = DateTime.now();

                                                Duration difference =
                                                    now.difference(dateTime);

                                                int dayssDifference =
                                                    difference.inDays;

                                                late String timeText =
                                                    "$dayssDifference ${"day".tr}";
                                                if (dayssDifference == 0) {
                                                  int hoursDifference =
                                                      difference.inHours;
                                                  timeText =
                                                      "$hoursDifference ${"hour".tr}";
                                                  if (hoursDifference == 0) {
                                                    int minutesDifference =
                                                        difference.inMinutes;
                                                    timeText =
                                                        "$minutesDifference ${"minute".tr}";
                                                    if (minutesDifference ==
                                                        0) {
                                                      int secondsDifference =
                                                          difference.inSeconds;
                                                      timeText =
                                                          "$secondsDifference ${"second".tr}";
                                                    }
                                                  }
                                                }
                                                String type = "";
                                                if (notification.notiType ==
                                                        0 &&
                                                    notification.type == 2) {
                                                  type = "important";
                                                }
                                                if (notification.notiType ==
                                                        1 &&
                                                    notification.type == 2) {
                                                  type = "btvn";
                                                }
                                                if (notification.notiType ==
                                                        -1 &&
                                                    notification.type == 1) {
                                                  type = "reading_process";
                                                }
                                                if (notification.notiType ==
                                                        -1 &&
                                                    notification.type == 2) {
                                                  type = "interact";
                                                }

                                                return Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        controller
                                                            .handleReadNotification(
                                                                notification);
                                                      },
                                                      child: Image.asset(
                                                        notification.isRead == 1
                                                            ? LocalImage
                                                                .checkboxChecked
                                                            : LocalImage
                                                                .checkboxUnChecked,
                                                        width:
                                                            0.08 * size.width,
                                                        height:
                                                            0.08 * size.width,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 0.03 * size.width,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(
                                                          LibFunction
                                                              .scaleForCurrentValue(
                                                            size,
                                                            48,
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                              12,
                                                            ),
                                                          ),
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xffD9D9D9),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: NotificationItem(
                                                          notification:
                                                              notification,
                                                          controller:
                                                              controller,
                                                          type: type,
                                                          timeText: timeText,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                    }),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 0.05 * size.width,
              right: 0.03 * size.width,
              child: Align(
                alignment: Alignment.topRight,
                child: ImageButton(
                  onTap: () {
                    // Get.toNamed(AppRoute.notificationSetting);
                  },
                  semantics: 'settings',
                  pathImage: LocalImage.settingRed,
                  height: 0.12 * size.width,
                  width: 0.12 * size.width,
                ),
              ),
            ),
          ],
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
                Container(
                  padding: EdgeInsets.all(
                    LibFunction.scaleForCurrentValue(
                      size,
                      24,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xffF6B0BD),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        4,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.type.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Fontsize.smallest,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  "${widget.timeText} ${"before".tr}",
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
