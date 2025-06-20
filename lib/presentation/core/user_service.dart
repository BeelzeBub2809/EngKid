import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/app_usecases.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/reading_sequence_setting/reading_sequence_setting.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/star_setting/star_setting.dart';
import 'package:EngKid/domain/core/entities/auto_notification/auto_notification.dart';
import 'package:EngKid/domain/core/entities/child_profile/entities/entities.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/domain/core/entities/message/entities/message/message.dart';
import 'package:EngKid/domain/login/entities/login/login.dart';
import 'package:EngKid/domain/start_board/entities/entities.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/utils/localization/localization_service.dart';
import 'package:EngKid/widgets/dialog/dialog_change_acc.dart';
import 'package:timezone/data/latest.dart' as tz;

enum UserProfileStatus {
  unknow,
  ignoreDemo,
  userNotCreate,
  emptyUserName,
  emptyParentCode,
  completeSetup
}

enum UserDataUpdateType {
  name,
  username,
  phone,
  surveyPassed,
  parentCode,
}

class UserService extends GetxService {
  final AppUseCases appUseCases;

  UserService({required this.appUseCases});

  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final NetworkService _networkService = Get.find<NetworkService>();

  Random random = Random();
  bool isDemo = false;
  bool isSettingUpUserProfile = false;
  bool isSocialUser = false;
  bool isParentValidated = false;
  double progressDownload = 1;

  late String identifier = '';
  //user info
  final List<Rx<UserInfo>> _userInfos =
      List<Rx<UserInfo>>.empty(growable: true);
  List<Rx<UserInfo>> get userInfos => _userInfos;

  // user login
  final Rx<Login> _userLogin = const Login().obs;
  Login get userLogin => _userLogin.value;

  set userInfos(List<Rx<UserInfo>> value) => _userInfos.assignAll(value);
  final List<Rx<Setting>> _settings = List<Rx<Setting>>.empty(growable: true);
  final Rx<ChildProfiles> _childProfiles = const ChildProfiles().obs;
  final Rx<Child> _currentUser = const Child().obs;
  late StarSetting _starSetting = const StarSetting();
  final ReadingSequenceSetting _readingSequenceSetting =
      const ReadingSequenceSetting();

  final Rx<AppSetting> _appSetting = const AppSetting().obs;
  final RxInt _otpDelay = 0.obs;
  late AppVersion _appVersion;
  dynamic notificationSetting = {};
  final bool _ignoreUpdate = false;

  List<Rx<Setting>> get settings => _settings;
  AppSetting get setting => _appSetting.value;
  ChildProfiles get childProfiles => _childProfiles.value;
  int get otpDelay => _otpDelay.value;
  AppVersion get appVersion => _appVersion;
  bool get ignoreUpdate => _ignoreUpdate;
  Child get currentUser => _currentUser.value;
  ReadingSequenceSetting get readingSequenceSetting => _readingSequenceSetting;

  final RxList<Message> _messages = RxList<Message>.empty(growable: true);
  List<Message> get messages => _messages;

  set currentUser(Child child) {
    if (_networkService.networkConnection.value) {
      _currentUser.value = child;
      saveCurrentUserToStorage();
    } else {
      LibFunction.toast('require_network_to_change_child');
    }
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('Init User Service');
    getRemoteLanguages();

    _currentUser.value = const Child(
      id: 1,
      userId: "sample_user_id",
      name: "Sample Name",
      classname: "Sample Class",
      loginId: "sample_login_id",
      grade: "Grade 5",
      school: "Sample School",
      avatar: "https://thumbs.dreamstime.com/b/vectorial-blank-face-avatar-7046081.jpg",
      surveyPassed: true,
    );

    _childProfiles.value = const ChildProfiles(
      childProfiles: [
        Child(
          id: 1,
          userId: "sample_user_id",
          name: "Sample Name",
          classname: "Sample Class",
          loginId: "sample_login_id",
          grade: "Grade 5",
          school: "Sample School",
          avatar: "https://thumbs.dreamstime.com/b/vectorial-blank-face-avatar-7046081.jpg",
          surveyPassed: true,
        ),
      ],
    );
  }

  String getPhotoBase64(Map<String, dynamic> public) {
    // Lấy giá trị của "data" trong "public.photo.value.data"
    try {
      // Kiểm tra nếu key 'photo' tồn tại
      if (public.containsKey('photo')) {
        var photoMap = public['photo'] as Map<String, dynamic>;

        // Lấy giá trị data (base64)
        if (photoMap.containsKey('data')) {
          String base64Data = photoMap['data'];
          return base64Data;
        }
      }

      return "";
    } catch (e) {
      return "";
    }
  }

  void getIdentifier() async {
    final String? tmp = _preferencesManager.getString(
      KeySharedPreferences.identifier,
    );
    if (tmp != null) {
      identifier = tmp;
    }
  }

  void updateUserService(
      {required String name, required String email, required String image}) {
    _userLogin(_userLogin.value.copyWith(
      name: name,
      email: email,
      image: image,
    ));
  }

