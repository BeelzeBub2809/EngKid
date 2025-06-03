import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/home/home_screen_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/swiper/CustomSwiperControl.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({Key? key}) : super(key: key);
  String renderNumberBadges(int num) {
    return num.toString().length >= 3 ? "99+" : num.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserService userService = Get.find<UserService>();
    double screenWidth = MediaQuery.of(context).size.width;
    double fSize = Fontsize.small;

    //List menu on the right side edge of the screen
    final List<MenuRight> menuRights = [
      MenuRight(
          label: "share",
          count: 0,
          icon: LocalImage.iconShare,
          onTap: () {
            controller.shareMyApp();
          }),
    ];
    if (screenWidth < 900) {
      fSize = Fontsize.small;
    } else if (screenWidth < 1200 && screenWidth > 900) {
      fSize = Fontsize.smallest;
    }

    return Stack(
      children: [
        Scaffold(
          body: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImage.spaceBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 0.88 * size.width,
                  height: 0.95 * size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(LocalImage.shapeBook),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 0.07 * size.width,
                      right: 0.07 * size.width,
                      top: 0.05 * size.height,
                      bottom: 0.05 * size.height,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageText(
                                pathImage: LocalImage.shapeSpaceStudent,
                                width: 0.3 * size.width,
                                height: 0.1 * size.height,
                                text: "world_of",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Fontsize.larger,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: RegularText(
                                  userService.childProfiles.childProfiles.isNotEmpty
                                      ? "select_account_remind"
                                      : 'Hãy tạo tài khoản cho các con nhé!',
                                  style: TextStyle(
                                    color: AppColor.gray,
                                    fontSize: Fontsize.smallest,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 0.05 * size.height,
                              ),
                              Obx(
                                () => userService.childProfiles.childProfiles.isNotEmpty
                                    ? SizedBox(
                                        width: 0.3 * size.width,
                                        height: 0.32 * size.height,
                                        child: Swiper(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (userService.userLogin.roleId ==
                                                "2") {
                                              return Stack(
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      width: 0.24 * size.height,
                                                      height:
                                                          0.24 * size.height,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0XFFfdf1ce),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(0.23 *
                                                                  size.height),
                                                          child: CacheImage(
                                                            url: userService
                                                                .userLogin
                                                                .image,
                                                            width: 0.23 *
                                                                size.height,
                                                            height: 0.23 *
                                                                size.height,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                      child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: ImageText(
                                                      pathImage:
                                                          LocalImage.shapeName,
                                                      text: userService
                                                          .userLogin.name,
                                                      style: TextStyle(
                                                        color: AppColor.gray,
                                                        fontSize:
                                                            Fontsize.larger,
                                                        height: 1.2,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      width: 0.23 * size.width,
                                                      height: 0.1 * size.height,
                                                      onTap: controller
                                                          .copyDeviceTokenToClipboard,
                                                    ),
                                                  ))
                                                ],
                                              );
                                            }
                                            return Stack(
                                              children: [
                                                Center(
                                                  child: Container(
                                                    width: 0.24 * size.height,
                                                    height: 0.24 * size.height,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0XFFfdf1ce),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.23 *
                                                                    size.height),
                                                        child: CacheImage(
                                                          url: userService
                                                              .childProfiles
                                                              .childProfiles[
                                                                  index]
                                                              .avatar,
                                                          width: 0.23 *
                                                              size.height,
                                                          height: 0.23 *
                                                              size.height,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: ImageText(
                                                    pathImage:
                                                        LocalImage.shapeName,
                                                    text: userService
                                                        .childProfiles
                                                        .childProfiles[index]
                                                        .name,
                                                    style: TextStyle(
                                                      color: AppColor.gray,
                                                      fontSize: fSize,
                                                      height: 1.2,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    width: 0.23 * size.width,
                                                    height: 0.1 * size.height,
                                                    onTap: controller
                                                        .copyDeviceTokenToClipboard,
                                                  ),
                                                ))
                                              ],
                                            );
                                          },
                                          index: userService.userLogin.roleId ==
                                                  "2"
                                              ? 0
                                              : controller
                                                  .indexCurrentUserInChildProfiles(),
                                          onIndexChanged: (int index) {
                                            if (userService.userLogin.roleId ==
                                                "2") {
                                              return;
                                            }

                                            controller.onChangeChild(userService
                                                .childProfiles
                                                .childProfiles[index]);
                                          },
                                          itemCount:
                                              userService.userLogin.roleId ==
                                                      "2"
                                                  ? 1
                                                  : userService.childProfiles
                                                      .childProfiles.length,
                                          control: SwiperControlCustom(
                                            width: 0.035 * size.width,
                                            height: 0.035 * size.width,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        LocalImage.children,
                                        width: size.width * 0.15,
                                        height: size.height * 0.3,
                                        fit: BoxFit.cover,
                                      ),
                              ),

                              SizedBox(
                                height: 0.02 * size.height,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageText(
                                    text: 'e_book',
                                    pathImage: LocalImage.buttonElibrary,
                                    isUpperCase: true,
                                    width: size.width * 0.16,
                                    height: size.height * 0.13,
                                    onTap: () {
                                      controller.onPressLibrary();
                                    },
                                  ),
                                  SizedBox(
                                    width: size.width * 0.01,
                                  ),
                                  ImageText(
                                    text: 'reading',
                                    pathImage: LocalImage.shapeButton,
                                    isUpperCase: true,
                                    width: size.width * 0.16,
                                    height: size.height * 0.13,
                                    onTap: () {
                                      controller.onPressStart();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 0.03 * size.width,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(children: [
                            ImageText(
                              pathImage: LocalImage.shapeSpaceParent,
                              width: 0.3 * size.width,
                              height: 0.1 * size.height,
                              text: "area_of_parent",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Fontsize.larger,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: SizedBox(
                                  width: size.width * 0.35,
                                  height: size.height * 0.7,
                                  child: GridView.builder(
                                    itemCount: controller.menus.length,
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (context, index) =>
                                        SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Obx(
                                            () => badges.Badge(
                                              showBadge: controller
                                                      .menus[index].count !=
                                                  0,
                                              position:
                                                  badges.BadgePosition.topEnd(
                                                      top: -5, end: -5),
                                              badgeStyle:
                                                  const badges.BadgeStyle(
                                                badgeColor: AppColor.red,
                                                shape: badges.BadgeShape.circle,
                                              ),
                                              badgeContent: Text(
                                                renderNumberBadges(controller
                                                    .menus[index].count),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Fontsize.small,
                                                ),
                                              ),
                                              child: SizedBox(
                                                width: size.width * 0.06,
                                                height: size.width * 0.06,
                                                child: ImageButton(
                                                  pathImage: controller
                                                      .menus[index].pathImage,
                                                  onTap: () {
                                                    controller.onPressTo(
                                                      controller.menus[index],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: (0.1) * size.height,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: 0.01 * size.height,
                                              ),
                                              child: RegularText(
                                                controller.menus[index].name,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: AppColor.gray,
                                                  fontSize: Fontsize.smallest,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 0.05 * size.height,
                        ),
                        ImageButton(
                          pathImage: LocalImage.logout,
                          width: LibFunction.scaleForCurrentValue(size, 96),
                          height: LibFunction.scaleForCurrentValue(size, 96),
                          onTap: () async {
                            Get.back();
                            userService.logout();
                          },
                        ),
                        Text('logout'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Fontsize.small,
                            fontWeight: FontWeight.bold,
                          ),),

                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: LibFunction.scaleForCurrentValue(
                              size,
                              16,
                              desire: 1,
                            ),
                          ),
                          // padding: EdgeInsets.symmetric(
                          //   vertical: LibFunction.scaleForCurrentValue(
                          //     size,
                          //     42,
                          //     desire: 1,
                          //   ),
                          // ),
                          decoration: BoxDecoration(
                              // color: Colors.black.withOpacity(0.1),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: menuRights.map((el) {
                              return GestureDetector(
                                onTap: el.onTap,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        LibFunction.scaleForCurrentValue(
                                      size,
                                      8,
                                    ),
                                    vertical: LibFunction.scaleForCurrentValue(
                                      size,
                                      24,
                                      desire: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              LibFunction.scaleForCurrentValue(
                                            size,
                                            8,
                                          ),
                                        ),
                                        child: badges.Badge(
                                          showBadge: el.count != 0,
                                          position: badges.BadgePosition.topEnd(
                                              top: -5, end: -5),
                                          badgeStyle: const badges.BadgeStyle(
                                            badgeColor: AppColor.red,
                                            shape: badges.BadgeShape.circle,
                                          ),
                                          badgeContent: Text(
                                            renderNumberBadges(el.count),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Fontsize.smallest,
                                            ),
                                          ),
                                          child: Image.asset(
                                            el.icon,
                                            width: LibFunction
                                                .scaleForCurrentValue(
                                              size,
                                              112,
                                              desire: 0,
                                            ),
                                            height: LibFunction
                                                .scaleForCurrentValue(
                                              size,
                                              112,
                                              desire: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            LibFunction.scaleForCurrentValue(
                                          size,
                                          8,
                                          desire: 1,
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Text(
                                            el.label.tr,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: Fontsize.small,
                                              fontWeight: FontWeight.w600,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 1
                                                ..color = Colors.white,
                                            ),
                                          ),
                                          Text(
                                            el.label.tr,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Fontsize.small,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => controller.isChangeChild
              ? Container(color: Colors.black38, child: const LoadingDialog())
              : const Text(''),
        )
      ],
    );
  }
}

class MenuRight {
  final String label;
  final String icon;
  final int count;
  final void Function()? onTap;
  MenuRight({
    required this.label,
    required this.icon,
    required this.count,
    this.onTap,
  });
}
