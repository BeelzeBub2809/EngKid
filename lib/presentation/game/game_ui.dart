import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/game/game_controller.dart';
import 'package:EngKid/utils/app_route.dart';

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
        // Game content
        GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset(
            LocalImage.backButton,
            width: 80,
            height: 80,
          ),
        ),
        Center(
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.7,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GAMES',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(width: 40), // Balance the layout
                    ],
                  ),
                ),
                // Games grid
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      children: [
                        // Wordle Game
                        _buildGameCard(
                          context,
                          'WORDLE',
                          Icons.grid_3x3,
                          Colors.green,
                          () => Get.toNamed(AppRoute.wordleGame,
                              arguments: [true, false]),
                        ),
                        // Puzzle Game
                        _buildGameCard(
                          context,
                          'PUZZLE',
                          Icons.extension,
                          Colors.blue,
                          () => Get.toNamed(AppRoute.puzzleGame,
                              arguments: [true, false]),
                        ),
                        _buildGameCard(
                          context,
                          'MEMORY',
                          Icons.psychology,
                          Colors.purple,
                          () => Get.toNamed(AppRoute.memoryGame,
                              arguments: [true, false]),
                        ),
                        _buildGameCard(
                          context,
                          'MISSING WORD',
                          Icons.abc,
                          Colors.green,
                          () => Get.toNamed(AppRoute.missingWordGame),
                        ),
                        // Image Puzzle Game - NEW
                        _buildGameCard(
                          context,
                          'IMAGE PUZZLE',
                          Icons.photo_library,
                          Colors.orange,
                          () => Get.toNamed(AppRoute.imagePuzzleGame),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 2),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
