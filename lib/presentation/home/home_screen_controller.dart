import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/entities/child_profile/entities/entities.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/background_audio_control.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:audio_session/audio_session.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreenController extends GetxController with WidgetsBindingObserver {
  HomeScreenController();

  final TopicService _topicService = Get.find<TopicService>();
  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();
  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final player = AudioPlayer();
  bool isElibraryOpen = false;
  // final _preferencesManager = getIt<SharedPreferencesManager>();

  final RxBool _isChangeChild = false.obs;

  bool get isChangeChild => _isChangeChild.value;

  //List of menu on the right side of home screen (parent space)
  final RxList<Menu> menus = [
    Menu(
      name: 'library',
      pathImage: LocalImage.library,
      to: AppRoute.myLibrary,
      needValidateParent: true,
      requireValidate: true,
      arguments: false, // if is library then ques cannot caculator score
      count: 0,
    ),
    Menu(
      name: 'settings_and_management',
      pathImage: LocalImage.setting,
      to: AppRoute.managementSpace,
      needValidateParent: true,
      requireValidate: true,
      arguments: 'settings',
      count: 0,
    ),
  ].obs;

  void onPressTo(Menu menu) async {
    handleGetData(menu.to);

    if (!menu.needValidateParent && !menu.requireValidate) {
      if (menu.to == "") {
        LibFunction.toast('is_updating');
        return;
      }
      Get.toNamed(menu.to, arguments: menu.arguments);
    } else if (menu.needValidateParent) {
      if (menu.to == "") {
        LibFunction.toast('is_updating');
        return;
      }
      if (await _userService.validateParent()) {
        Get.toNamed(menu.to, arguments: menu.arguments);
      }
    } else {
      if (menu.to == "") {
        LibFunction.toast('is_updating');
        return;
      }
      Get.toNamed(menu.to, arguments: menu.arguments);
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    player.setAndroidAudioAttributes(
        const AndroidAudioAttributes(usage: AndroidAudioUsage.media));
  }


  void shareMyApp() {
    String appLink = '';
    const appLinkIos = 'https://apps.apple.com/vn/app/vui-%C4%91%E1%BB%8Dc-c%C3%B9ng-em/id6711332921';
    const appLinkAndroid= 'https://play.google.com/store/apps/details?id=com.EngKid.readingapp&pcampaignid=web_share';

    if(Platform.isIOS){
      appLink = appLinkIos;
    }else {
      appLink = appLinkAndroid;
    }


    Share.share(appLink, subject: 'Vui đọc cùng em');
  }

  void handleGetData(String to) {
    switch (to) {
        case AppRoute.myLibrary:
        _topicService.getGradesFromStorage(
          isAwait: true,
        );
        break;
    }
  }

  void onPressStart() async {
    //custom for teacher

    if (_userService.userLogin.roleId == "2") return;
    _topicService.getGradesFromStorage();
    Get.toNamed(AppRoute.myLibrary, arguments: true);
  }

  void onPressLibrary() async {
    if (_userService.userLogin.roleId == "2") return;
    if (_userService.currentUser.surveyPassed) {
      if (isElibraryOpen == false) {
        if (_networkService.networkConnection.value) {
          isElibraryOpen = true;
          Get.toNamed(
            AppRoute.eLibrary,
            arguments: [true, true],
          );
        } else {
          LibFunction.toast('require_network_to_elibrary');
        }
      } else {
        Get.toNamed(
          AppRoute.eLibrary,
          arguments: [true, true],
        );
      }
    } else {
      // Get.toNamed(
      //   AppRoute.safetyGuide,
      //   arguments: [
      //     true,
      //     true,
      //     true
      //   ], // allow button back and to learn, go to elibrary
      // );
    }
  }

  int indexCurrentUserInChildProfiles() {
    return _userService.childProfiles.childProfiles
        .indexWhere((element) => element.id == _userService.currentUser.id);
  }

  void onChangeChild(Child child) async {
    if (_networkService.networkConnection.value) {
      _isChangeChild.value = true;
      _userService.currentUser = child;
      try {
        // await _topicService.getLibrary();
        _isChangeChild.value = false;
        // await _userService.removeDeviceToken();
        // _userService.handleSendDeviceToken();
      } catch (_) {
        LibFunction.toast('error_handle');
        _isChangeChild.value = false;
      }
    } else {
      LibFunction.toast('require_network_to_change_child');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("app in resumed");
        if (BackgroundAudioControl.instance.isPlaying) {
          LibFunction.rePlayBackgroundSound();
        }
        break;
      case AppLifecycleState.inactive:
        debugPrint("app in inactive");
        if (BackgroundAudioControl.instance.isPlaying) {}
        LibFunction.pauseBackgroundSound();
        break;
      case AppLifecycleState.paused:
        debugPrint("app in paused");
        LibFunction.pauseBackgroundSound();

        break;
      case AppLifecycleState.detached:
        debugPrint("app in detached");
        LibFunction.pauseBackgroundSound();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void copyDeviceTokenToClipboard() async {
    final String? deviceToken =
        _preferencesManager.getString(KeySharedPreferences.deviceToken);
    //custom for teacher
    await Clipboard.setData(ClipboardData(text: deviceToken ?? ""));
  }


  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}

class Menu {
  final String name;
  final String pathImage;
  final String to;
  final bool needValidateParent;
  final bool requireValidate;
  final dynamic arguments;
  int count;
  Menu({
    required this.name,
    required this.pathImage,
    required this.to,
    required this.needValidateParent,
    required this.requireValidate,
    required this.arguments,
    required this.count,
  });
}
