import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:EngKid/domain/reading/reading_usecases.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:oktoast/oktoast.dart';

class LeaderBoardController extends GetxController {
  final ReadingUsecases readingUsecases;

  LeaderBoardController({required this.readingUsecases});

  final UserService _userService = Get.find<UserService>();
  final RxList<LeaderBoardStudent> _leaderBoard = <LeaderBoardStudent>[].obs;
  final RxBool _isLoading = true.obs;
  final Rx<LeaderBoardStudent?> _currentUser = Rx<LeaderBoardStudent?>(null);
  final RxInt _totalStudents = 0.obs;

  List<LeaderBoardStudent> get leaderBoard => _leaderBoard;
  bool get isLoading => _isLoading.value;
  LeaderBoardStudent? get currentUser => _currentUser.value;
  int get totalStudents => _totalStudents.value;

  List<LeaderBoardStudent> get topThree => _leaderBoard.take(3).toList();
  List<LeaderBoardStudent> get nextFive => _leaderBoard.skip(3).toList();

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _loadLeaderBoardData();
  }

  void _loadLeaderBoardData() async {
    _isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        'kid_student_id': _userService.currentUser.id,
      };

      final dynamic response = await readingUsecases.getLeaderboard(body);

      if (response != null && response is Map<String, dynamic>) {
        final List<dynamic> topStudents = response['top_10_students'] ?? [];
        _leaderBoard.value = topStudents.map((studentData) {
          final studentInfo = studentData['student_info'];
          return LeaderBoardStudent(
            id: studentInfo['id'].toString(),
            name: studentInfo['name'] ?? '',
            avatar: studentInfo['image'] ?? '',
            totalStars:
                double.tryParse(studentData['total_star']?.toString() ?? '0')
                        ?.toInt() ??
                    0,
            rank: studentData['rank'] ?? 0,
            readingCount: studentData['reading_count'] ?? 0,
            totalScore: studentData['total_score'] ?? 0,
            gender: studentInfo['gender'] ?? '',
            dob: studentInfo['dob'] ?? '',
            gradeId: studentInfo['grade_id'] ?? 0,
          );
        }).toList();

        // Parse current student
        final currentStudentData = response['current_student'];
        if (currentStudentData != null) {
          final currentStudentInfo = currentStudentData['student_info'];
          _currentUser.value = LeaderBoardStudent(
            id: currentStudentInfo['id'].toString(),
            name: currentStudentInfo['name'] ?? '',
            avatar: currentStudentInfo['image'] ?? '',
            totalStars: double.tryParse(
                        currentStudentData['total_star']?.toString() ?? '0')
                    ?.toInt() ??
                0,
            rank: currentStudentData['rank'] ?? 0,
            readingCount: currentStudentData['reading_count'] ?? 0,
            totalScore: currentStudentData['total_score'] ?? 0,
            gender: currentStudentInfo['gender'] ?? '',
            dob: currentStudentInfo['dob'] ?? '',
            gradeId: currentStudentInfo['grade_id'] ?? 0,
          );
        }

        _totalStudents.value = response['total_students'] ?? 0;
      } else {
        _leaderBoard.value = [];
        _currentUser.value = null;
        _totalStudents.value = 0;
        showToast('Không thể tải dữ liệu bảng xếp hạng');
      }
    } catch (e) {
      // API call failed
      _leaderBoard.value = [];
      _currentUser.value = null;
      _totalStudents.value = 0;
      showToast('Lỗi khi tải dữ liệu bảng xếp hạng');
    } finally {
      _isLoading.value = false;
    }
  }

  void refreshLeaderBoard() {
    _loadLeaderBoardData();
  }

  @override
  void onClose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.onClose();
  }
}

class LeaderBoardStudent {
  final String id;
  final String name;
  final String avatar;
  final int totalStars;
  final int rank;
  final int readingCount;
  final int totalScore;
  final String gender;
  final String dob;
  final int gradeId;

  LeaderBoardStudent({
    required this.id,
    required this.name,
    required this.avatar,
    required this.totalStars,
    required this.rank,
    this.readingCount = 0,
    this.totalScore = 0,
    this.gender = '',
    this.dob = '',
    this.gradeId = 0,
  });
}
