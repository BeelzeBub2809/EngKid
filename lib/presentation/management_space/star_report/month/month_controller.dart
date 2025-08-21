import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/domain/start_board/entities/entities.dart';
import 'package:EngKid/domain/start_board/star_board_usecases.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';

class MonthController extends GetxController {
  final StarBoardUseCases starBoardUseCases;
  MonthController({required this.starBoardUseCases});

  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  late String curMonth = "08/2025";
  late String preMonth = "07/2025";
  late RxDouble total = 0.0.obs;
  late RxDouble totalThisMonth = 0.0.obs;
  late RxDouble totalLastMonth = 0.0.obs;
  late double maxYThisMonth = 0;
  late double maxYLastMonth = 0;

  final RxList<DayOf> weeksOfThisMonth = <DayOf>[
    const DayOf(text: "w1", subText: '\n01-07', left: 0.02, value: 0),
    const DayOf(text: "w2", subText: '\n08-14', left: 0.1, value: 0),
    const DayOf(text: "w3", subText: '\n15-21', left: 0.18, value: 0),
    const DayOf(text: "w4", subText: '\n22-28', left: 0.26, value: 0),
  ].obs;

  final RxList<DayOf> weeksOfLastMonth = <DayOf>[
    const DayOf(text: "w1", subText: '\n01-07', left: 0.02, value: 0),
    const DayOf(text: "w2", subText: '\n08-14', left: 0.1, value: 0),
    const DayOf(text: "w3", subText: '\n15-21', left: 0.18, value: 0),
    const DayOf(text: "w4", subText: '\n22-28', left: 0.26, value: 0),
  ].obs;

