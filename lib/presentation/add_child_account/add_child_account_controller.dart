import 'package:EngKid/domain/core/entities/child_profile/child_profiles_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/organization/entities/entities.dart';
import 'package:EngKid/utils/app_route.dart';
import '../../domain/core/app_usecases.dart';
import '../../domain/core/entities/child_profile/entities/child/child.dart';
import '../../domain/login/login_usecases.dart';
import '../../utils/font_size.dart';
import '../../utils/images.dart';
import '../../utils/lib_function.dart';
import '../../widgets/input/text_field_widget.dart';
import '../../widgets/text/image_text.dart';
import '../../widgets/text/regular_text.dart';
import '../core/user_service.dart';

enum AddChildInputType {
  childName,
  sex,
  disability,
  studentId,
  dateOfBirth,
  disabilityCustom
}

class AddChildAccountController extends GetxController {

  final LoginUsecases loginUsecases;

  AddChildAccountController({required this.loginUsecases});

  final UserService _userService = Get.find<UserService>();
  final ChildProfilesUsecases _childProfilesUsecases = Get.find<ChildProfilesUsecases>();


  // check số lượng con >=3 để hiện thị ui
  bool get numberChild => _userService.childProfiles.childProfiles.length <= 3;
  final Rx<Child> _child = const Child().obs;
  Child get child => _child.value;
  //! abc

  final RxString _childName = ''.obs;
  final RxString _sex = ''.obs;
  final RxString _studentId = ''.obs;

  String get childNameRx => _childName.value;
  String get sexRx => _sex.value;
  String get studentIdRx => _studentId.value;

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  DateTime? get selectedDate => _selectedDate.value;
  set selectedDate(DateTime? value) => _selectedDate.value = value;

  final RxString _dateOfBirth = ''.obs;
  String get dateOfBirthRx => _dateOfBirth.value;
  set dateOfBirthRx(String value) => _dateOfBirth.value = value;

  final RxList<Organization> _schoolList = <Organization>[].obs;
  List<Organization> get schoolList => _schoolList;

  final RxList<Organization> _gradeList = [
    const Organization(id: 1, group: '1', code: '1'),
    const Organization(id: 2, group: '2', code: '1'),
    const Organization(id: 3, group: '3', code: '1'),
    const Organization(id: 4, group: '4', code: '1'),
    const Organization(id: 5, group: '5', code: '1'),
  ].obs;
  final RxList<Organization> _classList = [
    const Organization(id: 1, group: 'class_1', code: '1'),
    const Organization(id: 2, group: 'class_2', code: '1'),
    const Organization(id: 3, group: 'class_3', code: '1'),
    const Organization(id: 4, group: 'class_4', code: '1'),
    const Organization(id: 5, group: 'class_5', code: '1'),
  ].obs;

  List<Organization> get gradeList => _gradeList.value;
  List<Organization> get classList => _classList.value;

  final RxList<Organization> _filteredClassList = <Organization>[].obs;

  List<Organization> get filteredClassList => _filteredClassList;


  final RxMap<String, dynamic> _selectedSchool = <String, dynamic>{}.obs;
  Map<String, dynamic> get selectedSchool => _selectedSchool.value;

  final RxMap<String, dynamic> _selectedGrade = <String, dynamic>{}.obs;
  Map<String, dynamic> get selectedGrade => _selectedGrade.value;

  final RxMap<String, dynamic> _selectedClass = <String, dynamic>{}.obs;
  Map<String, dynamic> get selectedClass => _selectedClass.value;

  final RxString _validateChildName = ''.obs;
  final RxString _validateSex = ''.obs;
  final RxString _validateDisability = ''.obs;
  final RxString _validateSchool = ''.obs;
  final RxString _validateGrade = ''.obs;
  final RxString _validateClass = ''.obs;
  final RxString _validateStudentId = ''.obs;
  final RxString _validateDateOfBirth = ''.obs;

  String get validateChildName => _validateChildName.value;
  String get validateSex => _validateSex.value;
  String get validateDisability => _validateDisability.value;
  String get validateSchool => _validateSchool.value;
  String get validateGrade => _validateGrade.value;
  String get validateClass => _validateClass.value;
  String get validateStudentId => _validateStudentId.value;
  String get validateDateOfBirth => _validateDateOfBirth.value;


  final RxString _router = ''.obs;
  String? get router => _router.value;


  // các biến để call api lấy data user organization để set selected provinces, wards khi vào màn
  final RxInt _parentId = 0.obs;
  int get parentId => _parentId.value;

  final RxInt _cityId = 0.obs;
  int get cityId => _cityId.value;

  final _wardId = 0.obs;
  int get wardId => _wardId.value;

  late Map<String, dynamic> dataUserOrganization;


  final RxList<Map<String, dynamic>> _listDisability = <Map<String, dynamic>>[
    {'id': 0, 'title': 'Không gặp bất kì khó khăn nào'},
    {'id': 1, 'title': 'Khó khăn khi nhìn, ngay cả khi đã đeo kính'},
    {'id': 2, 'title': 'Khó khăn khi nghe, ngay cả khi đã sử dụng máy trợ thính'},
    {'id': 3, 'title': 'Khó khăn khi đi lại hoặc leo cầu thang'},
    {'id': 4, 'title': 'Khó khăn trong việc ghi nhớ hoặc tập trung'},
    {'id': 5, 'title': 'Khó khăn khi tự chăm sóc bản thân(như tắm rửa, mặc quần áo)'},
    {'id': 6, 'title': 'Khó khăn trong giao tiếp (kể cả khi dùng tiếng mẹ đẻ)'},
    {'id': 7, 'title': 'Khó khăn khác (vui lòng ghi rõ)'},
  ].obs;

