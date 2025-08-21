import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/leader_board/leader_board_controller.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/text/regular_text.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';

class LeaderBoardScreen extends GetView<LeaderBoardController> {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LocalImage.backgroundBlue),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(size),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColor.primary,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: size.height * 0.03,
                    ),
                    child: Column(
                      children: [
                        _buildTitle(size),
                        SizedBox(height: size.height * 0.02),
                        Obx(() => controller.isLoading
                            ? const Expanded(
                                child: Center(child: LoadingDialog()))
                            : Expanded(
                                child: Column(
                                  children: [
                                    _buildPodium(size),
                                    SizedBox(height: size.height * 0.02),
                                    _buildOtherRankingsTitle(size),
                                    SizedBox(height: size.height * 0.01),
                                    Expanded(
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: controller.nextFive.length,
                                        itemBuilder: (context, index) {
                                          final student =
                                              controller.nextFive[index];
                                          return _buildSimpleRankingItem(
                                              size, student);
                                        },
                                      ),
                                    ),
                                    _buildSeparator(size),
                                    Obx(() => _buildCurrentUserRank(size)),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.015,
      ),
      child: Row(
        children: [
          ImageButton(
            pathImage: LocalImage.buttonClose,
            width: size.width * 0.12,
            height: size.width * 0.12,
            onTap: () => Get.back(),
          ),
          Expanded(
            child: Center(
              child: RegularText(
                'Bảng xếp hạng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Fontsize.larger,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.12),
        ],
      ),
    );
  }

  Widget _buildTitle(Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                LocalImage.star,
                width: size.width * 0.08,
                height: size.width * 0.08,
              ),
              SizedBox(width: size.width * 0.03),
              Flexible(
                child: RegularText(
                  'TOP HỌC SINH',
                  style: TextStyle(
                    color: AppColor.yellow,
                    fontSize: Fontsize.normal,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Image.asset(
                LocalImage.star,
                width: size.width * 0.08,
                height: size.width * 0.08,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.005),
          RegularText(
            'CÓ SỐ SAO CAO NHẤT',
            style: TextStyle(
              color: AppColor.yellow,
              fontSize: Fontsize.normal,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderBoardList(Size size) {
    return ListView.builder(
      itemCount: controller.leaderBoard.length,
      itemBuilder: (context, index) {
        final student = controller.leaderBoard[index];
        return _buildLeaderBoardItem(size, student, index);
      },
    );
  }

  Widget _buildLeaderBoardItem(
      Size size, LeaderBoardStudent student, int index) {
    Color rankColor = _getRankColor(student.rank);
    Color backgroundColor = index % 2 == 0
        ? Colors.white.withOpacity(0.9)
        : AppColor.lightYellow.withOpacity(0.9);

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: student.rank <= 3
            ? Border.all(color: rankColor, width: 2)
            : Border.all(color: AppColor.gray.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildRankIndicator(size, student.rank, rankColor),
          SizedBox(width: size.width * 0.02),
          _buildAvatarSection(size, student),
          SizedBox(width: size.width * 0.02),
          Expanded(
            flex: 2,
            child: _buildStudentInfo(size, student),
          ),
          SizedBox(width: size.width * 0.01),
          _buildStarsSection(size, student),
        ],
      ),
    );
  }

  Widget _buildRankIndicator(Size size, int rank, Color rankColor) {
    if (rank <= 3) {
      return Container(
        width: size.width * 0.1,
        height: size.width * 0.1,
        decoration: BoxDecoration(
          color: rankColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            rank.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Fontsize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: size.width * 0.1,
        height: size.width * 0.1,
        decoration: BoxDecoration(
          color: AppColor.gray,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            rank.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Fontsize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAvatarSection(Size size, LeaderBoardStudent student) {
    return Container(
      width: size.width * 0.12,
      height: size.width * 0.12,
      decoration: BoxDecoration(
        color: const Color(0XFFfdf1ce),
        shape: BoxShape.circle,
        border: Border.all(
          color: _getRankColor(student.rank),
          width: student.rank <= 3 ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size.width * 0.06),
        child: CacheImage(
          url: student.avatar,
          width: size.width * 0.12,
          height: size.width * 0.12,
        ),
      ),
    );
  }

  Widget _buildStudentInfo(Size size, LeaderBoardStudent student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: RegularText(
            student.name,
            style: TextStyle(
              color: AppColor.textDefault,
              fontSize: Fontsize.small,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        SizedBox(height: size.height * 0.003),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RegularText(
              'Hạng ',
              style: TextStyle(
                color: AppColor.gray,
                fontSize: Fontsize.smallest,
              ),
            ),
            RegularText(
              '#${student.rank}',
              style: TextStyle(
                color: _getRankColor(student.rank),
                fontSize: Fontsize.smallest,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStarsSection(Size size, LeaderBoardStudent student) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.02,
        vertical: size.height * 0.008,
      ),
      decoration: BoxDecoration(
        color: AppColor.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.yellow, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            LocalImage.star,
            width: size.width * 0.04,
            height: size.width * 0.04,
          ),
          SizedBox(width: size.width * 0.01),
          RegularText(
            student.totalStars.toString(),
            style: TextStyle(
              color: AppColor.yellow,
              fontSize: Fontsize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColor.gray;
    }
  }

  Widget _buildPodium(Size size) {
    final topThree = controller.topThree;
    if (topThree.length < 3) return const SizedBox();

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumPlace(size, topThree[1], 2, size.height * 0.07),
          _buildPodiumPlace(size, topThree[0], 1, size.height * 0.1),
          _buildPodiumPlace(size, topThree[2], 3, size.height * 0.04),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(
      Size size, LeaderBoardStudent student, int rank, double podiumHeight) {
    Color rankColor = _getRankColor(rank);
    String medal = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : '🥉';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          medal,
          style: TextStyle(fontSize: size.width * 0.06),
        ),
        SizedBox(height: size.height * 0.003),
        Container(
          width: size.width * 0.1,
          height: size.width * 0.1,
          decoration: BoxDecoration(
            color: const Color(0XFFfdf1ce),
            shape: BoxShape.circle,
            border: Border.all(color: rankColor, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size.width * 0.05),
            child: CacheImage(
              url: student.avatar,
              width: size.width * 0.1,
              height: size.width * 0.1,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.003),
        SizedBox(
          width: size.width * 0.18,
          child: RegularText(
            student.name,
            style: TextStyle(
              color: AppColor.textDefault,
              fontSize: Fontsize.smallest,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        SizedBox(height: size.height * 0.003),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              LocalImage.star,
              width: size.width * 0.025,
              height: size.width * 0.025,
            ),
            SizedBox(width: size.width * 0.003),
            RegularText(
              student.totalStars.toString(),
              style: TextStyle(
                color: AppColor.yellow,
                fontSize: Fontsize.smallest,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.005),
        Container(
          width: size.width * 0.18,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: rankColor.withOpacity(0.8),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(color: rankColor, width: 2),
          ),
          child: Center(
            child: Text(
              rank.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: Fontsize.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherRankingsTitle(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: RegularText(
        'XẾP HẠNG KHÁC',
        style: TextStyle(
          color: AppColor.gray,
          fontSize: Fontsize.small,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSimpleRankingItem(Size size, LeaderBoardStudent student) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.gray.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: size.width * 0.08,
            height: size.width * 0.08,
            decoration: const BoxDecoration(
              color: AppColor.gray,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                student.rank.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Fontsize.smallest,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Container(
            width: size.width * 0.08,
            height: size.width * 0.08,
            decoration: const BoxDecoration(
              color: Color(0XFFfdf1ce),
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width * 0.04),
              child: CacheImage(
                url: student.avatar,
                width: size.width * 0.08,
                height: size.width * 0.08,
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: RegularText(
              student.name,
              style: TextStyle(
                color: AppColor.textDefault,
                fontSize: Fontsize.small,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                LocalImage.star,
                width: size.width * 0.03,
                height: size.width * 0.03,
              ),
              SizedBox(width: size.width * 0.01),
              RegularText(
                student.totalStars.toString(),
                style: TextStyle(
                  color: AppColor.yellow,
                  fontSize: Fontsize.small,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRank(Size size) {
    final currentUser = controller.currentUser;
    if (currentUser == null) return const SizedBox();

    return Container(
      margin: EdgeInsets.only(
        top: size.height * 0.02,
        bottom: size.height * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.primary, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: size.width * 0.08,
            height: size.width * 0.08,
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                currentUser.rank.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Fontsize.smallest,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Container(
            width: size.width * 0.08,
            height: size.width * 0.08,
            decoration: BoxDecoration(
              color: const Color(0XFFfdf1ce),
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.primary, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width * 0.04),
              child: CacheImage(
                url: currentUser.avatar,
                width: size.width * 0.08,
                height: size.width * 0.08,
              ),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: RegularText(
              currentUser.name,
              style: TextStyle(
                color: AppColor.primary,
                fontSize: Fontsize.small,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                LocalImage.star,
                width: size.width * 0.03,
                height: size.width * 0.03,
              ),
              SizedBox(width: size.width * 0.01),
              RegularText(
                currentUser.totalStars.toString(),
                style: TextStyle(
                  color: AppColor.yellow,
                  fontSize: Fontsize.small,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: AppColor.gray.withOpacity(0.3),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  child: Container(
                    width: size.width * 0.015,
                    height: size.width * 0.015,
                    decoration: BoxDecoration(
                      color: AppColor.gray.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: AppColor.gray.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
