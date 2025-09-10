import 'dart:convert';
import 'dart:io';

import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/domain/grade/entities/entities.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/im_utils.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/commom/item_bottom_sheet_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../../domain/core/entities/child_profile/entities/child/child.dart';

enum ProfileChildInputType { childName, dateOfBirth }

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
  final RxString _sex = 'male'.obs;

  String get childName => _childName.value;
  String get gender => _gender.value;
  String get disability => _disability.value;
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

  final RxList<XFile> _listFile = <XFile>[].obs;
  List<XFile> get listFile => _listFile.value;

  final RxList<ItemBottomSheetModel> _listItemBts = <ItemBottomSheetModel>[].obs;
  List<ItemBottomSheetModel> get listItemBts => _listItemBts.value;

  final PageController pageController = PageController(
    viewportFraction: 0.4,
  );

  final RxList<String> _listImageAvt = <String>[
    'https://img.lovepik.com/png/20231116/cartoon-boy-student-character-illustration-emoji-vector-clipart-cartoon-students_610602_wh860.png',
    'https://lh3.googleusercontent.com/proxy/MuYwroS5OsGex_K6Buyqm0DlA2VL_m0DPqm9q_et_w19lzDYluyT8DhsxiquCjqTVBPeyCVfuF67T170U4X0gv6M6jQeZ4Rh_Q_xfdV3lqSu9N5_4MQdXazVYFWyBYiN1ITtwnKbROVVWlUZybLwlcZ4GYDGJgORJOt1N5k',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKpSjWso_86MYHUs3onuWvl5a0uiC9600Njw&s'
  ].obs;

  List<String> get listImageAvt => _listImageAvt;
  late final RxList<Grade> _gradeList;
  List<Grade> get gradeList => _gradeList.value;
  final RxString _imagePath = ''.obs;
  String get imagePath => _imagePath.value;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    String grade1 = 'grade_1'.tr;
    String grade2 = 'grade_2'.tr;
    String grade3 = 'grade_3'.tr;
    String grade4 = 'grade_4'.tr;
    String grade5 = 'grade_5'.tr;

    _gradeList = <Grade>[
      Grade(id: 1, name: grade1),
      Grade(id: 2, name: grade2),
      Grade(id: 3, name: grade3),
      Grade(id: 4, name: grade4),
      Grade(id: 5, name: grade5),
    ].obs;

    _listItemBts.value = [
      ItemBottomSheetModel("camera", '', Icons.camera_alt),
      ItemBottomSheetModel("storage", '', Icons.image_rounded),
    ];

    final List<Child> children = _userService.childProfiles.childProfiles;

    if (children.isNotEmpty) {
      final Child currentChild = _userService.currentUser;
      int initialIndex = children.indexWhere((c) => c.id == currentChild.id);
      if (initialIndex == -1) {
        initialIndex = 0;
      }

      onChangeChild(children[initialIndex], initialIndex);

      // Cập nhật PageController để trượt đến đúng vị trí child
      // Dùng addPostFrameCallback để đảm bảo widget đã được build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(initialIndex);
        }
      });
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
    print('onChangeChild được gọi cho: ${child.name} (ID: ${child.id})');
    try {
      _userService.updateListChild(child);

      indexChild.value = index;

      _childName.value = child.name;
      _dateOfBirth.value = child.dob;
      _sex.value = child.gender;

      _selectedGrade.value = {
        "id": child.gradeId,
      };

      childNameController.text = child.name;
      childIdController.text = child.id.toString();
      dateOfBirthController.text = child.dob;

      _imagePath.value = '';
    } catch (e) {
      print("Lỗi onChangeChild: $e");
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

  bool validateFormRegister() {
    _validateChildName.value = _childName.value.isEmpty
        ? "please_enter_child_name"
        : "";
    _validateSex.value =
    _sex.value.isEmpty ? "please_enter_sex" : "";
    _validateGrade.value =
    _selectedGrade.value.isEmpty ? "please_enter_grade" : "";

    if (_dateOfBirth.value.isEmpty) {
      _validateDateOfBirth.value = "please_enter_date_of_birth";
    } else {
      try {
        final dob = DateFormat("dd/MM/yyyy").parseStrict(_dateOfBirth.value);
        if (dob.isAfter(DateTime.now())) {
          _validateDateOfBirth.value = "date_of_birth_cannot_be_in_future";
        } else {
          _validateDateOfBirth.value = "";
        }
      } catch (e) {
        _validateDateOfBirth.value = "invalid_date_format";
      }
    }


    return _validateChildName.value.isEmpty &&
        _validateSex.value.isEmpty &&
        _validateGrade.value.isEmpty &&
        _validateDateOfBirth.isEmpty;
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

  Future<void> updateProfileChild() async {
    if(validateFormRegister()) {
      try {
        Map<String, dynamic> body = {
          'name': _childName.value,
          'gender': _sex.value,
          'dob': _dateOfBirth.value,
          'grade_id': _selectedGrade.value['id'],
        };

        dio.FormData formData = dio.FormData.fromMap(body);

        if (_imagePath.value.isNotEmpty) {
          File imageFile = File(_imagePath.value);
          body['image'] = imageFile;
          print("imageFile : $imageFile");
          print("File size: ${await imageFile.length()} bytes");
          formData.files.add(MapEntry(
            'image',
            await dio.MultipartFile.fromFile(
              imagePath,
              filename: p.basename(imagePath),
            ),
          ));
        } else {
        }
        Map<String, dynamic> loggableBody = Map.from(body);

        if (loggableBody['image'] is File) {
          loggableBody['image'] = (loggableBody['image'] as File).path;
        }
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final String prettyJson = encoder.convert(loggableBody);

        print('---------- BEGIN REQUEST BODY ----------');
        print(prettyJson);
        print('----------- END REQUEST BODY -----------');


        LibFunction.showLoading();
        final responseData = await _userService.updateProfileChild(
            _userService.childProfiles.childProfiles[indexChild.value].id, formData);
        if (responseData != null && responseData is Map<String, dynamic>) {
          Child updatedChildInfo = Child(
            id: responseData['id'] ?? _userService.childProfiles.childProfiles[indexChild.value].id,
            parentId: responseData['kid_parent_id'] ?? _userService.childProfiles.childProfiles[indexChild.value].parentId,
            name: responseData['name'] ?? '',
            gender: responseData['gender'] ?? '',
            dob: responseData['dob'] ?? '',
            gradeId: int.tryParse(responseData['grade_id'].toString()) ?? 1,
            avatar: responseData['image'] ?? '',
          );
          await _userService.updateListChild(updatedChildInfo);
          LibFunction.hideLoading();
          LibFunction.toast('Cập nhật thông tin thành công');

        } else {
          LibFunction.hideLoading();
          // Xử lý trường hợp có lỗi
          LibFunction.toast('Có lỗi xảy ra, không nhận được dữ liệu cập nhật');
        }

      } catch(e) {
        print('Error updateProfileParent: $e');
        LibFunction.hideLoading();
      }
    }
  }

  Future<void> getFunctionByIndex(int index, BuildContext context) async {
    print(index);
    switch (index) {
      case 0:
        final List<String>? value = await IMUtils.openCamera();
        if (value != null && value.isNotEmpty) {
          LibFunction.showLoading();
          await Future.delayed(const Duration(milliseconds: 500));

          _listFile.clear();
          for (String imagePath in value) {
            _listFile.add(XFile(imagePath));
          }
          if (kDebugMode) {
            print('Selected image path: ${_listFile[0].path}');
          }
          pathAvatars[indexAvt.value] = _listFile[0].path;
          _imagePath.value = _listFile[0].path;
          LibFunction.hideLoading();
          Get.back();
        }
        break;

      case 1:
        final List<String>? value = await IMUtils.pickImageFromLibrary();
        if (value != null && value.isNotEmpty) {
          LibFunction.showLoading();
          await Future.delayed(const Duration(milliseconds: 500));

          _listFile.clear();
          for (String imagePath in value) {
            _listFile.add(XFile(imagePath));
          }

          print(_listFile[0].path);
          if (_listFile.isNotEmpty) {
            pathAvatars[indexAvt.value] = _listFile[0].path;
            _imagePath.value = _listFile[0].path;
          } else {
            if (kDebugMode) {
              print("⚠️ No valid image file selected!");
            }
          }
          LibFunction.hideLoading();
          Get.back();
        }
        break;
    }
  }
}
