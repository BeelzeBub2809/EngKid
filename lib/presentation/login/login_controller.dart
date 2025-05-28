import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EzLish/data/core/local/share_preferences_manager.dart';
import 'package:EzLish/di/injection.dart';
import 'package:EzLish/domain/login/entities/login/login.dart';
import 'package:EzLish/domain/login/login_usecases.dart';
import 'package:EzLish/presentation/core/topic_service.dart';
import 'package:EzLish/presentation/core/user_service.dart';
import 'package:EzLish/utils/app_route.dart';
import 'package:EzLish/utils/cache_control.dart';
import 'package:EzLish/utils/key_shared_preferences.dart';
import 'package:EzLish/utils/lib_function.dart';

enum LoginInputType { username, password }

class LoginController extends GetxController {
  final LoginUsecases loginUsecases;
  final UserService _userService = Get.find<UserService>();
  final TopicService _topicService = Get.find<TopicService>();

  LoginController({required this.loginUsecases});

  final _preferencesManager = getIt<SharedPreferencesManager>();

  final RxString _username = ''.obs;
  final RxString _password = ''.obs;
  final RxBool _isiOS13later = false.obs;
  final RxBool _isChecked = false.obs;
  final RxBool _isForgotPassword = false.obs;
  final RxString _subString = "enter_id".obs;

  String get username => _username.value;
  String get password => _password.value;
  bool get isIOS13Later => _isiOS13later.value;
  bool get isChecked => _isChecked.value;
  bool get isForgotPassword => _isForgotPassword.value;
  String get subString => _subString.value;

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

  Future<void> onLogin(BuildContext context) async {
    if (username == "") {
      LibFunction.toast('Vui lòng nhập mã ID để đăng nhập!');
      return;
    }
    LibFunction.showLoading();
    await LibFunction.effectConfirmPop();
    // await _preferencesManager.putString(
    //   key: KeySharedPreferences.identifier,
    //   value: username,
    // );
    _userService.identifier = username;

    try {
      final Login userProfile = await loginUsecases.login(username);
      _configureUserProfile(userProfile);
      Get.back();
    } catch (error) {
      _subString.value = "invalid_account";
      debugPrint('Error on sign_in: ${error.toString()}');
      Get.back(); //hide loading modal
      switch (error) {
        case 'User not found':
          LibFunction.toast(error.toString());
          break;
      }
    }
  }

  void onChangeInput({required String input, required LoginInputType type}) {
    switch (type) {
      case LoginInputType.username:
        _username.value = input;
        break;
      case LoginInputType.password:
        _password.value = input;
        break;
      default:
        break;
    }
  }

  void onForgotIdentifier() async {
    await LibFunction.effectConfirmPop();
    Get.toNamed(AppRoute.forgotIdentifier);
  }

  Future<void> _configureUserProfile(Login userProfile) async {
    CacheControl.instance.getFileStream(userProfile.image);
    await _preferencesManager.putString(
      key: KeySharedPreferences.token,
      value: userProfile.token,
    );
    await _preferencesManager.putInt(
      key: KeySharedPreferences.loginRecord,
      value: userProfile.loginRecord,
    );
    await _userService.assignUseLogin(userProfile); //set to global user data
    // await _userService.getSettings();
    // await _userService.getChildProfiles();
    // await _topicService.getLibrary();

    // _userService.getStarSetting();

    Get.back(); //hide loading modal
    if (!_userService.checkValidSafetyCode()) {
      Get.offNamed(
        AppRoute.declareParentCode,
      );
    } else {
      Get.offAllNamed(AppRoute.kidSpace);
    }
  }
}
