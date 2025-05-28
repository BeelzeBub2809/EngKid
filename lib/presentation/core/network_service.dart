import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EzLish/utils/app_color.dart';
import 'package:EzLish/utils/lib_function.dart';

class NetworkService extends GetxService {
  late StreamSubscription _connectivitySubscription;
  bool _isInitApp = true;

  final RxBool _networkConnection = false.obs;
  RxBool get networkConnection => _networkConnection;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((event) => checkConnection(onInitApp: _isInitApp));
  }

  Future<void> checkConnection({required bool onInitApp}) async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (Get.isSnackbarOpen == true) {
        Get.back();
      }
      switch (result) {
        case ConnectivityResult.wifi:
          if (!_networkConnection.value) {
            _networkConnection.value = true;
          }
          if (!onInitApp) {
            LibFunction.showSnackbar(
              message: 'Kết nối wifi',
            );
          } else {
            _isInitApp = false;
          }
          break;
        case ConnectivityResult.mobile:
          if (!_networkConnection.value) {
            _networkConnection.value = true;
          }
          LibFunction.showSnackbar(
            message: 'Lưu ý, bạn đang sử dụng dữ liệu di động (3G/4G)',
            backgroundColor: AppColor.secondary,
          );
          break;
        case ConnectivityResult.none:
          _networkConnection.value = false;
          LibFunction.showSnackbar(
            message: 'Mất kết nối mạng!',
            backgroundColor: AppColor.deny,
          );
          break;
        default:
          break;
      }
    } catch (error) {
      debugPrint("Error on get network status: $error");
    }
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}
