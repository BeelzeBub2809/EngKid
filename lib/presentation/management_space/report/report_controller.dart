import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:EngKid/domain/core/entities/day_of/day_of.dart';
import 'package:EngKid/domain/core/entities/nav_item/nav_item.dart';
import 'package:EngKid/domain/start_board/entities/entities.dart';
import 'package:EngKid/presentation/core/network_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/utils/key_shared_preferences.dart';
import 'package:EngKid/utils/lib_function.dart';

enum TypeFunc { prev, next }

class ReportController extends GetxController {
  ReportController();

  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();
  final List<Rx<NavItem>> _navBar = [
    const NavItem(title: 'week', isActive: true).obs,
    const NavItem(title: 'month', isActive: false).obs,
    const NavItem(title: 'year', isActive: false).obs,
  ];
  final RxInt totalReaded = 0.obs;
  final RxDouble averageTime = (0.0).obs;
  final RxDouble totalTime = (0.0).obs;
  final RxInt _indexActive = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isShowThis = false.obs;

  late DateTime currentDate;
  late double maxY = 0;
  final RxString timeTitle = "--/--/----".obs;
  final RxString timeSub = "--/--/---- - --/--/----".obs;

  final List<DayOf> daysOfWeek = [
    const DayOf(text: "t2", value: 0),
    const DayOf(text: "t3", value: 0),
    const DayOf(text: "t4", value: 0),
    const DayOf(text: "t5", value: 0),
    const DayOf(text: "t6", value: 0),
    const DayOf(text: "t7", value: 0),
    const DayOf(text: "cn", value: 0),
  ];

  final List<DayOf> weeksOfMonth = [
    const DayOf(text: "week", subText: '01-07', left: 0.02, value: 0),
    const DayOf(text: "week", subText: '08-14', left: 0.1, value: 0),
    const DayOf(text: "week", subText: '15-21', left: 0.18, value: 0),
    const DayOf(text: "week", subText: '22-28', left: 0.26, value: 0),
  ];

