import 'dart:io';

import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/domain/grade/entities/entities.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../domain/core/entities/child_profile/entities/child/child.dart';

enum ProfileChildInputType { childName, childId, dateOfBirth }

class ProfileChildController extends GetxController {
  ProfileChildController();

  final UserService _userService = Get.find<UserService>();
  final Rx<UserInfo> userInfo = const UserInfo().obs;
  final RxInt indexChild = 1.obs;
  final RxInt indexAvt = 0.obs;
  RxMap<int, String> pathAvatars = <int, String>{}.obs;
  late File? fileAvatar;
  final RxBool _isEdit = false.obs;
  bool get isEdit => _isEdit.value;

  final RxString _childName = ''.obs;
  final RxString _gender = ''.obs;
  final RxString _disability = ''.obs;
  final RxString _childId = ''.obs;
  final RxString _sex = 'male'.obs;

  String get childName => _childName.value;
  String get gender => _gender.value;
  String get disability => _disability.value;
  String get childId => _childId.value;
  String get sex => _sex.value;

  TextEditingController childNameController = TextEditingController();
  TextEditingController childIdController = TextEditingController();

  final RxString _validateChildName = ''.obs;
  String get validateChildName => _validateChildName.value;
  final RxString _validateChildId = ''.obs;
  String get validateChildId => _validateChildId.value;
  final RxString _validateSex = ''.obs;
  String get validateSex => _validateSex.value;
  final RxString _validateDisability = ''.obs;
  String get validateDisability => _validateDisability.value;
  final RxString _validateDateOfBirth = ''.obs;
  String get validateDateOfBirth => _validateDateOfBirth.value;
  final RxString _validateSchool = ''.obs;
  String get validateSchool => _validateSchool.value;
  final RxString _validateGrade = ''.obs;
  String get validateGrade => _validateGrade.value;

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  DateTime? get selectedDate => _selectedDate.value;
  set selectedDate(DateTime? value) => _selectedDate.value = value;

  final RxString _dateOfBirth = ''.obs;
  String get dateOfBirthRx => _dateOfBirth.value;
  set dateOfBirthRx(String value) => _dateOfBirth.value = value;
  TextEditingController dateOfBirthController = TextEditingController();

  final RxMap<String, dynamic> _selectedSchool = <String, dynamic>{}.obs;
  Map<String, dynamic> get selectedSchool => _selectedSchool.value;

  final RxMap<String, dynamic> _selectedGrade = <String, dynamic>{}.obs;
  Map<String, dynamic> get selectedGrade => _selectedGrade.value;

  final PageController pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.4,
  );

  final RxList<String> _listImageAvt = <String>[
    'https://img.lovepik.com/png/20231116/cartoon-boy-student-character-illustration-emoji-vector-clipart-cartoon-students_610602_wh860.png',
    'https://lh3.googleusercontent.com/proxy/MuYwroS5OsGex_K6Buyqm0DlA2VL_m0DPqm9q_et_w19lzDYluyT8DhsxiquCjqTVBPeyCVfuF67T170U4X0gv6M6jQeZ4Rh_Q_xfdV3lqSu9N5_4MQdXazVYFWyBYiN1ITtwnKbROVVWlUZybLwlcZ4GYDGJgORJOt1N5k',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKpSjWso_86MYHUs3onuWvl5a0uiC9600Njw&s'
  ].obs;

  List<String> get listImageAvt => _listImageAvt;

  final RxList<Grade> _gradeList = [
    const Grade(id: 1, name: 'grade_1'),
    const Grade(id: 2, name: 'grade_2'),
    const Grade(id: 3, name: 'grade_3'),
    const Grade(id: 4, name: 'grade_4'),
    const Grade(id: 5, name: 'grade_5'),
  ].obs;
  List<Grade> get gradeList => _gradeList.value;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _userService.userInfos.asMap().forEach((index, value) {
      if (value.value.user.id == _userService.currentUser.id) {
        indexChild.value = index;
        userInfo(value.value);
        _childName.value = _userService.currentUser.name;
        _childId.value = _userService.currentUser.id.toString();
        _selectedGrade.value = {
          "id": _userService.currentUser.gradeId,
        };

        _dateOfBirth.value = "29/11/2003";
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
      // getOrganization(3, _selectedProvince.value['id']);
    });
    dateOfBirthController.text = _dateOfBirth.value;
    childNameController.text = _childName.value;
    childIdController.text = _childId.value;
    if (_userService.childProfiles.childProfiles.length > 1) {
      indexChild.value = 1;

      onChangeChild(_userService.childProfiles.childProfiles[1], 1);

      Future.delayed(const Duration(milliseconds: 300), () {
        pageController.jumpToPage(1);
      });
    } else if (_userService.userInfos.isNotEmpty) {
      indexChild.value = 0;
      onChangeChild(_userService.childProfiles.childProfiles[0], 0);
    }
  }

  void onChangeAvt(int index, String avtUrl) {
    pathAvatars[index] = avtUrl;
    Get.back();
  }

  void onChangeIndexAvt(int index) {
    indexAvt.value = index;
  }

  void initData() async {}

  void onChangeChild(Child child, int index) {
    try {
      indexChild.value = index;
      _childName.value = userInfo.value.user.name;
      _childId.value = child.id.toString();
      childNameController.text = child.name;
      childIdController.text = child.id.toString();

      _selectedGrade.value = {
        "id": child.gradeId,
      };
    } catch (e) {
      LibFunction.toast('error_try_again');
    }
  }

  Future<void> updateSelectedSchool(Map<String, dynamic> school) async {
    _selectedSchool.value = school;
  }

  Future<void> updateSelectedGrade(Map<String, dynamic> grade) async {
    _selectedGrade.value = grade;
  }

  void onChangeInput(
      {required String input, required ProfileChildInputType type}) {
    switch (type) {
      case ProfileChildInputType.childName:
        _childName.value = input;
        childNameController.text = input;
        break;
      case ProfileChildInputType.childId:
        _childId.value = input;
        childIdController.text = input;
        break;
      case ProfileChildInputType.dateOfBirth:
        _dateOfBirth.value = input;
        dateOfBirthController.text = dateOfBirthRx;
        break;
    }
  }

  void selectSex(String sex) {
    _sex.value = sex;
  }

  void isEditBtn() {
    _isEdit.value = !_isEdit.value;
  }

  @override
  void onClose() {
    super.onClose();
    closeScreenOrientation();
  }

  Future<void> closeScreenOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
