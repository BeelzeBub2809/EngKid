import 'package:get/get.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../core/user_service.dart';

class ValidateParentController extends GetxController {
  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final UserService _userService = Get.find<UserService>();

  // final TopicService _topicService = Get.find<TopicService>();
  final RxList<String> _initialParentCode = ['', '', '', ''].obs;
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
  List<String> get buttons => _buttons;
  int get fillIndex => _fillIndex.value;

  final RxBool _fromCharacterScreen = false.obs;
  bool get fromCharacterScreen => _fromCharacterScreen.value;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1000), () {
      LibFunction.playAudioLocal(LocalAudio.parentSpace);
    });
    loadChooseParentCodeFromStorage();

  }

  void loadChooseParentCodeFromStorage() async {
    bool? chooseParentCode = await _userService.loadChooseParentCodeFromStorage();
    if(chooseParentCode == true) {
      loadParentCodeFromStorage();
    }
  }


  void loadParentCodeFromStorage() async {
    List<String> ? parentCode = await _userService.loadParentCodeFromStorage();
    if(parentCode != null) {
      _initialParentCode.value = parentCode;
      _fillIndex.value = 3;
    }
  }





  Future<void> onConfirm() async {
    LibFunction.effectConfirmPop();
    final code = _initialParentCode.join('');
    final String? settingSafetyCode =
        _preferencesManager.getString(KeySharedPreferences.safetyCode);

    if (settingSafetyCode != null) {
      Get.back(
        result: code == settingSafetyCode
            ? {"result": true, "message": 'parent_code_correct'}
            : {"result": false, "message": 'parent_code_incorrect'},
      );
    } else {
      Get.back(
        result: {"result": false, "message": 'config_parent_code'},
      );
    }
  }

  void onPressClose() async {
    await LibFunction.effectConfirmPop();
    Get.back(
      result: {"result": false, "message": 'parent_code_incorrect'},
    );
  }

  void onPressPin({required String number, required String type}) {
    if (type == 'enter') {
      if (_fillIndex.value == 3 && _initialParentCode[3] != "") {
        onConfirm();
      }
      return;
    }
    if (_fillIndex.value < 4) {
      _initialParentCode[_fillIndex.value] = number;
    }
    if (_fillIndex.value < 3 && type != 'subtraction') {
      _fillIndex.value++;
    } else if (_fillIndex.value > 0 && type == 'subtraction') {
      _fillIndex.value--;
    }
    LibFunction.effectConfirmPop();
  }
}