  final List<DayOf> monthsOfYear = [
    const DayOf(text: "th1", left: 0.003, value: 0),
    const DayOf(text: "th2", left: (1 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th3", left: (2 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th4", left: (3 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th5", left: (4 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th6", left: (5 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th7", left: (6 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th8", left: (7 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th9", left: (8 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th10", left: (9 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th11", left: (10 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th12", left: (11 * 0.0485) + 0.003, value: 0),
  ];

  List<Rx<NavItem>> get navBar => _navBar;
  int get indexActive => _indexActive.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint("Init Report Controller");
    currentDate = DateTime.now();
    getReadingHistoryByYear(isSave: true);
    getReadingHistory(isSave: true);
  }

  Future<void> onChooseFeature(int index) async {
    await LibFunction.effectConfirmPop();
    if (index == _indexActive.value) return;
    _indexActive.value = index;
    final int activeIndex =
        navBar.indexWhere((element) => element.value.isActive == true);
    _navBar[activeIndex](
      navBar[activeIndex].value.copyWith(isActive: false),
    );
    _navBar[index](
      navBar[index].value.copyWith(isActive: true),
    );
    currentDate = DateTime.now();

    resetData();
    getReadingHistory(isSave: true);
  }

  void resetData() {
    maxY = 0;
    totalReaded.value = 0;
    averageTime.value = 0;
    totalTime.value = 0;
    List.generate(
        7,
        (index) => daysOfWeek[index] =
            daysOfWeek[index].copyWith(value: 0, isHighlight: false));
    List.generate(
        4,
        (index) => weeksOfMonth[index] =
            weeksOfMonth[index].copyWith(value: 0, isHighlight: false));
    List.generate(
        12,
        (index) => monthsOfYear[index] =
            monthsOfYear[index].copyWith(value: 0, isHighlight: false));
  }

  Future<void> onChangeDay({required TypeFunc type}) async {
    await LibFunction.effectConfirmPop();
    if (!_networkService.networkConnection.value) return;
    resetData();
    final int activeIndex =
        navBar.indexWhere((element) => element.value.isActive == true);
    switch (type) {
      case TypeFunc.prev:
        switch (activeIndex) {
          case 0:
            currentDate = currentDate.subtract(const Duration(days: 7));
            break;
          case 1:
            currentDate = DateTime(
              currentDate.year,
              currentDate.month - 1,
              currentDate.day,
            );
            break;
          case 2:
            currentDate = DateTime(
              currentDate.year - 1,
              currentDate.month,
              currentDate.day,
            );
            break;
        }
        break;
      case TypeFunc.next:
        switch (activeIndex) {
          case 0:
            currentDate = currentDate.add(const Duration(days: 7));
            break;
          case 1:
            currentDate = DateTime(
              currentDate.year,
              currentDate.month + 1,
              currentDate.day,
            );
            break;
          case 2:
            currentDate = DateTime(
              currentDate.year + 1,
              currentDate.month,
              currentDate.day,
            );
            break;
        }
        break;
    }

    getReadingHistory(isSave: false);
  }

  Future<void> getReadingHistory({required bool isSave}) async {
    try {
      isLoading.value = true;
      isShowThis.value = false;
      final int activeIndex =
          navBar.indexWhere((element) => element.value.isActive == true);
      switch (activeIndex) {
        case 0:
          await getReadingHistoryByWeek(isSave: isSave);
          break;
        case 1:
          await getReadingHistoryByMonth(isSave: isSave);
          break;
        case 2:
          await getReadingHistoryByYear(isSave: isSave);
          break;
      }
    } catch (e) {
      //
    }
    isLoading.value = false;
  }

  Future<void> getReadingHistoryByWeek({required bool isSave}) async {
    isLoading.value = true;
    try {
      // this week
      final DateTime now = DateTime.now();

      final int dayOfWeek = currentDate.weekday;
      final DateTime firstDayOfCurrentWeek =
          currentDate.subtract(Duration(days: dayOfWeek - 1));
      final DateTime lastDayOfCurrentWeek =
          firstDayOfCurrentWeek.add(const Duration(days: 6));
      timeSub.value =
          DateFormat('dd/MM/yyyy').format(firstDayOfCurrentWeek).toString();
      timeSub.value +=
          "-${DateFormat('dd/MM/yyyy').format(lastDayOfCurrentWeek).toString()}";
      try {
        late List<History> dataWeek = [];
        if (_networkService.networkConnection.value) {
          dataWeek = await _userService.getReadingHistory(
            _userService.currentUser.userId,
            DateFormat('yyyy-MM-dd')
                .format(firstDayOfCurrentWeek)
                .toString(),
            DateFormat('yyyy-MM-dd')
                .format(lastDayOfCurrentWeek)
                .toString(),
          );
        } else {
          dataWeek = LibFunction.getHistoryFromStorage(KeySharedPreferences.timeYear);
        }
        if ("${((currentDate.difference(DateTime(now.year, 1, 1)).inDays + 1) / 7).ceil() + 1}" ==
            "${((now.difference(DateTime(now.year, 1, 1)).inDays + 1) / 7).ceil() + 1}") {
          isShowThis.value = true;
        }
        daysOfWeek.asMap().forEach((index, value) {
          for (final History history in dataWeek) {
            final DateTime date = LibFunction.parseDate(history.date);
            if (index == LibFunction.getIndexDayInWeek(date)) {
              final List<String> arr = history.duration.split(":");
              final double duration = arr.isNotEmpty ? double.parse(arr[0]) : 0;
              if (daysOfWeek[index].value + duration > maxY) {
                maxY = daysOfWeek[index].value + duration;
              }
              daysOfWeek[index] = daysOfWeek[index].copyWith(
                value: daysOfWeek[index].value + duration,
                isHighlight: history.date == DateFormat('dd/MM/yyyy').format(now).toString(),
              );
            }
          }
        });
        totalReaded.value = getTotalReaded(dataWeek);
        totalTime.value = sumTime(dataWeek);
        final int totalDayReaded = getDayReaded(dataWeek);
        averageTime.value = totalDayReaded != 0 ? totalTime.value / totalDayReaded : 0;
      } catch (e) {
        print("-----ERROR-----");
        print(e);
        print("-------");
      }
    } catch (e) {
      print("-----ERROR-----");
      print(e);
      print("-------");
    }

    isLoading.value = false;
  }

  Future<void> getReadingHistoryByMonth({required bool isSave}) async {
    try {
      isLoading.value = true;
      final DateTime now = DateTime.now();

      // this month
      final DateTime firstDayOfMonth =
          DateTime.utc(currentDate.year, currentDate.month, 1);
      final int daysInMonth =
          DateTime.utc(currentDate.year, currentDate.month + 1, 0).day;
      final DateTime lastDayOfMonth =
          firstDayOfMonth.add(Duration(days: daysInMonth - 1));

      timeSub.value = DateFormat('MM/yyyy').format(firstDayOfMonth).toString();
      DateTime startDateOfYear = DateTime(currentDate.year, 1, 1);
      try {
        late List<History> dataMonth = [];
        if (_networkService.networkConnection.value) {
          dataMonth = await _userService.getReadingHistory(
            _userService.currentUser.userId,
            DateFormat('yyyy-MM-dd').format(firstDayOfMonth).toString(),
            DateFormat('yyyy-MM-dd').format(lastDayOfMonth).toString(),
          );
        } else {
          dataMonth = LibFunction.getHistoryFromStorage(KeySharedPreferences.timeYear);
        }
        totalReaded.value = getTotalReaded(dataMonth);
        final Map<String, double> thisWeeklyData = {};
        List.generate( 4, (index) =>
          thisWeeklyData["${index}"] = 0
        );

        for (final History history in dataMonth) {
          final DateTime date = LibFunction.parseDate(history.date);
          final int currentWeek = LibFunction.getWeekNumberForDate(date, weeksOfMonth);
          final List<String> arr = history.duration.split(":");
          final double duration = arr.isNotEmpty ? double.parse(arr[0]) : 0;

          if(currentWeek < weeksOfMonth.length){
            thisWeeklyData[currentWeek.toString()] = thisWeeklyData[currentWeek.toString()]! + duration;
          } else {
            final MapEntry<String, dynamic> lastEntry =
                thisWeeklyData.entries.last;
            final String lastKey = lastEntry.key;
            thisWeeklyData[lastKey] = thisWeeklyData[lastKey]! + duration;
          }
        }

        final sortedKeysWeek = thisWeeklyData.keys.toList()..sort();
        final sortedMapWeek = {
          for (var k in sortedKeysWeek) k: thisWeeklyData[k]
        };
        List<MapEntry<String, dynamic>> list = sortedMapWeek.entries.toList();

        int nowWeek = LibFunction.getWeekNumberForDate(DateTime.now(), weeksOfMonth);
        weeksOfMonth.asMap().forEach((index, value) {
          final double val = double.parse(list[index].value.toString());
          if (val > maxY) {
            maxY = val;
          }

          weeksOfMonth[index] = weeksOfMonth[index].copyWith(
            subText: index == weeksOfMonth.length - 1
                ? '22-${DateFormat('dd').format(lastDayOfMonth)}'
                : weeksOfMonth[index].subText,
            isHighlight: index == nowWeek || nowWeek == weeksOfMonth.length,
            value: val,
          );
        });

        if (currentDate.month == now.month) {
          isShowThis.value = true;
        }
        totalReaded.value = getTotalReaded(dataMonth);
        totalTime.value = sumTime(dataMonth);
        final int totalDayReaded = getDayReaded(dataMonth);
        averageTime.value =
            totalDayReaded != 0 ? totalTime.value / totalDayReaded : 0;
      } catch (e) {
        print("-----ERROR-----");
        print(e);
        print("-------");
      }
    } catch (e) {
      print("-----ERROR-----");
      print(e);
      print("-------");
    }

    isLoading.value = false;
  }

  Future<void> getReadingHistoryByYear({required bool isSave}) async {
    try {
      isLoading.value = true;
      final DateTime now = DateTime.now();

      // this year
      final startOfYear = DateTime(currentDate.year, 1, 1);
      final endOfYear = DateTime(currentDate.year, 12, 31);
      timeTitle.value = DateFormat('yyyy').format(startOfYear).toString();
      timeSub.value = "";
      try {
        late List<History> dataYear = [];
        if (_networkService.networkConnection.value) {
          dataYear = await _userService.getReadingHistory(
            _userService.currentUser.userId,
            DateFormat('yyyy-MM-dd').format(startOfYear).toString(),
            DateFormat('yyyy-MM-dd').format(endOfYear).toString(),
          );
          if (isSave) {
            LibFunction.saveHistoryStorage(
                KeySharedPreferences.timeYear, dataYear);
          }
        } else {
          dataYear = LibFunction.getHistoryFromStorage(
            KeySharedPreferences.timeYear,
          );
        }
        totalReaded.value = getTotalReaded(dataYear);

        monthsOfYear.asMap().forEach((index, value) {
          final double sum = sumTimeByMonth(dataYear, index + 1);
          if (sum > maxY) {
            maxY = sum.toDouble();
          }
          if (now.month == index + 1) {
            isShowThis.value = true;
          }
          monthsOfYear[index] = monthsOfYear[index].copyWith(
            value: sum,
            isHighlight: now.month == index + 1 ? true : false,
          );
        });
        maxY += 10;
        totalReaded.value = getTotalReaded(dataYear);
        totalTime.value = sumTime(dataYear);
        final int totalDayReaded = getDayReaded(dataYear);
        averageTime.value =
            totalDayReaded != 0 ? totalTime.value / totalDayReaded : 0;
      } catch (e) {
        //
      }
    } catch (e) {
      //
    }

    isLoading.value = false;
  }

  // Lọc các phần tử trong danh sách theo tháng và tính tổng giá trị
  double sumTimeByMonth(List<History> data, int month) {
    return data
        .where((item) => LibFunction.parseDate(item.date).month == month)
        .fold(0, (result, item) {
      final List<String> arr = item.duration.split(":");
      final double duration = arr.isNotEmpty ? double.parse(arr[0]) : 0;
      result += duration;
      return result;
    });
  }

  double sumTime(List<History> data) {
    return data.fold(0, (result, item) {
      final List<String> arr = item.duration.split(":");
      final double duration = arr.isNotEmpty ? double.parse(arr[0]) : 0;
      result += duration;
      return result;
    });
  }

  int getTotalReaded(List<History> data) {
    final dataUniq = HashSet<History>(
      // or LinkedHashSet
      equals: (a, b) => a.readingId == b.readingId,
      hashCode: (a) => a.readingTopic.hashCode,
    )..addAll(data);
    return dataUniq.length;
  }

  int getDayReaded(List<History> data) {
    final dataUniq = HashSet<History>(
      // or LinkedHashSet
      equals: (a, b) => a.date == b.date,
      hashCode: (a) => a.date.hashCode,
    )..addAll(data);
    return dataUniq.length;
  }
}
