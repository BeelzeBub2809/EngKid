import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/child_profile/entities/entities.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/swiper/CustomSwiperControl.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

class DialogChangeAcc extends StatefulWidget {
  const DialogChangeAcc({
    super.key,
  });

  @override
  State<DialogChangeAcc> createState() => _DialogChangeAccState();
}

class _DialogChangeAccState extends State<DialogChangeAcc> {
  final NetworkService _networkService = Get.find<NetworkService>();
  final UserService _userService = Get.find<UserService>();
  final TopicService _topicService = Get.find<TopicService>();
  late bool isChangeChild = false;

  void onChangeChild(Child child) async {
    if (_networkService.networkConnection.value) {
      setState(() {
        isChangeChild = true;
      });
      _userService.currentUser = child;
      try {
        // await _topicService.getLibrary();
        // await _userService.removeDeviceToken();
        // _userService.handleSendDeviceToken();
        // _userService.newLoginRecord();
        setState(() {
          Get.back(); // hide dialog
          // Get.back(); // back to grade
          isChangeChild = false;
        });
        // Get.offAllNamed(AppRoute.kidSpace);
      } catch (_) {
        LibFunction.toast('error_handle');
        setState(() {
          isChangeChild = false;
        });
      }
    } else {
      LibFunction.toast('require_network_to_change_child');
    }
  }

  int indexCurrentUserInChildProfiles() {
    return _userService.childProfiles.childProfiles
        .indexWhere((element) => element.userId == _userService.currentUser.userId);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      content: isChangeChild
          ? Center(
              child: SizedBox(
                width: 0.7 * size.height,
                height: 0.7 * size.height,
                child: const LoadingDialog(),
              ),
            )
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.back();
              },
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.06 * size.height),
                      child: RegularText(
                        "change_acc",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Fontsize.bigger,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.65 * size.height,
                      width: size.width,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              2,
                              (idx) => idx + index * 2 <
                                      _userService
                                          .childProfiles.childProfiles.length
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.025 * size.width),
                                      child: GestureDetector(
                                        onTap: () {
                                          onChangeChild(_userService
                                              .childProfiles
                                              .childProfiles[idx + index * 2]);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 0.4 * size.height,
                                                  height: 0.4 * size.height,
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        LocalImage.shapeAvatar,
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.35 *
                                                                  size.height),
                                                      child: CacheImage(
                                                        url: _userService
                                                            .childProfiles
                                                            .childProfiles[
                                                                idx + index * 2]
                                                            .avatar,
                                                        width:
                                                            0.35 * size.height,
                                                        height:
                                                            0.35 * size.height,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Obx(
                                                //   () =>
                                                //       indexCurrentUserInChildProfiles() !=
                                                //               idx + index * 2
                                                //           ? Positioned.fill(
                                                //               child: Align(
                                                //                 alignment:
                                                //                     Alignment
                                                //                         .topCenter,
                                                //                 child:
                                                //                     Image.asset(
                                                //                   LocalImage
                                                //                       .gradeShapeDisable,
                                                //                   width: 0.4 *
                                                //                       size.height,
                                                //                   height: 0.4 *
                                                //                       size.height,
                                                //                 ),
                                                //               ),
                                                //             )
                                                //           : const SizedBox(),
                                                // )
                                              ],
                                            ),
                                            SizedBox(
                                                height: 0.02 * size.height),
                                            ImageText(
                                              onTap: () {},
                                              pathImage: LocalImage.shapeName,
                                              text: _userService
                                                  .childProfiles
                                                  .childProfiles[
                                                      idx + index * 2]
                                                  .name,
                                              style: TextStyle(
                                                color:
                                                    indexCurrentUserInChildProfiles() ==
                                                            idx + index * 2
                                                        ? AppColor.organe
                                                        : Colors.grey,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Fontsize.larger,
                                                height: 0.8,
                                              ),
                                              textAlign: TextAlign.center,
                                              width: 0.26 * size.width,
                                              height: 0.12 * size.height,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          );
                        },
                        itemCount:
                            (_userService.childProfiles.childProfiles.length /
                                    2)
                                .ceil(),
                        // pagination: const SwiperPagination(),
                        control: SwiperControlCustom(
                          width: 0.06 * size.width,
                          height: 0.06 * size.width,
                          iconNext: LocalImage.nextAcc,
                          iconPrevious: LocalImage.backAcc,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          padding: EdgeInsets.only(
                            bottom: 0.03 * size.height,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.18,
                      height: size.height * 0.12,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
