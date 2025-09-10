import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:EngKid/domain/ebook/ebook_usecases.dart';
import 'package:EngKid/domain/ebook/entities/ebook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/domain/core/entities/elibrary/elibrary.dart';
import 'package:EngKid/presentation/core/elibrary_service.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_delete.dart';
import 'package:EngKid/widgets/dialog/dialog_downloadwarning.dart';
import 'package:EngKid/widgets/dialog/toast_dialog.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../data/core/local/share_preferences_manager.dart';
import '../../di/injection.dart';
import '../core/user_service.dart';

class ElibraryController extends GetxController with WidgetsBindingObserver {
  final ElibraryService _elibraryService = Get.find<ElibraryService>();
  ElibraryController();
  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  late Timer _timerProgressBar;
  final RxBool _isDownload = false.obs;
  final RxBool _isDownloading = false.obs;
  final RxBool _loadingVideo = false.obs;
  final RxBool _isDownloadedScreen = false.obs;
  final RxInt _loadingProgress = 10.obs;
  final RxList<bool> _isVideoDownloaded = RxList<bool>.filled(2000, false);
  late Uint8List? thumbVideo;
  final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final RxBool _isPressingBook = false.obs;
  Timer? _timer;

  final RxBool _isCheckAll = false.obs;
  bool get isDownload => _isDownload.value;
  bool get isDownloading => _isDownloading.value;
  bool get loadingVideo => _loadingVideo.value;
  int get loadingProgress => _loadingProgress.value;
  bool get isDownloadedScreen => _isDownloadedScreen.value;
  List get isVideoDownloaded => _isVideoDownloaded;
  final RxList<bool> _isBookDownloaded = RxList<bool>.filled(2000, false);
  final RxList<bool> _isMultipleDownloading = RxList<bool>.filled(2000, false);

  final ScrollController scrollControllerCategory = ScrollController();
  final ScrollController scrollControllerBook = ScrollController();
  final ScrollController scrollControllerDownloadElibrary = ScrollController();

  List get isMultipleDownloading => _isMultipleDownloading;
  List get isBookDownloaded => _isBookDownloaded;

  bool get isPressingBook => _isPressingBook.value;

  set isDownload(bool value) {
    if (_isDownloading.value) return;
    _isDownload.value = value;
    _isDownloading.value = false;
  }

  bool get isCheckAll => _isCheckAll.value;

  RxBool get _isCheckDownload => false.obs;
  bool get isCheckDownload => _isCheckDownload.value;


  @override
  Future<void> onInit() async {
    super.onInit();
    LibFunction.playAudioLocal(LocalAudio.chooseLesson);
    if (_networkService.networkConnection.value) {
      await _elibraryService.getElibraryCategory();
      await _elibraryService.getAllEbookWithCateAndStudentId(_elibraryService.categoryList[0].id);
      await _elibraryService.onChangeCategory(0, _elibraryService.categoryList[0].id);
    }
  }

  void onBackPress() async {
    await LibFunction.effectExit();
    Get.back();
  }

  void onChangeBook(int index) {
    _elibraryService.isChangeBook = true;
    _elibraryService.bookIndex = index;
    _elibraryService.isChangeBook = false;
  }

  void onNextBtnPress() {
    // Get.toNamed(
    //   AppRoute.eLibrary,
    // );
  }

  Future<dynamic> onPressBook(int index) async {
    if (!getQuizsFromStorage()) {
      await handleShowDownload(_elibraryService.bookList[_elibraryService.bookIndex].file);
    } else {
      startBook(_elibraryService.bookIndex);
    }
  }

