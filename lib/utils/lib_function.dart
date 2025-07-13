import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:EngKid/domain/core/entities/day_of/day_of.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:EngKid/data/core/local/share_preferences_manager.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/start_board/entities/entities.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/audio_control.dart';
import 'package:EngKid/utils/audios.dart';
import 'package:EngKid/utils/background_audio_control.dart';
import 'package:EngKid/utils/cache_control.dart';
import 'package:EngKid/widgets/dialog/dialog_alert.dart';
import 'package:EngKid/widgets/dialog/toast_dialog.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:oktoast/oktoast.dart';
import 'package:vibration/vibration.dart';

class LibFunction {
  LibFunction._();
  static final _preferencesManager = getIt.get<SharedPreferencesManager>();

  static List<dynamic> chunkArray(List data, int size) {
    final chunks = [];
    for (int i = 0; i < data.length; i += size) {
      final end = (i + size) < data.length ? i + size : data.length;
      chunks.add(data.sublist(i, end));
    }
    return chunks;
  }

  static int getCurrentTimeNow() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static void toast(String message) {
    dismissAllToast();
    showToastWidget(ToastDialog(message), duration: const Duration(seconds: 3));
  }

  static void alert(String message) {
    Get.dialog(DialogAlert(message: message));
  }

  static void showLoading({
    double? sizeIndi,
    Color? color,
    String? des,
  }) {
    Get.dialog(
      LoadingDialog(
        sizeIndi: sizeIndi,
        color: color,
        des: des,
      ),
      barrierColor: AppColor.toastBackground,
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
      Get.back();
    }
  }

