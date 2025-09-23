import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/game/game_controller.dart';

class GameUI extends GetView<GameController> {
  const GameUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Background image
        Image.asset(
          LocalImage.backgroundBlue,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Back button
        Positioned(
          top: size.height * 0.05,
          left: size.width * 0.02,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(
              LocalImage.backButton,
              width: 80,
              height: 80,
            ),
          ),
        ),
        // Game content
        Center(
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.7,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
            child: Obx(() {
              if (controller.isLoading) {
                return _buildLoadingContent();
              } else if (controller.gameData != null) {
                return _buildGameInfoContent();
              } else {
                return _buildErrorContent();
              }
            }),
          ),
        )
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 20),
        Text(
          'Đang tải thông tin game...',
          style: TextStyle(
            fontSize: Fontsize.normal,
            color: Colors.blue.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildGameInfoContent() {
    final gameData = controller.gameData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gameData['game_title'] ?? 'Unknown Game',
                style: TextStyle(
                  fontSize: Fontsize.large,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Loại: ${gameData['game_type']?.toUpperCase() ?? 'Unknown'}',
                style: TextStyle(
                  fontSize: Fontsize.normal,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),

        // Game Info
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (gameData['game_description'] != null) ...[
                  Text(
                    'Mô tả:',
                    style: TextStyle(
                      fontSize: Fontsize.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gameData['game_description'],
                    style: TextStyle(
                      fontSize: Fontsize.small,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (gameData['instructions'] != null) ...[
                  Text(
                    'Hướng dẫn:',
                    style: TextStyle(
                      fontSize: Fontsize.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gameData['instructions'],
                    style: TextStyle(
                      fontSize: Fontsize.small,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Game stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGameStat(
                      'Độ khó',
                      '${gameData['difficulty_level'] ?? 1}',
                      Icons.star,
                      Colors.orange,
                    ),
                    _buildGameStat(
                      'Thời gian',
                      '${gameData['estimated_time'] ?? 0}s',
                      Icons.timer,
                      Colors.blue,
                    ),
                    _buildGameStat(
                      'Điểm tối đa',
                      '${gameData['max_score'] ?? 0}',
                      Icons.emoji_events,
                      Colors.green,
                    ),
                  ],
                ),

                const Spacer(),

                // Loading message
                Center(
                  child: Text(
                    'Đang chuyển hướng đến game...',
                    style: TextStyle(
                      fontSize: Fontsize.small,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 64,
          color: Colors.red.shade400,
        ),
        const SizedBox(height: 16),
        Text(
          'Không thể tải thông tin game',
          style: TextStyle(
            fontSize: Fontsize.normal,
            color: Colors.red.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Vui lòng thử lại sau',
          style: TextStyle(
            fontSize: Fontsize.small,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildGameStat(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: Fontsize.normal,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: Fontsize.smaller,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
