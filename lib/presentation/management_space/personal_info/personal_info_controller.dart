import 'dart:convert';
import 'dart:io';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/entities/child_profile/entities/entities.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:permission_handler/permission_handler.dart';

enum PersonalInfoInputType { name, phone }

class PersonalInfoController extends GetxController {
  PersonalInfoController();

  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();
  final _preferencesManager = getIt<SharedPreferencesManager>();

  final _picker = ImagePicker();

  final RxString _parentName = ''.obs;
  final RxString _parentPhone = ''.obs;
  final RxInt indexChild = 0.obs;
  final RxBool isChanged = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool _isImagePicker = false.obs;
  late File? fileAvatar;
  final RxString pathAvatar = "".obs;
  final Rx<UserInfo> userInfo = const UserInfo().obs;

  String get parentName => _parentName.value;
  String get parentPhone => _parentPhone.value;

  final RxString _imageUrlParent = "".obs;
  String get imageUrlParent => _imageUrlParent.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint("Init Personal Info Controller");

    _userService.userInfos.asMap().forEach((index, value) {
      if (value.value.user.id == _userService.currentUser.userId) {
        indexChild.value = index;
        userInfo(value.value);
        _parentName.value = _userService.userLogin.name;
        _parentPhone.value = value.value.parentInfo!.phone;
        _imageUrlParent.value = _userService.userLogin.image;
      }
    });
  }

  void onChangeInput(
      {required String input, required PersonalInfoInputType type}) {
    switch (type) {
      case PersonalInfoInputType.name:
        _parentName.value = input;
        break;
      case PersonalInfoInputType.phone:
        _parentPhone.value = input;
        break;
    }
    isChanged.value = isChangedParentInfo();
  }

  bool isChangedParentInfo() {
    if (userInfo.value.parentInfo!.name != _parentName.value ||
        userInfo.value.parentInfo!.phone != _parentPhone.value) return true;
    return false;
  }

  void onChangeChild(UserInfo uI, int index) {
    try {
      userInfo.value = uI;
      indexChild.value = index;
    } catch (e) {
      LibFunction.toast('error_try_again');
    }
  }

  Future<void> onConfirm() async {
    await LibFunction.effectConfirmPop();
    isLoading.value = true;
    if (_networkService.networkConnection.value) {
      // final bool result = await _userService.updateUserInfo(
      //     parentName: _parentName.value, parentPhone: _parentPhone.value);
      // LibFunction.toast(result ? 'update_success' : 'update_failed');
    } else {
      await _preferencesManager.putString(
        key: KeySharedPreferences.parentUpdate,
        value: jsonEncode(
          Parent(
            name: _parentName.value,
            phone: _parentPhone.value,
          ).toJson(),
        ),
      );

      _userService.updateParentInfo(_parentName.value, _parentPhone.value);

      LibFunction.toast('update_success');
    }
    isLoading.value = false;
  }

  Future<void> onUploadChildAvatar() async {
    await LibFunction.effectConfirmPop();
    isLoading.value = true;

    if (_networkService.networkConnection.value) {
      // final bool result = await _userService.updateChildAvatar(
      //   path: pathAvatar.value,
      //   name: _userService.childProfiles.childProfiles[indexChild.value].name,
      //   studentId:
      //       _userService.childProfiles.childProfiles[indexChild.value].id,
      // );
      // if (result) {
      //   LibFunction.removeFileCache(
      //       _userService.childProfiles.childProfiles[indexChild.value].avatar);
      //   await LibFunction.putFileUintList(
      //     _userService.childProfiles.childProfiles[indexChild.value].avatar,
      //     fileAvatar!.readAsBytesSync(),
      //   );
      // }
      // LibFunction.toast(result ? 'update_success' : 'update_failed');
    } else {
      LibFunction.removeFileCache(
          _userService.childProfiles.childProfiles[indexChild.value].avatar);
      await LibFunction.putFileUintList(
        _userService.childProfiles.childProfiles[indexChild.value].avatar,
        fileAvatar!.readAsBytesSync(),
      );
      handleSaveChildUpdateToStorage(
        _userService.childProfiles.childProfiles[indexChild.value],
      );
      LibFunction.toast('update_success');
    }
    isLoading.value = false;
    cancelUpload();
  }

  void handleSaveChildUpdateToStorage(Child user) {
    final List<Child> ltsChildUpdate =
        getUserUpdateFromStorage(KeySharedPreferences.childsUpdate);
    final int index =
        ltsChildUpdate.indexWhere((element) => element.userId == user.userId);
    if (index != -1) {
      ltsChildUpdate.removeAt(index);
    }
    ltsChildUpdate.add(user);
    saveChildUpdateStorage(KeySharedPreferences.childsUpdate, ltsChildUpdate);
  }

  Future<void> saveChildUpdateStorage(String key, List<Child> data) async {
    await _preferencesManager.putString(
      key: key,
      value: jsonEncode(
        data.map((e) => e.toJson()).toList(),
      ),
    );
  }

  List<Child> getUserUpdateFromStorage(String key) {
    final String? data = _preferencesManager.getString(
      key,
    );
    if (data != null) {
      final decodeData = List<Map<String, dynamic>>.from(jsonDecode(data));

      return decodeData.map<Child>((json) => Child.fromJson(json)).toList();
    }
    return [];
  }

  void cancelUpload() {
    fileAvatar = null;
    pathAvatar.value = "";
  }

  Future<void> toogleImagePicker() async {
    try {
      if (await _checkStoragePermission()) {
        _isImagePicker.value = !_isImagePicker.value;
        useGalleryPicker();
      }
    } catch (error) {
      LibFunction.toast('require_camera_permission');
    }
  }

  Future useGalleryPicker() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
      );
      if (pickedFile != null) {
        //rotate image
        final fixRotate =
            await FlutterExifRotation.rotateImage(path: pickedFile.path);
        fileAvatar = File(fixRotate.path);
        pathAvatar.value = fixRotate.path;
        print('pathAvatar : ${pathAvatar}');
        print('fileAvatar : ${fileAvatar}');


      } else {
        throw 'cannot pick image from camera';
      }
    } catch (error) {
      // Get.back();
      debugPrint("Error on pick image from camera: $error");
    }
  }

  Future<bool> _checkStoragePermission() async {
    try {
      final status = await Permission.mediaLibrary.status;
      if (status != PermissionStatus.granted) {
        return await Permission.mediaLibrary.request().isGranted;
      } else {
        return true;
      }
    } catch (error) {
      return Future.error(error);
    }
  }
}
