import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_captcha/local_captcha.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:timer_count_down/timer_controller.dart';
import '../../domain/login/login_usecases.dart';
import '../../domain/organization/entities/organization/organization.dart';
import '../../utils/app_route.dart';
import '../../utils/im_utils.dart';

enum RegisterInputType {
  nameParents,
  phoneNumber,
  gmailAddress,
  childName,
  sex,
  disability,
  address,
  loginId,
  password,
  confirmPassword,
}

class RegisterController extends GetxController {
  final RxString _nameParents = ''.obs;
  final RxString _phoneNumber = ''.obs;
  final RxString _gmailAddress = ''.obs;
  final RxString _sex = ''.obs;
  final RxString _disability = ''.obs;
  final RxString _loginId = ''.obs;
  final RxString _address = ''.obs;
  final RxString _password = ''.obs;
  final RxString _confirmPassword = ''.obs;

  String get nameParentsRx => _nameParents.value;
  String get phoneNumberRx => _phoneNumber.value;
  String get gmailAddressRx => _gmailAddress.value;
  String get sexRx => _sex.value;
  String get disabilityRx => _disability.value;
  String get loginId => _loginId.value;
  String get address => _address.value;
  String get password => _password.value;
  String get confirmPassword => _confirmPassword.value;

  final RxMap<String, dynamic> _selectedProvinces = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> _selectedWards = <String, dynamic>{}.obs;

  Map<String, dynamic> get selectedProvinces => _selectedProvinces.value;
  Map<String, dynamic> get selectedWards => _selectedWards.value;

  /// validate form
  final RxString _validateNameParents = ''.obs;
  final RxString _validatePhoneNumber = ''.obs;
  final RxString _validateGmail = ''.obs;
  final RxString _validateSex = ''.obs;
  final RxString _validateProvinces = ''.obs;
  final RxString _validateWards = ''.obs;
  final RxString _validateAddress = ''.obs;
  final RxString _validatePassword = ''.obs;
  final RxString _validateConfirmPassword = ''.obs;

  final RxString _validateDisability = ''.obs;
  final RxString _validateIdLogin = ''.obs;

  String get validateNameParents => _validateNameParents.value;
  String get validatePhoneNumber => _validatePhoneNumber.value;
  String get validateGmail => _validateGmail.value;
  String get validateSex => _validateSex.value;

  String get validateProvinces => _validateProvinces.value;
  String get validateWards => _validateWards.value;
  String get validateAddress => _validateAddress.value;

  String get validateDisability => _validateDisability.value;
  String get validateIdLogin => _validateIdLogin.value;
  String get validatePassword => _validatePassword.value;
  String get validateConfirmPassword => _validateConfirmPassword.value;

  ///pinput
  final RxString _pinPutController = ''.obs;
  String get pinPutController => _pinPutController.value;
  final RxBool _isDisable = true.obs;
  bool get isDisable => _isDisable.value;

  final CountdownController timeController =
      CountdownController(autoStart: false);
  final RxBool _isResend = false.obs;
  bool get isResend => _isResend.value;

  final LoginUsecases loginUsecases;

  RegisterController({required this.loginUsecases});

  final RxList<Organization> _listOrganization = <Organization>[].obs;
  List<Organization> get listOrganization => _listOrganization;

  final RxList<Organization> _listWard = <Organization>[].obs;
  List<Organization> get listWard => _listWard;

  final RxList<Organization> _listSchool = <Organization>[].obs;
  List<Organization> get listSchool => _listSchool;

  /// captcha
  final captchaFormKey = GlobalKey<FormState>();
  final configFormKey = GlobalKey<FormState>();
  final localCaptchaController = LocalCaptchaController();
  final configFormData = ConfigFormData();
  final refreshButtonEnableVN = ValueNotifier(true);
  var inputCode = '';
  Timer? refreshTimer;
  final RxBool _isCheckCaptcha = false.obs;
  bool get isCheckCaptcha => _isCheckCaptcha.value;

  final RxBool _isShowCaptcha = false.obs;
  bool get isShowCaptcha => _isShowCaptcha.value;

  @override
  void onInit() {
    super.onInit();
    initScreenOrientation();
  }

