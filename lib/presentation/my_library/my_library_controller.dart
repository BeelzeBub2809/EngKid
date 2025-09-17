import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../core/network_service.dart';

class MyLibraryController extends GetxController {
  MyLibraryController();

  final NetworkService _networkService = Get.find<NetworkService>();

  final RxList<Map<String, dynamic>> learningPaths = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Basic English',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 2,
      'name': 'Vocabulary',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 3,
      'name': 'Grammar',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
    {
      'id': 4,
      'name': 'Speaking',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
    {
      'id': 5,
      'name': 'Reading',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': true,
    },
    {
      'id': 6,
      'name': 'Writing',
      'image': 'assets/images/elibrary_book_icon.png',
      'isOpen': false,
    },
  ].obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 1000), () {
      LibFunction.playAudioLocal(LocalAudio.chooseGrade);
    });
  }

  void onBackPress() async {
    await LibFunction.effectExit();
    Get.back();
  }

  void onPressLearningPath(Map<String, dynamic> learningPath) async {
    if (!learningPath['isOpen']) {
      LibFunction.playAudioLocal(LocalAudio.lock);
    } else {
      await LibFunction.effectConfirmPop();
      if (_networkService.networkConnection.value) {
        Get.toNamed(AppRoute.readingSpace, arguments: learningPath);
      } else {
        LibFunction.toast('require_network_to_grade');
      }
    }
  }
}
