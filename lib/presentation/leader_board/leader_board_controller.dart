import 'package:get/get.dart';
import 'package:flutter/services.dart';

class LeaderBoardController extends GetxController {
  final RxList<LeaderBoardStudent> _leaderBoard = <LeaderBoardStudent>[].obs;
  final RxBool _isLoading = true.obs;
  final Rx<LeaderBoardStudent?> _currentUser = Rx<LeaderBoardStudent?>(null);

  List<LeaderBoardStudent> get leaderBoard => _leaderBoard;
  bool get isLoading => _isLoading.value;
  LeaderBoardStudent? get currentUser => _currentUser.value;

  List<LeaderBoardStudent> get topThree => _leaderBoard.take(3).toList();
  List<LeaderBoardStudent> get nextFive =>
      _leaderBoard.skip(3).take(5).toList();

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _loadLeaderBoardData();
  }

  void _loadLeaderBoardData() {
    _isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      _leaderBoard.value = [
        LeaderBoardStudent(
          id: '1',
          name: 'Nguyễn Minh An',
          avatar: 'https://via.placeholder.com/100x100.png?text=AN',
          totalStars: 985,
          rank: 1,
        ),
        LeaderBoardStudent(
          id: '2',
          name: 'Trần Thị Bảo',
          avatar: 'https://via.placeholder.com/100x100.png?text=BAO',
          totalStars: 867,
          rank: 2,
        ),
        LeaderBoardStudent(
          id: '3',
          name: 'Lê Văn Cường',
          avatar: 'https://via.placeholder.com/100x100.png?text=CUONG',
          totalStars: 745,
          rank: 3,
        ),
        LeaderBoardStudent(
          id: '4',
          name: 'Phạm Thị Dung',
          avatar: 'https://via.placeholder.com/100x100.png?text=DUNG',
          totalStars: 698,
          rank: 4,
        ),
        LeaderBoardStudent(
          id: '5',
          name: 'Hoàng Văn Em',
          avatar: 'https://via.placeholder.com/100x100.png?text=EM',
          totalStars: 632,
          rank: 5,
        ),
        LeaderBoardStudent(
          id: '6',
          name: 'Đỗ Thị Phương',
          avatar: 'https://via.placeholder.com/100x100.png?text=PHUONG',
          totalStars: 589,
          rank: 6,
        ),
        LeaderBoardStudent(
          id: '7',
          name: 'Vũ Văn Giang',
          avatar: 'https://via.placeholder.com/100x100.png?text=GIANG',
          totalStars: 534,
          rank: 7,
        ),
        LeaderBoardStudent(
          id: '8',
          name: 'Bùi Thị Hoa',
          avatar: 'https://via.placeholder.com/100x100.png?text=HOA',
          totalStars: 467,
          rank: 8,
        ),
        LeaderBoardStudent(
          id: '9',
          name: 'Ngô Văn Ích',
          avatar: 'https://via.placeholder.com/100x100.png?text=ICH',
          totalStars: 423,
          rank: 9,
        ),
        LeaderBoardStudent(
          id: '10',
          name: 'Đinh Thị Kim',
          avatar: 'https://via.placeholder.com/100x100.png?text=KIM',
          totalStars: 398,
          rank: 10,
        ),
      ];
      _currentUser.value = LeaderBoardStudent(
        id: '11',
        name: 'Bạn',
        avatar: 'https://via.placeholder.com/100x100.png?text=YOU',
        totalStars: 245,
        rank: 15,
      );
      _isLoading.value = false;
    });
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

  LeaderBoardStudent({
    required this.id,
    required this.name,
    required this.avatar,
    required this.totalStars,
    required this.rank,
  });
}
