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

class WeekController extends GetxController {
  final StarBoardUseCases starBoardUseCases;
  WeekController({required this.starBoardUseCases});

  final UserService _userService = Get.find<UserService>();
  // final _preferencesManager = getIt.get<SharedPreferencesManager>();
  final NetworkService _networkService = Get.find<NetworkService>();

  late String curWeek = "04-10/08";
  late String preWeek = "28/07-03/08";
  late double total = 52.5;
  late double totalThisWeek = 28.5;
  late double totalLastWeek = 24.0;
  late double maxYThisWeek = 40.0;
  late double maxYLastWeek = 40.0;

  final List<DayOf> daysOfThisWeek = [
    const DayOf(text: "t2", left: 0.02, value: 12.0),
    const DayOf(text: "t3", left: 0.1, value: 10.0),
    const DayOf(text: "t4", left: 0.18, value: 20.0),
    const DayOf(text: "t5", left: 0.26, value: 15.0),
    const DayOf(text: "t6", left: 0.34, value: 40.0),
    const DayOf(text: "t7", left: 0.42, value: 22.0),
    const DayOf(text: "cn", left: 0.5, value: 24.0),
  ];

  final List<DayOf> daysOfLastWeek = [
    const DayOf(text: "t2", left: 0.02, value: 12.0),
    const DayOf(text: "t3", left: 0.1, value: 10.0),
    const DayOf(text: "t4", left: 0.18, value: 20.0),
    const DayOf(text: "t5", left: 0.26, value: 15.0),
    const DayOf(text: "t6", left: 0.34, value: 40.0),
    const DayOf(text: "t7", left: 0.42, value: 22.0),
    const DayOf(text: "cn", left: 0.5, value: 24.0),
  ];

  final RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint("Init Week Controller");
    await getStarsHistory();
  }

  Future<void> getStarsHistory() async {
    isLoading.value = true;
    try {
      // this week
      final DateTime now = DateTime.now();
      final int dayOfWeek = now.weekday;
      final DateTime firstDayOfCurrentWeek =
          now.subtract(Duration(days: dayOfWeek - 1));
      final DateTime lastDayOfCurrentWeek =
          firstDayOfCurrentWeek.add(const Duration(days: 6));
      curWeek = DateFormat('dd').format(firstDayOfCurrentWeek).toString();
      curWeek +=
          "-${DateFormat('dd/MM').format(lastDayOfCurrentWeek).toString()}";
      try {
        late List<History> thisWeek = [];
        if (_networkService.networkConnection.value) {
          thisWeek = await starBoardUseCases.getStarsHistory(
            studentId: _userService.currentUser.id,
            startDate: DateFormat('yyyy-MM-dd')
                .format(firstDayOfCurrentWeek)
                .toString(),
            endDate: DateFormat('yyyy-MM-dd')
                .format(lastDayOfCurrentWeek)
                .toString(),
          );
        } else {
          thisWeek = LibFunction.getHistoryFromStorage(
              KeySharedPreferences.starOfTwoYear);
        }

        daysOfThisWeek.asMap().forEach((index, value) {
          for (final History history in thisWeek) {
            final DateTime date = LibFunction.parseDate(history.date);
            final String weekOfCurrentDate =
                "${((firstDayOfCurrentWeek.difference(DateTime(now.year, 1, 1)).inDays + 1) / 7).ceil() + 1}";
            final String weekOfHistoryDate =
                "${((LibFunction.parseDate(history.date).difference(DateTime(now.year, 1, 1)).inDays + 1) / 7).ceil() + 1}";
            if (index == LibFunction.getIndexDayInWeek(date) &&
                weekOfCurrentDate == weekOfHistoryDate) {
              total += history.star;

              if (history.star > maxYThisWeek) {
                maxYThisWeek = history.star.toDouble();
              }
              var currentStar = daysOfThisWeek[index].value;

              daysOfThisWeek[index] = daysOfThisWeek[index].copyWith(
                value: currentStar + history.star,
                isHighlight: history.date ==
                        DateFormat('yyyy/MM/dd').format(now).toString()
                    ? true
                    : false,
              );
            }
          }
        });
        totalThisWeek = total;
      } catch (e) {
        //
      }

      // last week
      final DateTime lastWeekStart = now
          .subtract(const Duration(days: 7))
          .subtract(Duration(days: now.weekday - 1));
      final DateTime lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
      preWeek = DateFormat('dd').format(lastWeekStart).toString();
      preWeek += "-${DateFormat('dd/MM').format(lastWeekEnd).toString()}";
      try {
        late List<History> lastWeek = [];
        if (_networkService.networkConnection.value) {
          lastWeek = await starBoardUseCases.getStarsHistory(
            studentId: _userService.currentUser.id,
            startDate:
                DateFormat('yyyy-MM-dd').format(lastWeekStart).toString(),
            endDate: DateFormat('yyyy-MM-dd').format(lastWeekEnd).toString(),
          );
        } else {
          lastWeek = LibFunction.getHistoryFromStorage(
              KeySharedPreferences.starOfTwoYear);
        }
        daysOfLastWeek.asMap().forEach((index, value) {
          for (final History history in lastWeek) {
            final DateTime date = LibFunction.parseDate(history.date);
            final String weekOfCurrentDate =
                "${((lastWeekStart.difference(DateTime(now.year, 1, 1)).inDays + 1) / 7).ceil() + 1}";
            final String weekOfHistoryDate =
                "${((LibFunction.parseDate(history.date).difference(DateTime(now.year, 1, 1)).inDays + 1) / 7).ceil() + 1}";
            if (index == LibFunction.getIndexDayInWeek(date) &&
                weekOfCurrentDate == weekOfHistoryDate) {
              total += history.star;
              if (history.star > maxYLastWeek) {
                maxYLastWeek = history.star.toDouble();
              }
              var currentStar = daysOfLastWeek[index].value;

              daysOfLastWeek[index] = daysOfLastWeek[index].copyWith(
                value: currentStar + history.star,
              );
            }
          }
        });

        totalLastWeek = total - totalThisWeek;
      } catch (e) {
        //
      }
    } catch (e) {
      //
    }
    isLoading.value = false;
  }
}
