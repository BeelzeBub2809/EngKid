import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/login/entities/login/login.dart';
import 'package:EngKid/domain/login/login_usecases.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/cache_control.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';

enum ForgotPassInputType { email, otp, password, confirmPassword, }

class ForgotPassController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  ForgotPassController();

  final _preferencesManager = getIt<SharedPreferencesManager>();

  final RxString _email = ''.obs;
  final RxString _password = ''.obs;
  final RxString _confirmPassword = ''.obs;
  final RxString _otp = ''.obs;
  final RxBool _isiOS13later = false.obs;
  final RxBool _isChecked = false.obs;
  final RxBool _isForgotPassword = false.obs;
  final RxString _subString = "enter_id".obs;

  String get email => _email.value;
  String get password => _password.value;
  bool get isIOS13Later => _isiOS13later.value;
  bool get isChecked => _isChecked.value;
  bool get isForgotPassword => _isForgotPassword.value;
  String get subString => _subString.value;
  String get confirmPassword => _confirmPassword.value;
  String get otp => _otp.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint('Init Login Controller');
    if (Platform.isIOS) {
      final int deviceOSVersion = int.parse(
        Platform.operatingSystemVersion
            .split('.')[0]
            .replaceAll("Version ", ""),
      );
      if (deviceOSVersion >= 13) {
        _isiOS13later.value = true;
      }
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   // if (!_userService.ignoreUpdate && _userService.appVersion.needUpdate) {
  //   //   Get.dialog(
  //   //     UpdateDialog(),
  //   //     barrierDismissible: false,
  //   //   );
  //   // }
  // }

  // Future<void> getLanguagues() async {
  //   _userService.getRemoteLanguages();
  // }


  void onChangeInput({required String input, required ForgotPassInputType type}) {
    switch (type) {
      case ForgotPassInputType.email:
        _email.value = input;
        break;
      case ForgotPassInputType.otp:
        _otp.value = input;
        break;
      case ForgotPassInputType.password:
        _password.value = input;
        break;
      case ForgotPassInputType.confirmPassword:
        _confirmPassword.value = input;
        break;
      default:
        break;
    }
  }

  void onForgotIdentifier() async {
    await LibFunction.effectConfirmPop();
    // Get.toNamed(AppRoute.forgotIdentifier);
  }

  Future<void> _configureUserProfile(Login userProfile) async {
    CacheControl.instance.getFileStream(userProfile.image);
    await _preferencesManager.putString(
      key: KeySharedPreferences.token,
      value: userProfile.token,
    );
    await _userService.assignUseLogin(userProfile); //set to global user data
    // await _userService.getSettings();
    await _userService.getChildProfiles(userProfile.id);
    // await _topicService.getLibrary();

    // _userService.getStarSetting();

    Get.back(); //hide loading modal
    if (!_userService.checkValidSafetyCode()) {
      Get.offNamed(
        AppRoute.declareParentCode,
      );
    } else {
      Get.offAllNamed(AppRoute.home);
    }
  }
}
