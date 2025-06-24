import 'package:get/get.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../../data/core/local/share_preferences_manager.dart';
import '../../di/injection.dart';
import '../../utils/key_shared_preferences.dart';

class DeclareParentCodeController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  // final TopicService _topicService = Get.find<TopicService>();

  final RxList<String> _initialParentCode = ['', '', '', ''].obs;
  final RxList<String> _initialReParentCode = ['', '', '', ''].obs;
  final RxInt _fillIndex = 0.obs;

  late bool isReParentCode = false;
  final List<String> _buttons = [
    LocalImage.button1,
    LocalImage.button2,
    LocalImage.button3,
    LocalImage.button4,
    LocalImage.button5,
    LocalImage.button6,
    LocalImage.button7,
    LocalImage.button8,
    LocalImage.button9,
    LocalImage.buttonClear,
    LocalImage.button0,
    LocalImage.buttonEnter
  ];
  List<String> get initialParentCode => _initialParentCode;
  List<String> get initialReParentCode => _initialReParentCode;
  List<String> get buttons => _buttons;
  int get fillIndex => _fillIndex.value;


  final RxBool _saveParentCode = false.obs;
  bool get saveParentCode => _saveParentCode.value;

  final _preferencesManager = getIt.get<SharedPreferencesManager>();


  @override
  void onInit() {
    super.onInit();
    LibFunction.playAudioLocal(LocalAudio.createSafetyCode);
  }

  bool checkIllegalCode() {
    final String code = _initialParentCode.join('');
    final String reCode = _initialReParentCode.join('');

    return code == reCode;
  }

  void onPressSaveParentCode() {
    _saveParentCode.value = !_saveParentCode.value;
  }



  Future<void> saveChooseParentCodeToStorage() async {
    await _preferencesManager.putBool(
      key: KeySharedPreferences.chooseParentCode,
      value: _saveParentCode.value,
    );
  }



  Future<void> onConfirm() async {
    LibFunction.showLoading();
    await LibFunction.effectConfirmPop();

    if(_saveParentCode.value){
      _userService.saveChooseParentToStorage(_saveParentCode.value);
      _userService.saveParentCodeToStorage(_initialParentCode.value);
    }

    await saveChooseParentCodeToStorage();
    if (_initialParentCode.join('').isEmpty) {
      Get.back();
      LibFunction.toast("parent_code_empty");
      return;
    }

    if (!checkIllegalCode()) {
      Get.back();
      LibFunction.toast("illegal_code");
      return;
    }
    Get.back();
    _userService.changeUserProfile(
        type: UserDataUpdateType.parentCode,
        value: _initialParentCode.join(''));
    Get.offAllNamed(AppRoute.home);
  }

  void onPressClose() async {
    await LibFunction.effectConfirmPop();
    Get.back();
  }

  void onPressPin({required String number, required String type}) {
    LibFunction.effectConfirmPop();

    if (type == 'enter' &&
        _fillIndex.value == 3 &&
        _initialParentCode[3] != "") {
      isReParentCode = true;
      _fillIndex.value++;
      return;
    }
    if (type == 'enter' &&
        _fillIndex.value == 7 &&
        _initialReParentCode[3] != "") {
      onConfirm();
      return;
    }
    if (number == "" && type == "enter") {
      return;
    }
    if (_fillIndex.value < 4 && !isReParentCode) {
      _initialParentCode[_fillIndex.value] = number;
    } else if (_fillIndex.value < 8 && isReParentCode) {
      _initialReParentCode[_fillIndex.value - 4] = number;
    }
    if (_fillIndex.value < 7 && type != 'subtraction') {
      if (_fillIndex.value < 3 && !isReParentCode) {
        _fillIndex.value++;
      } else if (_fillIndex.value < 7 && isReParentCode) {
        _fillIndex.value++;
      }
    } else if (_fillIndex.value > 0 && type == 'subtraction') {
      _fillIndex.value--;
      if (_fillIndex.value < 4) {
        isReParentCode = false;
      }
    }
  }
}
