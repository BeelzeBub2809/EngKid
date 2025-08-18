import 'dart:convert';
import 'dart:io';
import 'package:EngKid/domain/login/entities/login/login.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/commom/item_bottom_sheet_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/organization/entities/entities.dart';
import 'package:EngKid/utils/im_utils.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as p;


enum ProfileInputType { nameParent, email, phoneNumber, address, newPhoneNumber, dateOfBirth }

class ProfileParentController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  final RxBool _isEdit = false.obs;
  bool get isEdit => _isEdit.value;

  final RxString _nameParent = ''.obs;
  final RxString _email = ''.obs;
  final RxString _phoneNumber = ''.obs;
  final RxString _newPhoneNumber = ''.obs;
  final RxString _sex = 'male'.obs;
  final RxString _dateOfBirth = ''.obs;

  String get nameParent => _nameParent.value;
  String get email => _email.value;
  String get phoneNumber => _phoneNumber.value;
  String get newPhoneNumber => _newPhoneNumber.value;
  String get sex => _sex.value;
  String get dateOfBirthRx => _dateOfBirth.value;
  RxString get dateOfBirth => _dateOfBirth;
  set dateOfBirthRx(String value) => _dateOfBirth.value = value;
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();


  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  DateTime? get selectedDate => _selectedDate.value;
  set selectedDate(DateTime? value) => _selectedDate.value = value;
  // picked image
  final RxList<XFile> _listFile = <XFile>[].obs;
  List<XFile> get listFile => _listFile.value;

  final RxString _urlImage = ''.obs;
  String get urlImage => _urlImage.value;
  final RxString _validateDateOfBirth = ''.obs;
  String get validateDateOfBirth => _validateDateOfBirth.value;

  final RxString _imagePath = ''.obs;
  String get imagePath => _imagePath.value;

  final RxList<ItemBottomSheetModel> _listItemBts = <ItemBottomSheetModel>[].obs;
  List<ItemBottomSheetModel> get listItemBts => _listItemBts.value;

  /// validation

  final RxString _validateName = ''.obs;
  final RxString _validatePhoneNumber = ''.obs;
  final RxString _validateGmail = ''.obs;
  final RxString _validateNewPhoneNumber = ''.obs;


  String get validateName => _validateName.value;
  String get validatePhoneNumber => _validatePhoneNumber.value;
  String get validateGmail => _validateGmail.value;
  String get validateNewPhoneNumber => _validateNewPhoneNumber.value;

  // data user organization
  late Map<String, dynamic> dataUserOrganization;

  ///pinput
  final RxString _pinPutController = ''.obs;
  String get pinPutController => _pinPutController.value;

  final RxBool _isDisable = true.obs;
  bool get isDisable => _isDisable.value;

  /// count down
  final CountdownController timeController = CountdownController(autoStart: false);
  final RxBool _isResend = false.obs;
  bool get isResend => _isResend.value;


  final RxBool _isConfirm = false.obs;
  bool get isConfirm => _isConfirm.value;

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onInit();
    _userService.getUserLoginFromStorage();
    _nameParent.value = _userService.userLogin.name!;
    _phoneNumber.value = _userService.userLogin.phone!;
    _email.value = _userService.userLogin.email;
    _urlImage.value =  _userService.userLogin.image;
    _sex.value = _userService.userLogin.gender!;
    _dateOfBirth.value = _userService.userLogin.dob!;

    dateOfBirthController.text = _dateOfBirth.value;
    nameController.text = _nameParent.value;
    phoneNumberController.text = _phoneNumber.value;
    emailController.text = _email.value;





    _listItemBts.value = [
      ItemBottomSheetModel("camera", '', Icons.camera_alt),
      ItemBottomSheetModel("storage", '', Icons.image_rounded),
    ];
  }

  @override
  void onClose() {
    super.onClose();
    closeScreenOrientation();
  }


  void setTrueIsConfirm() {
    _isConfirm.value = true;
  }
  void setFalseIsConfirm() {
    _isConfirm.value = false;
  }

  Future<void> updateProfileParent() async {
    if(validateFormUpdateProfile()) {
      try {
        Map<String, dynamic> body = {
          'name': _nameParent.value,
          'phone': _phoneNumber.value,
          'gender': _sex.value,
          'dob': _dateOfBirth.value,
          'email': _email.value,
        };

        dio.FormData formData = dio.FormData.fromMap(body);

        if (_imagePath.value.isNotEmpty) {
          File imageFile = File(_imagePath.value);
          body['image'] = imageFile;
          print("imageFile : ${imageFile}");
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
        const JsonEncoder encoder = JsonEncoder.withIndent('  '); // '  ' là 2 dấu cách
        final String prettyJson = encoder.convert(loggableBody);

        print('---------- BEGIN REQUEST BODY ----------');
        print(prettyJson);
        print('----------- END REQUEST BODY -----------');


        LibFunction.showLoading();
        await _userService.updateProfileParent(formData);
        // final data = [
        //     'name': _nameParent.value,
        //     'email': _email.value,
        //     'image': _urlImage.value
        // ];
        // if(data != null) {
        //    _userService.updateUserService(
        //     name: data['name'],
        //     email: data['email'],
        //     image: data['image']
        //   );
        //   print('dataUpdateProfile: ${data}');
        Login updatedParentInfo = Login.fromJson(body);
        await _userService.assignUseLogin(updatedParentInfo);
          LibFunction.hideLoading();
          LibFunction.toast('Cập nhật thông tin thành công');
        // }

      } catch(e) {
        print('Error updateProfileParent: $e');
        LibFunction.hideLoading();
      }
    }
  }

  void resendOTP() {
    timeController.start();
    _isResend.value = false;

    Future.delayed(const Duration(milliseconds: 50), () {
      timeController.start();
    });

  }

  void selectSex(String sex) {
    _sex.value = sex;
  }

  void activeIsResend() {
    _isResend.value = true;
  }

  void isDisableButton() {
    _isDisable.value = false;
  }

  void isActiveButton() {
    _isDisable.value = true;
  }

  bool validateFormUpdateProfile() {
    _validateName.value = _nameParent.value.isEmpty ? "please_enter_name_parents" : "";
    _validatePhoneNumber.value = _phoneNumber.value.isEmpty
        ? "please_enter_phone_number"
        : (!IMUtils.checkPhone(_phoneNumber.value)
            ? "invalid_phone_number"
            : "");

    _validateGmail.value = _email.value.isEmpty
        ? "please_enter_gmail"
        : (!IMUtils.isValidEmail(_email.value)
            ? "gmail_invalid"
            : "");


    return _validatePhoneNumber.value.isEmpty &&
        _validateName.value.isEmpty &&
        _validateGmail.value.isEmpty;

  }
  bool validateDateNewPhone() {
    _validateNewPhoneNumber.value = _newPhoneNumber.value.isEmpty
        ? "please_enter_phone_number"
        : (!IMUtils.checkPhone(_newPhoneNumber.value) ? "invalid_phone_number" : "");

    print('NewPhoneValue: ${_newPhoneNumber.value}');

    return _validateNewPhoneNumber.isEmpty;
  }

  Future<void> getFunctionByIndex(int index, BuildContext context) async {
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

          if (_listFile.isNotEmpty) {
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

  void isEditBtn() {
    _isEdit.value = !_isEdit.value;
  }

  void onChangeInput({required String input, required ProfileInputType type}) {
    switch (type) {
      case ProfileInputType.nameParent:
        _nameParent.value = input;
        break;
      case ProfileInputType.phoneNumber:
        _phoneNumber.value = input;
        break;
      case ProfileInputType.email:
        _email.value = input;
        break;
      case ProfileInputType.newPhoneNumber:
        _newPhoneNumber.value = input;
        break;
      case ProfileInputType.dateOfBirth:
        _dateOfBirth.value = input;
        dateOfBirthController.text = dateOfBirthRx;
        break;
      default:
        break;
    }
  }

  Future<void> closeScreenOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