  Future<void> saveUsersInfoToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.userInfos,
      value: jsonEncode(
        _userInfos.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> saveUserLoginToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.userLogin,
      value: jsonEncode(_userLogin.toJson()),
    );
  }

  Future<void> saveSettingsToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.settings,
      value: jsonEncode(
        _settings.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> saveChildProfilesToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.childProfiles,
      value: jsonEncode(childProfiles.toJson()),
    );
  }

  Future<void> saveCurrentUserToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.currentUser,
      value: jsonEncode(_currentUser.toJson()),
    );
  }

  Future<void> saveStarSettingToStorage() async {
    await _preferencesManager.putString(
      key: KeySharedPreferences.starSetting,
      value: jsonEncode(_starSetting.toJson()),
    );
  }

  // ===================================

  bool getUserInfosFromStorage() {
    final String? tmp = _preferencesManager.getString(
      KeySharedPreferences.userInfos,
    );
    if (tmp != null) {
      final decodeUserInfos = List<Map<String, dynamic>>.from(jsonDecode(tmp));

      _userInfos.assignAll(
        decodeUserInfos
            .map<Rx<UserInfo>>((json) => UserInfo.fromJson(json).obs)
            .toList(),
      );
      return true;
    } else {
      return false;
    }
  }

  bool getUserLoginFromStorage() {
    final String? userLogin = _preferencesManager.getString(
      KeySharedPreferences.userLogin,
    );
    if (userLogin != null) {
      final decodeUserLogin =
          Login.fromJson(jsonDecode(userLogin) as Map<String, dynamic>);
      _userLogin(decodeUserLogin);
      return true;
    } else {
      return false;
    }
  }

  bool getStarSettingFromStorage() {
    final String? starSetting = _preferencesManager.getString(
      KeySharedPreferences.starSetting,
    );
    if (starSetting != null) {
      _starSetting =
          StarSetting.fromJson(jsonDecode(starSetting) as Map<String, dynamic>);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getCurrentUserFromStorage() async {
    final String? tmp = _preferencesManager.getString(
      KeySharedPreferences.currentUser,
    );
    if (tmp != null) {
      final decodeCurrentUser =
          Child.fromJson(jsonDecode(tmp) as Map<String, dynamic>);
      _currentUser.value = decodeCurrentUser;
      return true;
    } else {
      if (_childProfiles.value.childProfiles.isNotEmpty) {
        _currentUser.value = _childProfiles.value.childProfiles[0];
        await saveCurrentUserToStorage();
      }
      return false;
    }
  }

  Future<void> assignUseLogin(Login userLogin) async {
    _userLogin(userLogin);
    await saveUserLoginToStorage();
  }

  Future<void> assignUsersProfile(List<UserInfo> userProfiles) async {
    _userInfos.assignAll(userProfiles.map((e) => e.obs).toList());
    await saveUsersInfoToStorage();
  }

  Future<void> assignSettings(List<Rx<Setting>> settings) async {
    _settings.assignAll(settings);
    await saveSettingsToStorage();
  }

  Future<void> assignChildProfiles(ChildProfiles childProfiles) async {
    _childProfiles(childProfiles);
    await saveChildProfilesToStorage();
  }

  bool checkValidSafetyCode() {
    final String? safetyCode =
        _preferencesManager.getString(KeySharedPreferences.safetyCode);
    return safetyCode != null;
  }

  void changeLanguage(Language language) {
    // LocalizationService.changeLocale(language);
    _appSetting(_appSetting.value.copyWith(language: language));
    _preferencesManager.putString(
        key: KeySharedPreferences.language, value: language.toString());
  }

  void updateLanguage(Language language) {
    LocalizationService.changeLocale(language);
  }

  Future<void> logout() async {
    await _preferencesManager.clear();

    Get.offAllNamed(AppRoute.login);
  }

  Future<void> getRemoteLanguages() async {
    try {
      // final dynamic languagues = await appUseCases.getRemoteLanguages();
      // debugPrint("hahaha: ${languagues}");
      // await Future.delayed(const Duration(seconds: 3));
      // LocalizationService.setVi = {
      //   'class_three': 'hahhahahah',
      // };
      // debugPrint("vi: ${Language.vi}");
      // LocalizationService.changeLocale(Language.vi);
    } catch (e) {
      // debugPrint("e: $e");
    }
  }

  void updateParentInfo(String parentName, String parentPhone) {
    List.generate(userInfos.length, (index) {
      _userInfos[index](_userInfos[index]
          .value
          .copyWith(parentInfo: Parent(name: parentName, phone: parentPhone)));
    });
    saveUsersInfoToStorage();
  }

  void updateSettingToStorage({
    required String language,
    required String vocalVolume,
    required String musicVolume,
  }) {
    _settings.asMap().forEach((index, value) {
      switch (value.value.key) {
        case 'language':
          _settings[index](_settings[index].value.copyWith(value: language));
          updateLanguage(language == "en" ? Language.en : Language.vi);

          break;
        case 'vocal_volume':
          _settings[index](_settings[index].value.copyWith(value: vocalVolume));
          break;
        case 'music_volume':
          LibFunction.setVolumeMusic(double.parse(musicVolume) / 10);
          _settings[index](_settings[index].value.copyWith(value: musicVolume));
          break;
      }
    });
    saveSettingsToStorage();
  }

  void onPressProfile() async {
    // if (await validateParent()) {
    // await LibFunction.effectConfirmPop();
    Get.dialog(
      const DialogChangeAcc(),
      barrierDismissible: false,
      barrierColor: null,
    );
    // }
  }

  double getAchievedStar(int attempt) {
    switch (attempt) {
      case 0:
        return double.parse(_starSetting.lessonComplete);
      case 1:
        return double.parse(_starSetting.stAttempt);
      case 2:
        return double.parse(_starSetting.ndAttempt);
      case 3:
        return double.parse(_starSetting.rdAttempt);
      default:
        return double.parse(_starSetting.thAttempt);
    }
  }

  //calling API from Apprepository
}
