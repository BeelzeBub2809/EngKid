import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../../../utils/audios.dart';

enum TypeVolume { vocalVolume, musicVolume }

class SettingController extends GetxController {
  SettingController();

  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  final List<Rx<Language>> _languages = [
    Language(name: 'en_language', code: 'en', isChecked: false).obs,
    Language(name: 'vi_language', code: 'vi', isChecked: true).obs,
  ];
  String parentCodeInput = '';
  String newParentCodeInput = '';
  String reParentCodeInput = '';
  final RxDouble vocalVolume = (0.0).obs;
  final RxDouble musicVolume = (0.0).obs;
  final RxBool isLoading = false.obs;

  List<Rx<Language>> get languages => _languages;

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint("Init Setting Controller");
    for (final Rx<Setting> element in _userService.settings) {
      switch (element.value.key) {
        case 'language':
          _languages.asMap().forEach((index, item) {
            _languages[index].update((val) {
              val!.isChecked = item.value.code == element.value.value;
            });
          });
          break;
        case 'vocal_volume':
          vocalVolume.value = double.parse(element.value.value);
          break;
        case 'music_volume':
          musicVolume.value = double.parse(element.value.value);
          break;
      }
    }
  }

  void onToggleSwitch(int index) {
    final int activeIndex =
        languages.indexWhere((element) => element.value.isChecked == true);

    _languages[activeIndex].update((val) => val!.isChecked = false);
    _languages[index].update((val) => val!.isChecked = true);
  }

  void onChangeSlide({required double value, required TypeVolume type}) {
    switch (type) {
      case TypeVolume.vocalVolume:
        vocalVolume.value = value;
        break;
      case TypeVolume.musicVolume:
        musicVolume.value = value;
        break;
    }
  }

  Future<void> onConfirm() async {
    await LibFunction.effectConfirmPop();
    updateSafetyCode();
    final Rx<Language>? language =
        _languages.firstWhereOrNull((element) => element.value.isChecked);
    _userService.updateSettingToStorage(
      language: language?.value.code ?? 'vi',
      vocalVolume: vocalVolume.toString(),
      musicVolume: musicVolume.toString(),
    );
    if (vocalVolume.value == '0.0') {
      LibFunction.stopBackgroundSound();
    } else {
      LibFunction.playBackgroundSound(LocalAudio.soundInApp);
    }
    if (_networkService.networkConnection.value) {
      isLoading.value = true;
      // await _userService.updateSetting(
      //   language: language?.value.code ?? 'vi',
      //   vocalVolume: vocalVolume.toString(),
      //   musicVolume: musicVolume.toString(),
      // );
      // LibFunction.toast(result ? 'update_success' : 'update_failed');
    }
  }

  bool checkIllegalCode() {
    if (parentCodeInput == "" &&
        newParentCodeInput == "" &&
        reParentCodeInput == "") {
      return false;
    }

    if (parentCodeInput.length < 4 ||
        newParentCodeInput.length < 4 ||
        reParentCodeInput.length < 4) {
      LibFunction.showSnackbar(
        message: "safety_code_not_enough",
        backgroundColor: AppColor.deny,
      );
      return false;
    }
    final String? safetyCode =
        _preferencesManager.getString(KeySharedPreferences.safetyCode);

    if (safetyCode == null) return false;
    if (parentCodeInput != safetyCode) {
      LibFunction.showSnackbar(
        message: "unsuccess_safety_code",
        backgroundColor: AppColor.deny,
      );
      return false;
    }
    if (newParentCodeInput != reParentCodeInput) {
      LibFunction.showSnackbar(
        message: "safety_code_mismatched",
        backgroundColor: AppColor.deny,
      );

      return false;
    }

    LibFunction.showSnackbar(
      message: "updated_safety_code",
      backgroundColor: AppColor.primary,
    );

    return true;
  }

  void updateSafetyCode() async {
    if (!checkIllegalCode()) {
      return;
    }
    // _userService.changeUserProfile(
    //     type: UserDataUpdateType.parentCode, value: newParentCodeInput);
  }
}

class Language {
  final String code;
  final String name;
  bool isChecked;
  Language({
    required this.name,
    required this.isChecked,
    required this.code,
  });
}