  List<Map<String, dynamic>> get listDisability => _listDisability;


  final RxList<Map<String, dynamic>> _selectedDisabilities = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get selectedDisability => _selectedDisabilities;

  final RxList<int> _listSelectedDisability = <int>[].obs;

  final ScrollController scrollController = ScrollController();
  final RxBool _showShadow = false.obs;
  bool get showShadow => _showShadow.value;

  final RxString _disabilityCustom = ''.obs;
  String get disabilityCustom => _disabilityCustom.value;

  @override
  void onInit() {
    super.onInit();
    initData();

    scrollController.addListener(() {
      if (scrollController.offset > 5 && !_showShadow.value) {

          _showShadow.value = true;

      } else if (scrollController.offset <= 5 && _showShadow.value) {

          _showShadow.value = false;

      }
    });
  }

  Future<void> initData() async {
    try {
      final parentId = _userService.userLogin.id;

      final data = Get.arguments;

      if (data != null && data is Map<String, dynamic>) {
        _router.value = data['router']!.toString();
        if (_router.value == '1') {
          _parentId.value = data['id'];
          _cityId.value = data['idProvinces'];
          _wardId.value = data['idWards'];

        } else if (_router.value == '2') {
          _parentId.value = parentId;
          _cityId.value = dataUserOrganization['city_id']["id"];
          _wardId.value = dataUserOrganization['award_id']["id"];
        }
      } else if (data != null) {
        _router.value = data.toString();
      }

    } catch (e) {
      print('Error in initData: $e');
    }
  }


  void createChildAccount() async {
    print('Create Child Called');
    if(validateFormRegister()){
      Map<String, dynamic> body = {
        'name' : _childName.value,
        'student_id' : _studentId.value,
        'dob' : _dateOfBirth.value,
        'gender' : _sex.value,
        'grade_id' : _selectedGrade.value['id'],
      };
      try {
        LibFunction.showLoading();
        final statusCode = await _childProfilesUsecases.createChild(body);
        if (statusCode == 3) {
          LibFunction.hideLoading();
          LibFunction.toast('student_exits');
        }else {
          LibFunction.hideLoading();
          LibFunction.toast('add_child_success');
          Get.back();
          final child = _child.value = Child(
            id: statusCode['id'],
            name: statusCode['name'],
            gradeId: statusCode['grade_id'],
            avatar: '',
            parentId: statusCode['parent_id'],
            gender: statusCode['gender'],
            dob: statusCode['dob'],
          );
          _userService.updateListChild(child);
          resetAll(); // i am gay
          Get.back();
        }

      }catch (e) {
        print('Error in createChildAccount: $e');
        LibFunction.hideLoading();
      }
    }

  }


  void resetAll(){
    _childName.value = '';
    _sex.value = '';
    _studentId.value = '';
    _dateOfBirth.value = '';
    _selectedSchool.value = {};
    _selectedGrade.value = {};
    _selectedClass.value = {};
  }



  void onChangeInput({required String input, required AddChildInputType type}) {
    switch (type) {
      case AddChildInputType.childName:
        _childName.value = input;
        break;
      case AddChildInputType.sex:
        _sex.value = input;
        break;
        case AddChildInputType.dateOfBirth:
        _dateOfBirth.value = input;
        break;
      case AddChildInputType.studentId:
        _studentId.value = input;
        break;
      case AddChildInputType.disabilityCustom:
        _disabilityCustom.value = input;
        break;
      default:
        break;
    }
    update();
  }

  bool validateFormRegister() {
    _validateChildName.value = _childName.value.isEmpty
        ? "please_enter_child_name"
        : "";
    _validateSex.value =
        _sex.value.isEmpty ? "please_enter_sex" : "";
    _validateGrade.value =
        _selectedGrade.value.isEmpty ? "please_enter_grade" : "";

    _validateStudentId.value = _studentId.value.isEmpty
        ? "please_enter_student_id"
        : "";
    _validateDateOfBirth.value = _dateOfBirth.value.isEmpty
        ? "please_enter_date_of_birth"
        : "";
    return _validateChildName.value.isEmpty &&
        _validateSex.value.isEmpty &&
        _validateGrade.value.isEmpty &&
        _validateDateOfBirth.isEmpty;
  }

  void selectGender(String gender) {
    _sex.value = gender;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }



  void selectSex(String sex) {
    _sex.value = sex;
  }

  Future<void> updateSelectedGrade(Map<String, dynamic> grade) async {
    _selectedGrade.value = grade;

    final selectedCode = grade['id'];
    _filteredClassList.value = _classList
        .where((cls) => cls.id == selectedCode)
        .toList();
    print('_filteredClassList.value : ${_filteredClassList.value}');

    _selectedClass.value = {};
  }
}