  final RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint("Init Month Controller");
    getStarsHistory();
  }

  Future<void> getStarsHistory() async {
    try {
      isLoading.value = true;

      // this month
      await getHistoryByThisMonth();

      // last month
      await getHistoryByLastMonth();
    } catch (e) {
      //
    }
    isLoading.value = false;
  }

  Future<void> getHistoryByThisMonth() async {
    totalThisMonth.value = 0.0;
    final DateTime now = DateTime.now();
    final DateTime firstDayOfMonth = DateTime.utc(now.year, now.month, 1);
    final int daysInMonth = DateTime.utc(now.year, now.month + 1, 0).day;
    final DateTime lastDayOfMonth =
        firstDayOfMonth.add(Duration(days: daysInMonth - 1));
    curMonth = DateFormat('MM/yyyy').format(firstDayOfMonth).toString();
    DateTime startDateOfYear = DateTime(now.year, 1, 1);
    try {
      late List<History> thisMonth = [];
      if (_networkService.networkConnection.value) {
        thisMonth = await starBoardUseCases.getStarsHistory(
          studentId: _userService.currentUser.id,
          startDate:
              DateFormat('yyyy-MM-dd').format(firstDayOfMonth).toString(),
          endDate: DateFormat('yyyy-MM-dd').format(lastDayOfMonth).toString(),
        );
      } else {
        thisMonth = LibFunction.getHistoryFromStorage(
            KeySharedPreferences.starOfTwoYear);
      }
      int dayOfYear = firstDayOfMonth.difference(startDateOfYear).inDays + 1;
      final String weekFirstOfMonth =
          "${DateFormat('yyyy').format(firstDayOfMonth)}-${(dayOfYear / 7).ceil()}";

      final Map<String, double> thisWeeklyData = {
        weekFirstOfMonth: 0,
      };
      List.generate(
          3,
          (index) => thisWeeklyData[
              "${DateFormat('yyyy').format(firstDayOfMonth)}-${(dayOfYear / 7).ceil() + index + 1}"] = 0);

      for (final History history in thisMonth) {
        // Định dạng ngày thành chuỗi "yyyy-Www" (vd: "2023-21")
        // Tính toán tổng số liệu cho từng tuần
        final DateTime date = LibFunction.parseDate(history.date);
        final int tmp = date.difference(startDateOfYear).inDays + 1;
        if ((tmp / 7).ceil() >= (dayOfYear / 7).ceil() &&
            date.month == firstDayOfMonth.month) {
          final String week =
              "${DateFormat('yyyy').format(date)}-${(tmp / 7).ceil()}";
          thisWeeklyData[week] = (thisWeeklyData[week] ?? 0) + history.star;
        }
      }

      int dayOfYearNow = now.difference(startDateOfYear).inDays + 1;
      String currentWeek =
          "${DateFormat('yyyy').format(now)}-${(dayOfYearNow / 7).ceil()}";

      final sortedKeysThisWeek = thisWeeklyData.keys.toList()..sort();
      final sortedMapThisWeek = {
        for (var k in sortedKeysThisWeek) k: thisWeeklyData[k]
      };
      List<MapEntry<String, dynamic>> list = sortedMapThisWeek.entries.toList();
      weeksOfThisMonth.asMap().forEach((index, value) {
        final double star = index < list.length ? list[index].value : 0.0;

        totalThisMonth.value += star;

        weeksOfThisMonth[index] = weeksOfThisMonth[index].copyWith(
          value: star,
          subText: index == weeksOfThisMonth.length - 1
              ? '\n22-${DateFormat('dd').format(lastDayOfMonth)}'
              : weeksOfThisMonth[index].subText,
          isHighlight:
              index < list.length && list[index].key.contains(currentWeek)
                  ? true
                  : false,
        );
        debugPrint("Week ${index + 1} this month: $star stars");
      });

      // Tính maxYThisMonth từ các giá trị tuần thực tế
      maxYThisMonth = 0;
      for (final week in weeksOfThisMonth) {
        if (week.value > maxYThisMonth) {
          maxYThisMonth = week.value;
        }
      }
      if (maxYThisMonth == 0) maxYThisMonth = 1;
    } catch (e) {
      //
    }
  }

  Future<void> getHistoryByLastMonth() async {
    totalLastMonth.value = 0.0;
    final DateTime now = DateTime.now();
    final DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final DateTime lastDayOfLastMonth = DateTime(now.year, now.month, 0);
    preMonth = DateFormat('MM/yyyy').format(firstDayOfLastMonth).toString();
    DateTime startDateOfYear = DateTime(now.year, 1, 1);
    try {
      late List<History> lastMonth = [];
      if (_networkService.networkConnection.value) {
        lastMonth = await starBoardUseCases.getStarsHistory(
          studentId: _userService.currentUser.id,
          startDate:
              DateFormat('yyyy-MM-dd').format(firstDayOfLastMonth).toString(),
          endDate:
              DateFormat('yyyy-MM-dd').format(lastDayOfLastMonth).toString(),
        );
      } else {
        lastMonth = LibFunction.getHistoryFromStorage(
            KeySharedPreferences.starOfTwoYear);
      }
      int dayOfYear =
          firstDayOfLastMonth.difference(startDateOfYear).inDays + 1;
      final String weekFirstOfLastMonth =
          "${DateFormat('yyyy').format(firstDayOfLastMonth)}-${(dayOfYear / 7).ceil()}";

      final Map<String, double> lastWeeklyData = {
        weekFirstOfLastMonth: 0,
      };

      List.generate(
          3,
          (index) => lastWeeklyData[
              "${DateFormat('yyyy').format(firstDayOfLastMonth)}-${(dayOfYear / 7).ceil() + index + 1}"] = 0);

      for (final History history in lastMonth) {
        // Định dạng ngày thành chuỗi "yyyy-w" (vd: "2023-21")
        // Tính toán tổng số liệu cho từng tuần
        final DateTime date = LibFunction.parseDate(history.date);
        final int tmp = date.difference(startDateOfYear).inDays + 1;
        if ((tmp / 7).ceil() >= (dayOfYear / 7).ceil() &&
            date.month == lastDayOfLastMonth.month) {
          final String week =
              "${DateFormat('yyyy').format(date)}-${(tmp / 7).ceil()}";
          lastWeeklyData[week] = (lastWeeklyData[week] ?? 0) + history.star;
        }
      }

      final sortedKeysLastWeek = lastWeeklyData.keys.toList()..sort();
      final sortedMapLastWeek = {
        for (var k in sortedKeysLastWeek) k: lastWeeklyData[k]
      };
      List<MapEntry<String, dynamic>> list = sortedMapLastWeek.entries.toList();

      weeksOfLastMonth.asMap().forEach((index, value) {
        final double star = index < list.length ? list[index].value : 0.0;

        totalLastMonth.value += star;

        weeksOfLastMonth[index] = weeksOfLastMonth[index].copyWith(
          value: star,
          subText: index == weeksOfLastMonth.length - 1
              ? '\n22-${DateFormat('dd').format(lastDayOfLastMonth)}'
              : weeksOfLastMonth[index].subText,
        );
        debugPrint("Week ${index + 1} last month: $star stars");
      });

      // Tính maxYLastMonth từ các giá trị tuần thực tế
      maxYLastMonth = 0;
      for (final week in weeksOfLastMonth) {
        if (week.value > maxYLastMonth) {
          maxYLastMonth = week.value;
        }
      }
      if (maxYLastMonth == 0) maxYLastMonth = 1;

      total.value = totalThisMonth.value + totalLastMonth.value;
    } catch (e) {
      //
    }
  }
}