  @override
  void dispose() {
    localCaptchaController.dispose();
    refreshTimer?.cancel();
    refreshTimer = null;
    _pinPutController.value = '';
    super.dispose();
  }

  Future<void> initScreenOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> closeScreenOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void onClose() {
    closeScreenOrientation();
    super.onClose();
  }

  void isDisableButton() {
    _isDisable.value = false;
  }

  void isActiveButton() {
    _isDisable.value = true;
  }

  // validate fe
  bool validateFormRegister() {
    _validatePhoneNumber.value = _phoneNumber.value.isEmpty
        ? "please_enter_phone_number"
        : (!IMUtils.checkPhone(_phoneNumber.value)
            ? "invalid_phone_number"
            : "");

    _validateNameParents.value =
        _nameParents.value.isEmpty ? "please_enter_name_parents" : "";
    _validateGmail.value = _gmailAddress.value.isEmpty
        ? "please_enter_gmail"
        : (!IMUtils.isValidEmail(_gmailAddress.value) ? "gmail_invalid" : "");

    _validateSex.value = _sex.value.isEmpty ? "please_enter_sex" : "";
    _validateIdLogin.value = _loginId.value.isEmpty
        ? "please_enter_login_id"
        : (!IMUtils.checkLoginId(_loginId.value) ? "login_id_invalid" : "");

    _validateDisability.value =
        _disability.value.isEmpty ? "please_enter_disability" : "";

    _validateProvinces.value =
        _selectedProvinces.value.isEmpty ? "please_enter_provinces" : "";
    _validateWards.value =
        _selectedWards.value.isEmpty ? "please_enter_wards" : "";
    _validateAddress.value =
        _address.value.isEmpty ? "please_enter_address" : "";

    return _validatePhoneNumber.value.isEmpty &&
        _validateNameParents.value.isEmpty &&
        _validateGmail.value.isEmpty &&
        _validateSex.value.isEmpty &&
        _validateIdLogin.value.isEmpty;
  }

  // check otp và create account
  void signUpAccount() async {
    if (validateFormRegister()) {
      Map<String, dynamic> body = {
        'name': _nameParents.value,
        'email': _gmailAddress.value,
        'phone': _phoneNumber.value,
        'gender': _sex.value,
        'username': _loginId.value,
        'password': _password.value,
      };

      try {
        final data = await loginUsecases.signUp(body);
        print('dataSignUp : ${data}');
        if (data) {
          LibFunction.toast('Đăng ký thành công');
          closeScreenOrientation();
          // resetAll();
          Get.back();
        }else{
          LibFunction.toast('Đăng ký thất bại. Vui lòng thử lại sau');
        }
      } catch (e) {
        LibFunction.toast(e.toString());
      }
    }
  }

  void resetAll() {
    _nameParents.value = '';
    _gmailAddress.value = '';
    _phoneNumber.value = '';
    _sex.value = '';
    _disability.value = '';
    _loginId.value = '';
    _address.value = '';
    _isCheckCaptcha.value = false;
    _isShowCaptcha.value = false;
  }

  void onChangeInput({required String input, required RegisterInputType type}) {
    switch (type) {
      case RegisterInputType.nameParents:
        _nameParents.value = input;
        break;
      case RegisterInputType.phoneNumber:
        _phoneNumber.value = input;
        break;
      case RegisterInputType.gmailAddress:
        _gmailAddress.value = input;
        break;
      case RegisterInputType.loginId:
        _loginId.value = input;
        break;
      case RegisterInputType.sex:
        _sex.value = input;
        break;
      case RegisterInputType.address:
        _address.value = input;
        break;
      case RegisterInputType.password:
        _password.value = input;
        break;
      case RegisterInputType.confirmPassword:
        _confirmPassword.value = input;
        break;
      default:
        break;
    }
    update();
  }

  void selectGender(String gender) {
    _sex.value = gender;
  }

}

class ConfigFormData {
  String chars = 'abdefghnryABDEFGHNQRY3468';
  int length = 5;
  double fontSize = 0;
  bool caseSensitive = false;
  Duration codeExpireAfter = const Duration(minutes: 10);

  @override
  String toString() {
    return '$chars$length$caseSensitive${codeExpireAfter.inMinutes}';
  }
}
