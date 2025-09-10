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
  late double total = 0;
  late double totalThisWeek = 0;
  late double totalLastWeek = 0;
  late double maxYThisWeek = 0;
  late double maxYLastWeek = 0;

  final List<DayOf> daysOfThisWeek = [
    const DayOf(text: "t2", left: 0.02, value: 0),
    const DayOf(text: "t3", left: 0.1, value: 0),
    const DayOf(text: "t4", left: 0.18, value: 0),
    const DayOf(text: "t5", left: 0.26, value: 0),
    const DayOf(text: "t6", left: 0.34, value: 0),
    const DayOf(text: "t7", left: 0.42, value: 0),
    const DayOf(text: "cn", left: 0.5, value: 0),
  ];

  final List<DayOf> daysOfLastWeek = [
    const DayOf(text: "t2", left: 0.02, value: 0),
    const DayOf(text: "t3", left: 0.1, value: 0),
    const DayOf(text: "t4", left: 0.18, value: 0),
    const DayOf(text: "t5", left: 0.26, value: 0),
    const DayOf(text: "t6", left: 0.34, value: 0),
    const DayOf(text: "t7", left: 0.42, value: 0),
    const DayOf(text: "cn", left: 0.5, value: 0),
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
        thisWeek = await starBoardUseCases.getStarsHistory(
          studentId: _userService.currentUser.id,
          startDate:
              DateFormat('yyyy-MM-dd').format(firstDayOfCurrentWeek).toString(),
          endDate:
              DateFormat('yyyy-MM-dd').format(lastDayOfCurrentWeek).toString(),
        );

        daysOfThisWeek.asMap().forEach((index, value) {
          for (final History history in thisWeek) {
            final DateTime date = LibFunction.parseDate(history.date);
            final String weekOfCurrentDate =
                "${((firstDayOfCurrentWeek.difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil() + 1}";
            final String weekOfHistoryDate =
                "${((LibFunction.parseDate(history.date).difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil() + 1}";
            if (index == LibFunction.getIndexDayInWeek(date) &&
                weekOfCurrentDate == weekOfHistoryDate) {
              total += history.star;

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
                "${((lastWeekStart.difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil() + 1}";
            final String weekOfHistoryDate =
                "${((LibFunction.parseDate(history.date).difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil() + 1}";
            if (index == LibFunction.getIndexDayInWeek(date) &&
                weekOfCurrentDate == weekOfHistoryDate) {
              total += history.star;
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

      // Tính maxY cho tuần hiện tại từ các giá trị ngày thực tế
      maxYThisWeek = 0;
      for (final day in daysOfThisWeek) {
        if (day.value > maxYThisWeek) {
          maxYThisWeek = day.value;
        }
      }

      // Tính maxY cho tuần trước từ các giá trị ngày thực tế
      maxYLastWeek = 0;
      for (final day in daysOfLastWeek) {
        if (day.value > maxYLastWeek) {
          maxYLastWeek = day.value;
        }
      }

      // Đảm bảo maxY ít nhất là 1 để tránh chia cho 0
      if (maxYThisWeek == 0) maxYThisWeek = 1;
      if (maxYLastWeek == 0) maxYLastWeek = 1;
    } catch (e) {
      //
    }
    isLoading.value = false;
  }
}