  bool getQuizsFromStorage() {
    final String? book = _preferencesManager.getString(
      "${_userService.currentUser.id}_${_elibraryService.bookList[_elibraryService.bookIndex].id}_bookdatafile.json",
    );

    if (book != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> handleShowDownload(String url) async {
    try {

      _isDownload.value = true;
      _loadingVideo.value = true;
      final mediaQueryData =
          // ignore: deprecated_member_use
          MediaQueryData.fromView(WidgetsBinding.instance.window);
      thumbVideo = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.JPEG,
        maxWidth: mediaQueryData.size.width.ceil(),
        quality: 100,
      );
      _loadingVideo.value = false;
    } on TimeoutException {
      LibFunction.toast("timeout_video_initialize");
    } catch (error) {
      debugPrint("Error on initialize remote video: $error");
    }
  }

  void handleChangeProgressBar() async {
    _timerProgressBar = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_loadingProgress.value < 98 && _isDownloading.value) {
        _loadingProgress.value += 2;
      }
    });
  }

  void startBook(index) {
    Get.toNamed(
      AppRoute.eLibraryVideo,
      arguments: _elibraryService.selectedCateBooks[index],
    );
  }

  void onPressDownload(index) async {
    try {
      await LibFunction.effectConfirmPop();
      _isDownloading.value = true;
      handleChangeProgressBar();
      // saveQuizDownloaded();
      await LibFunction.getSingleFile(
          _elibraryService.bookList[index].file);
      await _elibraryService.saveBookToStorage();
      _loadingProgress.value = 100;
      await Future.delayed(const Duration(milliseconds: 1000));
      // onPressLesson(reading: , );
      LibFunction.toast('download_success');
      startBook(_elibraryService.bookIndex);
    } catch (e) {
      LibFunction.toast('download_failed');
    }
    _isDownloading.value = false;
    _isDownload.value = false;
    _timerProgressBar.cancel();
    _loadingProgress.value = 10;
  }


  void handleCheckAll() {
    _isCheckAll.value = !_isCheckAll.value;
    _isBookDownloaded.value = RxList<bool>.filled(2000, _isCheckAll.value);
  }

  void handleDownload() async {
    // print("ngu");
    await Get.dialog(
      DialogDownloadWarning(onTapContinue: () async {
        //start delete
        for (EBook reading in _elibraryService.bookList) {
          if (_isBookDownloaded[reading.id] == true) {
            // print(reading.name);
            String? isVideoDownloaded = _preferencesManager.getString(
              "${_userService.currentUser.id}_${reading.id}_bookdatafile.json",
            );
            if (isVideoDownloaded == null) {
              _isMultipleDownloading[reading.id] = true;
            }
          }
        }
        for (EBook reading in _elibraryService.bookList) {
          String? isVideoDownloaded = _preferencesManager.getString(
            "${_userService.currentUser.id}_${reading.id}_bookdatafile.json",
          );

          if (_isBookDownloaded[reading.id] == true &&
              isVideoDownloaded == null) {
            // print(reading.name);
            _isMultipleDownloading[reading.id] = true;
            await LibFunction.getSingleFile(reading.file);

            await _preferencesManager.putString(
              key:
                  "${_userService.currentUser.id}_${reading.id}_bookdatafile.json",
              value: jsonEncode(reading.toJson()),
            );
            _elibraryService.downloadAllReadingList.remove(reading);
            _isBookDownloaded[reading.id] = true;
            _isVideoDownloaded[reading.id] = true;
            _isMultipleDownloading[reading.id] = false;
            // print('ngu');
          }
        }
      }),
      barrierDismissible: false,
      barrierColor: null,
    );
  }

  void handleDelete() async {
    bool isContinue = false;
    await Get.dialog(
      DialogDelete(onTapContinue: () async {
        //start delete
        isContinue = true;
        // Get.dialog(ModalBarrier(dismissible: false, color: Colors.transparent));
        Get.dialog(const LoadingDialog());
        showToastWidget(ToastDialog("delete_4".tr),
            duration: const Duration(seconds: 2));
        for (EBook reading in _elibraryService.bookList) {
          if (_isBookDownloaded[reading.id] == true) {
            // await deleteQuizFromStorage(reading.id);
            // final Quiz datafile = await _topicService.getQuiz(reading.id);
            String bookKey =
                "${_userService.currentUser.id}_${reading.id}_bookdatafile.json";
            await _preferencesManager.remove(bookKey);
            await LibFunction.removeFileCache(reading.file);

            // print('ngu');
            // _isBookDownloaded[reading.id] = false;
            _isVideoDownloaded[reading.id] = false;
            _elibraryService.downloadAllReadingList.remove(reading);
          }
        }
        await Future.delayed(const Duration(milliseconds: 2000));
        showToastWidget(ToastDialog("delete_3".tr),
            duration: const Duration(seconds: 3));
        Get.back();
      }),
      barrierDismissible: false,
      barrierColor: null,
    );
    if (isContinue) {
      // await Future.delayed(const Duration(milliseconds: 2000));
      // showToastWidget(ToastDialog("delete_3".tr), duration: const Duration(seconds: 3));
      // Get.back();
    }
  }

  void setIsVideoDownloaded() async {
    for (EBook book in _elibraryService.bookList) {
      String? isBookDownloaded = _preferencesManager.getString(
        "${_userService.currentUser.id}_${book.id}_bookdatafile.json",
      );
      if (isBookDownloaded != null) {
        _isBookDownloaded[book.id] = true;
        _isVideoDownloaded[book.id] = true;
      } else {
        _isBookDownloaded[book.id] = false;
        _isVideoDownloaded[book.id] = false;
      }
    }
  }

  void handleDownloadStatusChange(int readingId, bool currentStatus) {
    _isBookDownloaded[readingId] = !currentStatus;
    if (!_isBookDownloaded[readingId]) {
      _isCheckAll.value = _isBookDownloaded[readingId];
    }
  }

  void handleChangeDownloadedScreen(bool value) {
    _isDownloadedScreen.value = value;

    _elibraryService.downloadAllReadingList.clear();
    for (EBook elibrary in _elibraryService.bookList) {
      if (_isVideoDownloaded[elibrary.id] == value) {
        _elibraryService.downloadAllReadingList.add(elibrary);
      }
    }
  }

  void handleDeleteSingle(EBook elibrary) async {
    bool isContinue = false;
    await Get.dialog(
      DialogDelete(onTapContinue: () async {
        //start delete
        isContinue = true;
        Get.dialog(const LoadingDialog());
        showToastWidget(ToastDialog("delete_4".tr),
            duration: const Duration(seconds: 2));
        if (_isBookDownloaded[elibrary.id] == true) {
          String bookKey =
              "${_userService.currentUser.id}_${elibrary.id}_bookdatafile.json";
          await _preferencesManager.remove(bookKey);
          await LibFunction.removeFileCache(elibrary.file);
          // await LibFunction.removeFileCache(datafile.reading.video);
          _isVideoDownloaded[elibrary.id] = false;
          // _isBookDownloaded[elibrary.id] = false;
          _isVideoDownloaded[elibrary.id] = false;
          _elibraryService.downloadAllReadingList.remove(elibrary);
        }
        await Future.delayed(const Duration(milliseconds: 2000));
        showToastWidget(ToastDialog("delete_3".tr),
            duration: const Duration(seconds: 3));
        Get.back();
      }),
      barrierDismissible: false,
      barrierColor: null,
    );
    if (isContinue) {
      // Get.back();
      // Get.dialog(ModalBarrier(dismissible: false, color: Colors.transparent));
      // showToastWidget(ToastDialog("delete_4".tr), duration: const Duration(seconds: 2 ));
      // await Future.delayed(const Duration(milliseconds: 2000));
      // showToastWidget(ToastDialog("delete_3".tr), duration: const Duration(seconds: 3));
      // Get.back();
    }
  }

  void handlePressingBook() {
    _isPressingBook.value = !_isPressingBook.value;
    // _overlayFuture?.then((_) {});
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      _isPressingBook.value = false;
    });
  }
}