  static void showSnackbar({
    required String message,
    Color backgroundColor = AppColor.primary,
  }) {
    Get.rawSnackbar(
      messageText: RegularText(
        message.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      padding: const EdgeInsets.all(10.0),
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  static bool checkPaidValid(String timestamp) {
    if (timestamp.isNotEmpty) {
      final DateTime data = DateTime.now();
      final int isNow = (data.millisecondsSinceEpoch / 1000).round();
      if (isNow < int.parse(timestamp)) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  static Future<void> setVolumeMusic(double volume) async {
    await AudioControl.instance.setVolume(volume);
    await BackgroundAudioControl.instance.setVolume(volume);
  }

  static Future<void> effectWrongAnswer() async {
    await AudioControl.instance.playLocalAudio(url: LocalAudio.wrong);
    Vibration.vibrate(duration: 200);
  }

  static Future<void> effectTrueAnswer() async {
    await AudioControl.instance.playLocalAudio(url: LocalAudio.correct);
  }

  static Future<void> effectFinish() async {
    await AudioControl.instance.playLocalAudio(url: LocalAudio.finish);
  }

  static Future<void> effectConfirmPop() async {
    await AudioControl.instance.playLocalAudio(url: LocalAudio.confirmPop);
  }

  static Future<void> effectExit() async {
    await AudioControl.instance.playLocalAudio(url: LocalAudio.exit);
  }

  static Future<void> playAudioLocal(String url) async {
    try {
      await AudioControl.instance.playLocalAudio(url: url);
    } catch (e) {
      //
    }
  }

  static Future<void> playAudioNetwork(String url) async {
    try {
      await AudioControl.instance
          .playNetworkAudio(dotenv.get('API_NETWORK_URL') + url);
    } catch (e) {
      //
    }
  }

  static Future<void> playBackgroundSound(String url) async {
    try {
      await BackgroundAudioControl.instance.playSound(url: url, isLoop: true);
    } catch (e) {
      //
    }
  }

  static Future<void> stopBackgroundSound() async {
    try {
      await BackgroundAudioControl.instance.stopSound();
    } catch (e) {
      //
    }
  }

  static Future<void> pauseBackgroundSound() async {
    try {
      await BackgroundAudioControl.instance.pause();
    } catch (e) {
      //
    }
  }

  static Future<void> rePlayBackgroundSound() async {
    try {
      await BackgroundAudioControl.instance.play();
    } catch (e) {
      //
    }
  }

  static bool isPhoneValid(String phoneNumber) {
    final RegExp regex = RegExp(r'^0[0-9]{9,10}$');
    return regex.hasMatch(phoneNumber);
  }

  static List randomChoice(List inputList) {
    final List tempList = List.castFrom(inputList);
    if (tempList.length <= 2) {
      final firsItem = tempList[0];
      tempList[0] = inputList[inputList.length - 1];
      tempList[tempList.length - 1] = firsItem;
    } else {
      final random = Random();
      for (var i = tempList.length - 1; i > 0; i--) {
        final int number = random.nextInt(i + 1);
        final temp = tempList[i];
        tempList[i] = tempList[number];
        tempList[number] = temp;
      }
    }

    return tempList;
  }

  static List<dynamic> shuffle(List lts) {
    final List<dynamic> items = List.from(lts);
    final random = Random();
    for (var i = items.length - 1; i > 0; i--) {
      final n = random.nextInt(i + 1);

      final temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  static String durationFormat(Duration duration) {
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  static String vietnameseEncode(String input) {
    const vietnamese = 'aAeEoOuUiIdDyY';
    final vietnameseRegex = <RegExp>[
      RegExp('à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
      RegExp('À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
      RegExp('è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
      RegExp('È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
      RegExp('ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
      RegExp('Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
      RegExp('ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
      RegExp('Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
      RegExp('ì|í|ị|ỉ|ĩ'),
      RegExp('Ì|Í|Ị|Ỉ|Ĩ'),
      RegExp('đ'),
      RegExp('Đ'),
      RegExp('ỳ|ý|ỵ|ỷ|ỹ'),
      RegExp('Ỳ|Ý|Ỵ|Ỷ|Ỹ')
    ];

    var result = input;
    for (var i = 0; i < vietnamese.length; ++i) {
      result = result.replaceAll(vietnameseRegex[i], vietnamese[i]);
    }
    return result.toLowerCase().replaceAll(RegExp(r"\s+"), "");
  }

  static Future<Image> getImage(String path) async {
    final Completer<ImageInfo> completer = Completer();
    final img = NetworkImage(path);
    // ignore: use_named_constants
    img.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info);
      }),
    );
    final ImageInfo imageInfo = await completer.future;
    return imageInfo.image as Image;
  }

  static void getFileStream(String url) {
    CacheControl.instance.getFileStream(url);
  }

  static Future<void> putFileUintList(String url, Uint8List data,
      {String fileExtension = 'file'}) async {
    await CacheControl.instance
        .putFileUint8List(url, data, fileExtension: fileExtension);
  }

  static Future<File> getSingleFile(String url) async {
    return await CacheControl.instance.getSingleFile(url);
  }

  static Future<void> removeFile(String url) async {
    return await CacheControl.instance.removeFileCache(url);
  }

  static Future<String> getFileFromCache(String url) async {
    return await CacheControl.instance.getFileFromCache(url);
  }

  static Future<void> removeFileCache(String url) async {
    await CacheControl.instance.removeFileCache(url);
  }

  static Future<void> downloadFile(String url) async {
    await CacheControl.instance.downloadFile(url);
  }

  static Future<void> emptyCache() async {
    await CacheControl.instance.emptyCache();
  }

  static String getWeekInYearOfDate(DateTime time) {
    final DateTime now = DateTime.now();
    DateTime startDateOfYear = DateTime(now.year, 1, 1);
    int dayOfYear = time.difference(startDateOfYear).inDays + 1;
    return "${DateFormat('yyyy').format(time)}-${(dayOfYear / 7).ceil()}";
  }

  static int getIndexDayInWeek(DateTime time) {
    String weekday = DateFormat('EEEE').format(time);
    switch (weekday) {
      case 'Monday':
        // print('Hôm nay là thứ 2');
        return 0;
      case 'Tuesday':
        // print('Hôm nay là thứ 3');
        return 1;
      case 'Wednesday':
        // print('Hôm nay là thứ 4');
        return 2;
      case 'Thursday':
        // print('Hôm nay là thứ 5');
        return 3;
      case 'Saturday':
        // print('Hôm nay là thứ 7');
        return 4;
      case 'Friday':
        // print('Hôm nay là thứ 6');
        return 5;
      case 'Sunday':
        // print('Hôm nay là chủ nhật');
        return 6;
      default:
        return 0;
    }
  }

  static Future<void> saveHistoryStorage(String key, List<History> data) async {
    await _preferencesManager.putString(
      key: key,
      value: jsonEncode(
        data.map((e) => e.toJson()).toList(),
      ),
    );
  }

  static List<History> getHistoryFromStorage(String key) {
    final String? data = _preferencesManager.getString(
      key,
    );
    if (data != null) {
      final decodeData = List<Map<String, dynamic>>.from(jsonDecode(data));

      return decodeData.map<History>((json) => History.fromJson(json)).toList();
    }
    return [];
  }

  // Chuyển đổi chuỗi ngày thành đối tượng DateTime
  static DateTime parseDate(String dateStr) {
    return DateTime.parse(dateStr);
  }

  static double scaleForCurrentValue(Size screenSize, double designOut,
      {int desire = 0}) {
    // 0: scale by width
    // 1: scale by height
    // 2: scale by both
    try {
      const int designScreenWidth = 1920;
      const int designScreenHeight = 1080;
      late double desireResult;
      if (desire == 0) {
        final double scale = screenSize.width / designScreenWidth;
        desireResult = designOut * scale;
      } else if (desire == 1) {
        final double scale = screenSize.height / designScreenHeight;
        desireResult = designOut * scale;
      }
      return desireResult;
    } catch (e) {
      return designOut;
    }
  }

  static void saveIds({required key, required int id}) async {
    final List<String>? ids = _preferencesManager.getStringList(key);
    if (ids != null) {
      ids.add(id.toString());
      await _preferencesManager.putStringList(key: key, value: ids);
    } else {
      await _preferencesManager.putStringList(key: key, value: [id.toString()]);
    }
  }

  static DateTime startOfDateNow() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd 00:00:00').format(now);
    return DateTime.parse(formattedDate);
  }

  static String formatDate(DateTime datetime, String format) {
    return DateFormat(format).format(datetime).toString();
  }

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int getWeekNumberForDate(DateTime date, List<DayOf> weekDefinitions) {
    final int dayOfMonth = date.day;
    try {
      for (int i = 0; i < weekDefinitions.length; i++) {
        final String subText = weekDefinitions[i].subText;
        final List<String> rangeParts = subText.split('-');
        if (rangeParts.length == 2) {
          final int startDay = int.tryParse(rangeParts[0]) ?? 0;
          final int endDay = int.tryParse(rangeParts[1]) ?? 0;

          if (dayOfMonth >= startDay && dayOfMonth <= endDay) {
            return i;
          }
        }
      }
      return weekDefinitions.length - 1;
    } catch (e) {
      return weekDefinitions.length - 1;
    }
  }
}
