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

class YearController extends GetxController {
  final StarBoardUseCases starBoardUseCases;
  YearController({required this.starBoardUseCases});

  final UserService _userService = Get.find<UserService>();
  final NetworkService _networkService = Get.find<NetworkService>();

  late double total = 0;
  late double totalThisYear = 0;
  late double totalLastYear = 0;
  late String curYear = "2025";
  late String preYear = "2024";
  late double maxYThisYear = 148;
  late double maxYLastYear = 142;

  final List<DayOf> monthsOfThisYear = [
    const DayOf(text: "th1", left: 0.003, value: 85),
    const DayOf(text: "th2", left: (1 * 0.0485) + 0.003, value: 92),
    const DayOf(text: "th3", left: (2 * 0.0485) + 0.003, value: 88),
    const DayOf(text: "th4", left: (3 * 0.0485) + 0.003, value: 95),
    const DayOf(text: "th5", left: (4 * 0.0485) + 0.003, value: 103),
    const DayOf(text: "th6", left: (5 * 0.0485) + 0.003, value: 117),
    const DayOf(text: "th7", left: (6 * 0.0485) + 0.003, value: 134),
    const DayOf(
        text: "th8", left: (7 * 0.0485) + 0.003, value: 148, isHighlight: true),
    const DayOf(text: "th9", left: (8 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th10", left: (9 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th11", left: (10 * 0.0485) + 0.003, value: 0),
    const DayOf(text: "th12", left: (11 * 0.0485) + 0.003, value: 0),
  ];

  final List<DayOf> monthsOfLastYear = [
    const DayOf(text: "th1", left: 0.003, value: 76),
    const DayOf(text: "th2", left: (1 * 0.0485) + 0.003, value: 82),
    const DayOf(text: "th3", left: (2 * 0.0485) + 0.003, value: 79),
    const DayOf(text: "th4", left: (3 * 0.0485) + 0.003, value: 87),
    const DayOf(text: "th5", left: (4 * 0.0485) + 0.003, value: 94),
    const DayOf(text: "th6", left: (5 * 0.0485) + 0.003, value: 108),
    const DayOf(text: "th7", left: (6 * 0.0485) + 0.003, value: 125),
    const DayOf(text: "th8", left: (7 * 0.0485) + 0.003, value: 142),
    const DayOf(text: "th9", left: (8 * 0.0485) + 0.003, value: 138),
    const DayOf(text: "th10", left: (9 * 0.0485) + 0.003, value: 131),
    const DayOf(text: "th11", left: (10 * 0.0485) + 0.003, value: 115),
    const DayOf(text: "th12", left: (11 * 0.0485) + 0.003, value: 98),
  ];

  final RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    debugPrint("Init Year Controller");
    getStarsHistory();
  }

  Future<void> getStarsHistory() async {
    try {
      isLoading.value = true;

      // this year
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year, 12, 31);
      curYear = DateFormat('yyyy').format(startOfYear).toString();

      try {
        late List<History> thisYear = [];
        if (_networkService.networkConnection.value) {
          thisYear = await starBoardUseCases.getStarsHistory(
            studentId: _userService.currentUser.id,
            startDate: DateFormat('yyyy-MM-dd').format(startOfYear).toString(),
            endDate: DateFormat('yyyy-MM-dd').format(endOfYear).toString(),
          );
        } else {
          thisYear = LibFunction.getHistoryFromStorage(
            KeySharedPreferences.starOfTwoYear,
          );
        }
        monthsOfThisYear.asMap().forEach((index, value) {
          final double sum = sumByMonth(thisYear, index + 1, now.year);
          total += sum;
          if (sum > maxYThisYear) {
            maxYThisYear = sum.toDouble();
          }
          monthsOfThisYear[index] = monthsOfThisYear[index].copyWith(
            value: sum,
            isHighlight: now.month == index + 1 ? true : false,
          );
        });
        totalThisYear = total;
      } catch (e) {
        //
      }
      // last year
      final startOfLastYear = DateTime(now.year - 1, 1, 1);
      final endOfLastYear = DateTime(now.year - 1, 12, 31);
      preYear = DateFormat('yyyy').format(startOfLastYear).toString();
      try {
        late List<History> lastYear = [];
        if (_networkService.networkConnection.value) {
          lastYear = await starBoardUseCases.getStarsHistory(
            studentId: _userService.currentUser.id,
            startDate:
                DateFormat('yyyy-MM-dd').format(startOfLastYear).toString(),
            endDate: DateFormat('yyyy-MM-dd').format(endOfLastYear).toString(),
          );
        } else {
          LibFunction.getHistoryFromStorage(KeySharedPreferences.starOfTwoYear);
        }

        monthsOfLastYear.asMap().forEach((index, value) {
          final double sum = sumByMonth(lastYear, index + 1, now.year - 1);
          total += sum;
          if (sum > maxYLastYear) {
            maxYLastYear = sum;
          }
          monthsOfLastYear[index] =
              monthsOfLastYear[index].copyWith(value: sum);
        });
        totalLastYear = total - totalThisYear;
      } catch (e) {
        //
      }
    } catch (e) {
      //
    }
    isLoading.value = false;
  }

// Lọc các phần tử trong danh sách theo tháng và tính tổng giá trị
  double sumByMonth(List<History> data, int month, int year) {
    return data
        .where((item) =>
            LibFunction.parseDate(item.date).month == month &&
            LibFunction.parseDate(item.date).year == year)
        .fold(0, (result, item) {
      result += item.star;
      return result;
    });
  }
}
