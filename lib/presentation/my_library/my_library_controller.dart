import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/grade/entities/grade/grade.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';

import '../core/network_service.dart';
class MyLibraryController extends GetxController {
  MyLibraryController();

  // Add any necessary methods or properties for the MyLibraryController here
  // For example, you might want to manage a list of books or topics in the library
  // and provide methods to add, remove, or fetch them.
  final TopicService _topicService = Get.find<TopicService>();
  final NetworkService _networkService = Get.find<NetworkService>();
  @override
  Future<void> onInit() async {
    super.onInit();
    _topicService.isCaculator = Get.arguments ?? true;
    final gotFromStorage = await _topicService.getGradesFromStorage(isAwait: true);
    if (!gotFromStorage) {
      await _topicService.getLibrary();
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      LibFunction.playAudioLocal(LocalAudio.chooseGrade);
    });
  }

  void onBackPress() async {
    await LibFunction.effectExit();
    Get.back();
  }

  void onPressGrade(Grade grade) async {
    if (!grade.isOpen) {
      LibFunction.playAudioLocal(LocalAudio.lock);
    } else {
      await LibFunction.effectConfirmPop();
      if (_networkService.networkConnection.value) {
        _topicService.currentGrade = grade;
        Get.toNamed(AppRoute.readingSpace);
      } else if (grade.id == _topicService.currentGrade.id) {
        Get.toNamed(AppRoute.readingSpace);
      } else {
        LibFunction.toast('require_network_to_grade');
      }
    }
  }
}