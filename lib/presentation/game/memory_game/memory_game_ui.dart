import 'package:EngKid/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'memory_game_controller.dart';

class MemoryGameUI extends StatelessWidget {
  const MemoryGameUI({super.key});

  // Helper method to calculate responsive sizes
  double _getResponsiveSize(BuildContext context, double baseSize,
      {double minSize = 0, double maxSize = double.infinity}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Prioritize portrait orientation (height > width)
    final isPortrait = screenHeight > screenWidth;
    final referenceSize = isPortrait ? screenHeight : screenWidth;
    final baseReference =
        isPortrait ? 667 : 375; // iPhone 6/7/8 portrait height vs SE width

    final scaleFactor = referenceSize / baseReference;
    final responsiveSize = baseSize * scaleFactor;
    return responsiveSize.clamp(minSize, maxSize);
  }

  double _getResponsivePadding(BuildContext context, double basePadding) {
    return _getResponsiveSize(context, basePadding,
        minSize: basePadding * 0.6, maxSize: basePadding * 1.2);
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    return _getResponsiveSize(context, baseFontSize,
        minSize: baseFontSize * 0.7, maxSize: baseFontSize * 1.1);
  }

  double _getResponsiveIconSize(BuildContext context, double baseIconSize) {
    return _getResponsiveSize(context, baseIconSize,
        minSize: baseIconSize * 0.7, maxSize: baseIconSize * 1.2);
  }

  @override
  Widget build(BuildContext context) {
    // Force portrait orientation when entering memory game
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetBuilder<MemoryGameController>(
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          // Restore normal orientation when exiting memory game
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          return true; // Allow pop
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImage.backgroundBlue),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Obx(() {
                // Handle different game states
                switch (controller.gameState) {
                  case GameState.setup:
                    return _buildGameSetup(context, controller);

                  case GameState.loading:
                    return _buildLoadingScreen(context, controller);

                  case GameState.playing:
                    return _buildGamePlay(context, controller);

                  case GameState.finished:
                    return _buildGameComplete(context, controller);

                  default:
                    return _buildGameSetup(context, controller);
                }
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(
      BuildContext context, MemoryGameController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_getResponsivePadding(context, 24.0)),
      child: Column(
        children: [
          _buildHeader(context, controller),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(_getResponsivePadding(context, 20)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.95),
                          Colors.blue.shade50.withOpacity(0.9),
                          Colors.white.withOpacity(0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                          _getResponsiveSize(context, 25)),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: _getResponsiveSize(context, 15),
                          offset: Offset(0, _getResponsiveSize(context, 8)),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              _getResponsivePadding(context, 16)),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade100,
                                Colors.indigo.shade100,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.shade600,
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                        SizedBox(height: _getResponsiveSize(context, 24)),
                        Text(
                          'Preparing Your Game',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: _getResponsiveSize(context, 12)),
                        Text(
                          controller.isLoadingWords
                              ? 'Loading words and pronunciations...'
                              : 'Setting up your memory challenge...',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 16),
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: _getResponsiveSize(context, 16)),
                        Container(
                          padding: EdgeInsets.all(
                              _getResponsivePadding(context, 12)),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(
                                _getResponsiveSize(context, 12)),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Colors.blue.shade600,
                                size: _getResponsiveIconSize(context, 18),
                              ),
                              SizedBox(width: _getResponsiveSize(context, 8)),
                              Text(
                                'Difficulty: ${controller.selectedDifficultyString}',
                                style: TextStyle(
                                  fontSize: _getResponsiveFontSize(context, 14),
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSetup(
      BuildContext context, MemoryGameController controller) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(_getResponsivePadding(context, 24.0)),
          child: Column(
            children: [
              _buildHeader(context, controller),
              SizedBox(height: _getResponsiveSize(context, 40)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.95),
                      Colors.blue.shade50.withOpacity(0.9),
                      Colors.indigo.shade50.withOpacity(0.9),
                      Colors.white.withOpacity(0.95),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(_getResponsiveSize(context, 25)),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: _getResponsiveSize(context, 15),
                      offset: Offset(0, _getResponsiveSize(context, 8)),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: _getResponsiveSize(context, 6),
                      offset: const Offset(-3, -3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(_getResponsivePadding(context, 28)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: _getResponsivePadding(context, 12),
                        horizontal: _getResponsivePadding(context, 24),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.blue.shade100,
                            Colors.indigo.shade100,
                            Colors.purple.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                            _getResponsiveSize(context, 20)),
                        border:
                            Border.all(color: Colors.blue.shade300, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.psychology_rounded,
                            color: Colors.indigo.shade700,
                            size: _getResponsiveIconSize(context, 32),
                          ),
                          SizedBox(width: _getResponsiveSize(context, 12)),
                          Text(
                            'Memory Card Game',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo.shade800,
                              fontSize: _getResponsiveFontSize(context, 16),
                              shadows: [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _getResponsiveSize(context, 30)),
                    _buildDifficultySelector(context, controller),
                    SizedBox(height: _getResponsiveSize(context, 40)),
                    _buildStartButton(context, controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGamePlay(BuildContext context, MemoryGameController controller) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(_getResponsivePadding(context, 16.0)),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            _buildHeader(context, controller),
            SizedBox(height: _getResponsiveSize(context, 16)),
            // Combined game info and cards in one container
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.blue.shade50.withOpacity(0.9),
                    Colors.white.withOpacity(0.95),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(_getResponsiveSize(context, 16)),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: _getResponsiveSize(context, 8),
                    offset: Offset(0, _getResponsiveSize(context, 4)),
                    spreadRadius: 0.5,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.6),
                    blurRadius: _getResponsiveSize(context, 3),
                    offset: Offset(-1, -1),
                  ),
                ],
              ),
              padding: EdgeInsets.all(_getResponsivePadding(context, 16)),
              child: Column(
                children: [
                  // Compact game info in one row
                  _buildCompactGameInfo(context, controller),
                  SizedBox(height: _getResponsiveSize(context, 12)),
                  // Card grid
                  _buildCardGrid(context, controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameComplete(
      BuildContext context, MemoryGameController controller) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(_getResponsivePadding(context, 16.0)),
          child: Column(
            children: [
              _buildHeader(context, controller),
              SizedBox(height: _getResponsiveSize(context, 24)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.blue.shade50,
                      Colors.purple.shade50,
                      Colors.white,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(_getResponsiveSize(context, 25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: _getResponsiveSize(context, 20),
                      offset: Offset(0, _getResponsiveSize(context, 8)),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: _getResponsiveSize(context, 6),
                      offset: Offset(-3, -3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(_getResponsivePadding(context, 20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.all(_getResponsivePadding(context, 12)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.amber.shade200,
                            Colors.yellow.shade100,
                            Colors.amber.shade300,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: _getResponsiveIconSize(context, 40),
                        color: Colors.amber.shade700,
                      ),
                    ),
                    SizedBox(height: _getResponsiveSize(context, 16)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: _getResponsivePadding(context, 8),
                        horizontal: _getResponsivePadding(context, 16),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.purple.shade100,
                            Colors.indigo.shade100,
                            Colors.blue.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                            _getResponsiveSize(context, 16)),
                        border:
                            Border.all(color: Colors.blue.shade200, width: 2),
                      ),
                      child: Text(
                        '🎉 Congratulations! 🎉',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade800,
                          fontSize: _getResponsiveFontSize(context, 18),
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _getResponsiveSize(context, 12)),
                    Text(
                      'You completed the memory game!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 14),
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: _getResponsiveSize(context, 16)),
                    _buildFinalStats(context, controller),
                    SizedBox(height: _getResponsiveSize(context, 20)),
                    _buildPlayAgainButton(context, controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MemoryGameController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _getResponsivePadding(context, 16),
          vertical: _getResponsivePadding(context, 12)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.15),
            blurRadius: _getResponsiveSize(context, 8),
            offset: Offset(0, _getResponsiveSize(context, 3)),
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: _getResponsiveSize(context, 3),
            offset: Offset(-1, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.all(_getResponsivePadding(context, 8)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade200,
                    Colors.blue.shade100,
                    Colors.blue.shade50,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(_getResponsiveSize(context, 12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.blue.shade700,
                size: _getResponsiveIconSize(context, 18),
              ),
            ),
          ),
          SizedBox(width: _getResponsiveSize(context, 12)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: _getResponsivePadding(context, 6),
                horizontal: _getResponsivePadding(context, 12),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.indigo.shade50,
                    Colors.blue.shade50,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(_getResponsiveSize(context, 10)),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.psychology_rounded,
                    color: Colors.blue.shade700,
                    size: _getResponsiveIconSize(context, 20),
                  ),
                  SizedBox(width: _getResponsiveSize(context, 6)),
                  Text(
                    'Memory Game',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: _getResponsiveSize(context, 12)),
          if (controller.gameInProgress)
            GestureDetector(
              onTap: controller.pauseGame,
              child: Container(
                padding: EdgeInsets.all(_getResponsivePadding(context, 8)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.shade200,
                      Colors.orange.shade100,
                      Colors.orange.shade50,
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(_getResponsiveSize(context, 12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.pause_rounded,
                  color: Colors.orange.shade700,
                  size: _getResponsiveIconSize(context, 18),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context, MemoryGameController controller) {
    return Container(
      padding: EdgeInsets.all(_getResponsivePadding(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: _getResponsiveSize(context, 8),
            offset: Offset(0, _getResponsiveSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(context, 'Round', '${controller.round}'),
              _buildInfoItem(context, 'Score', '${controller.score}'),
              _buildInfoItem(context, 'Pairs', '${controller.matchedPairs}'),
            ],
          ),
          SizedBox(height: _getResponsiveSize(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                  context, 'Level', controller.selectedDifficultyString),
              _buildInfoItem(context, 'Time', '${controller.gameTime}s'),
            ],
          ),
          SizedBox(height: _getResponsiveSize(context, 16)),
          LinearProgressIndicator(
            value: controller.cards.isEmpty
                ? 0.0
                : controller.matchedPairs / (controller.cards.length / 2),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 18),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: _getResponsiveSize(context, 4)),
        Text(
          label,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 12),
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactGameInfo(
      BuildContext context, MemoryGameController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: _getResponsivePadding(context, 12),
          horizontal: _getResponsivePadding(context, 16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
            Colors.blue.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 12)),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 3,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          // First row with main stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCompactInfoItem(
                  context, 'Score', '${controller.score}', Icons.star_rounded),
              _buildCompactInfoItem(
                  context,
                  'Pairs',
                  '${controller.matchedPairs}/${controller.cards.length ~/ 2}',
                  Icons.extension_rounded),
              _buildCompactInfoItem(context, 'Time', '${controller.gameTime}s',
                  Icons.timer_rounded),
              _buildCompactInfoItem(
                  context,
                  'Level',
                  controller.selectedDifficultyString,
                  Icons.trending_up_rounded),
            ],
          ),
          SizedBox(height: _getResponsiveSize(context, 12)),
          // Enhanced Progress bar
          Container(
            height: _getResponsiveSize(context, 6),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(_getResponsiveSize(context, 3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(_getResponsiveSize(context, 3)),
              child: LinearProgressIndicator(
                value: controller.cards.isEmpty
                    ? 0.0
                    : controller.matchedPairs / (controller.cards.length / 2),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  controller.matchedPairs == controller.cards.length / 2
                      ? Colors.green.shade500
                      : Colors.blue.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoItem(
      BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _getResponsivePadding(context, 6),
          horizontal: _getResponsivePadding(context, 3),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(_getResponsivePadding(context, 4)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade100,
                    Colors.blue.shade50,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(_getResponsiveSize(context, 6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.15),
                    blurRadius: 2,
                    offset: const Offset(0, 1.5),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: _getResponsiveIconSize(context, 14),
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: _getResponsiveSize(context, 4)),
            Text(
              value,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 12),
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
                shadows: [
                  Shadow(
                    offset: const Offset(0.5, 0.5),
                    blurRadius: 1,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            SizedBox(height: _getResponsiveSize(context, 2)),
            Text(
              label,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 9),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySelector(
      BuildContext context, MemoryGameController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: _getResponsivePadding(context, 16),
            vertical: _getResponsivePadding(context, 8),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.indigo.shade50,
                Colors.blue.shade50,
              ],
            ),
            borderRadius:
                BorderRadius.circular(_getResponsiveSize(context, 12)),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color: Colors.indigo.shade600,
                size: _getResponsiveIconSize(context, 20),
              ),
              SizedBox(width: _getResponsiveSize(context, 8)),
              Text(
                'Difficulty Level',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                  shadows: [
                    Shadow(
                      offset: const Offset(0.5, 0.5),
                      blurRadius: 1,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: _getResponsiveSize(context, 20)),
        Row(
          children: MemoryDifficulty.values.map((difficulty) {
            final isSelected = controller.selectedDifficulty == difficulty;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.setDifficulty(difficulty),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  margin: EdgeInsets.symmetric(
                      horizontal: _getResponsiveSize(context, 8)),
                  padding: EdgeInsets.symmetric(
                      vertical: _getResponsivePadding(context, 12)),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade500,
                              Colors.indigo.shade600,
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey.shade100,
                              Colors.grey.shade50,
                              Colors.white,
                            ],
                          ),
                    borderRadius:
                        BorderRadius.circular(_getResponsiveSize(context, 16)),
                    border: Border.all(
                      color: isSelected
                          ? Colors.blue.shade700
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.4)
                            : Colors.grey.withOpacity(0.2),
                        blurRadius: isSelected ? 8 : 4,
                        offset: Offset(0, isSelected ? 4 : 2),
                        spreadRadius: isSelected ? 1 : 0,
                      ),
                      if (isSelected)
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 2,
                          offset: const Offset(-1, -1),
                        ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getDifficultyIcon(difficulty),
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        size: _getResponsiveIconSize(context, 24),
                      ),
                      SizedBox(height: _getResponsiveSize(context, 8)),
                      Text(
                        difficulty.name.capitalize!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: _getResponsiveFontSize(context, 16),
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: _getResponsiveSize(context, 16)),
        Container(
          padding: EdgeInsets.all(_getResponsivePadding(context, 12)),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius:
                BorderRadius.circular(_getResponsiveSize(context, 12)),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.blue.shade600,
                size: _getResponsiveIconSize(context, 18),
              ),
              SizedBox(width: _getResponsiveSize(context, 8)),
              Expanded(
                child: Text(
                  _getDifficultyDescription(controller),
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 14),
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getDifficultyIcon(MemoryDifficulty difficulty) {
    switch (difficulty) {
      case MemoryDifficulty.easy:
        return Icons.sentiment_satisfied_rounded;
      case MemoryDifficulty.medium:
        return Icons.sentiment_neutral_rounded;
      case MemoryDifficulty.hard:
        return Icons.sentiment_very_dissatisfied_rounded;
    }
  }

  String _getDifficultyDescription(MemoryGameController controller) {
    switch (controller.selectedDifficulty) {
      case MemoryDifficulty.easy:
        return '12 cards (6 pairs) • 3 minutes';
      case MemoryDifficulty.medium:
        return '16 cards (8 pairs) • 2.5 minutes';
      case MemoryDifficulty.hard:
        return '24 cards (12 pairs) • 2 minutes';
    }
  }

  Widget _buildStartButton(
      BuildContext context, MemoryGameController controller) {
    return Container(
      width: double.infinity,
      height: _getResponsiveSize(context, 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400,
            Colors.green.shade500,
            Colors.green.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 20)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_getResponsiveSize(context, 20)),
          onTap: controller.startGame,
          splashColor: Colors.white.withOpacity(0.3),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _getResponsivePadding(context, 16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: _getResponsiveIconSize(context, 28),
                ),
                SizedBox(width: _getResponsiveSize(context, 8)),
                Text(
                  'Start Game',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardGrid(BuildContext context, MemoryGameController controller) {
    final cardsPerRow = _getCardsPerRow(controller, context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenHeight > screenWidth;

    // Calculate responsive spacing based on screen orientation and size
    final cardSpacing = isPortrait
        ? (screenHeight > 700 ? 8.0 : (screenHeight * 0.012).clamp(4.0, 8.0))
        : (screenWidth > 600 ? 8.0 : (screenWidth * 0.015).clamp(4.0, 8.0));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cardsPerRow,
        crossAxisSpacing: cardSpacing,
        mainAxisSpacing: cardSpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: controller.cards.length,
      itemBuilder: (context, index) {
        final card = controller.cards[index];
        return _buildCompactMemoryCard(card, index, controller, context);
      },
    );
  }

  Widget _buildCompactMemoryCard(MemoryCard card, int index,
      MemoryGameController controller, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenHeight > screenWidth;

    // Calculate responsive sizes based on screen orientation and size
    final borderRadius = isPortrait
        ? (screenHeight > 700 ? 16.0 : (screenHeight * 0.024).clamp(8.0, 16.0))
        : (screenWidth > 600 ? 16.0 : (screenWidth * 0.027).clamp(8.0, 16.0));

    final borderWidth = isPortrait
        ? (screenHeight > 700 ? 3.0 : (screenHeight * 0.004).clamp(2.0, 3.0))
        : (screenWidth > 600 ? 3.0 : (screenWidth * 0.005).clamp(2.0, 3.0));

    final fontSize = isPortrait
        ? (screenHeight > 700 ? 28.0 : (screenHeight * 0.042).clamp(16.0, 28.0))
        : (screenWidth > 600 ? 28.0 : (screenWidth * 0.047).clamp(16.0, 28.0));

    final iconSize = isPortrait
        ? (screenHeight > 700 ? 36.0 : (screenHeight * 0.054).clamp(20.0, 36.0))
        : (screenWidth > 600 ? 36.0 : (screenWidth * 0.06).clamp(20.0, 36.0));

    final blurRadius = isPortrait
        ? (screenHeight > 700 ? 8.0 : 4.0)
        : (screenWidth > 600 ? 8.0 : 4.0);

    return GestureDetector(
      onTap: () => controller.flipCard(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutBack,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(card.isFlipped || card.isMatched ? 0 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: card.isMatched
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade200,
                    Colors.green.shade100,
                    Colors.green.shade50,
                  ],
                )
              : card.isFlipped
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                        Colors.white,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.indigo.shade400,
                        Colors.indigo.shade300,
                        Colors.indigo.shade200,
                      ],
                    ),
          border: Border.all(
            color: card.isMatched
                ? Colors.green.shade400
                : card.isFlipped
                    ? Colors.indigo.shade300
                    : Colors.indigo.shade600,
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: card.isMatched
                  ? Colors.green.withOpacity(0.3)
                  : card.isFlipped
                      ? Colors.indigo.withOpacity(0.2)
                      : Colors.indigo.withOpacity(0.4),
              blurRadius: blurRadius,
              offset: const Offset(0, 3),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () => controller.flipCard(index),
            splashColor: card.isMatched
                ? Colors.green.withOpacity(0.3)
                : Colors.indigo.withOpacity(0.3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: card.isFlipped || card.isMatched
                      ? Column(
                          key: ValueKey('content_$index'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Show only the content (word or phonetic)
                            Text(
                              card.content,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontSize * 0.45,
                                fontWeight: FontWeight.bold,
                                fontStyle: card.type == CardType.phonetic
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                color: card.isMatched
                                    ? Colors.green.shade800
                                    : (card.type == CardType.word
                                        ? Colors.indigo.shade700
                                        : Colors.purple.shade700),
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () =>
                                  controller.playPronunciation(card.word),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: card.isMatched
                                      ? Colors.green.shade100
                                      : (card.type == CardType.word
                                          ? Colors.blue.shade100
                                          : Colors.purple.shade100),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  size: iconSize * 0.5,
                                  color: card.isMatched
                                      ? Colors.green.shade700
                                      : (card.type == CardType.word
                                          ? Colors.blue.shade700
                                          : Colors.purple.shade700),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          key: ValueKey('back_$index'),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(borderRadius - 4),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.help_outline_rounded,
                            size: iconSize,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getCardsPerRow(MemoryGameController controller, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = screenHeight > screenWidth;

    if (isPortrait) {
      // Portrait orientation - optimize for vertical screens
      if (screenHeight < 600) {
        // Small portrait screens
        switch (controller.selectedDifficulty) {
          case MemoryDifficulty.easy:
            return 3; // 3x4 grid for 12 cards
          case MemoryDifficulty.medium:
            return 4; // 4x4 grid for 16 cards
          case MemoryDifficulty.hard:
            return 4; // 4x6 grid for 24 cards
        }
      } else if (screenHeight < 800) {
        // Medium portrait screens
        switch (controller.selectedDifficulty) {
          case MemoryDifficulty.easy:
            return 3; // 3x4 grid for 12 cards
          case MemoryDifficulty.medium:
            return 4; // 4x4 grid for 16 cards
          case MemoryDifficulty.hard:
            return 4; // 4x6 grid for 24 cards
        }
      } else {
        // Large portrait screens (tall phones, tablets)
        switch (controller.selectedDifficulty) {
          case MemoryDifficulty.easy:
            return 4; // 4x3 grid for 12 cards
          case MemoryDifficulty.medium:
            return 4; // 4x4 grid for 16 cards
          case MemoryDifficulty.hard:
            return 4; // 4x6 grid for 24 cards
        }
      }
    } else {
      // Landscape orientation - fallback for horizontal screens
      if (screenWidth < 600) {
        switch (controller.selectedDifficulty) {
          case MemoryDifficulty.easy:
            return 4; // 4x3 grid for 12 cards
          case MemoryDifficulty.medium:
            return 4; // 4x4 grid for 16 cards
          case MemoryDifficulty.hard:
            return 6; // 6x4 grid for 24 cards
        }
      } else {
        // Large landscape screens
        switch (controller.selectedDifficulty) {
          case MemoryDifficulty.easy:
            return 4; // 4x3 grid for 12 cards
          case MemoryDifficulty.medium:
            return 6; // 6x3 or 8x2 grid for 16 cards
          case MemoryDifficulty.hard:
            return 6; // 6x4 grid for 24 cards
        }
      }
    }
  }

  Widget _buildMemoryCard(MemoryCard card, int index,
      MemoryGameController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => controller.flipCard(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_getResponsiveSize(context, 12)),
          color: card.isMatched
              ? Colors.green.shade100
              : card.isFlipped
                  ? Colors.white
                  : Colors.blue.shade300,
          border: Border.all(
            color: card.isMatched
                ? Colors.green.shade400
                : card.isFlipped
                    ? Colors.blue.shade400
                    : Colors.blue.shade500,
            width: _getResponsiveSize(context, 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: _getResponsiveSize(context, 4),
              offset: Offset(0, _getResponsiveSize(context, 2)),
            ),
          ],
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Text(
                  card.content,
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 24),
                  ),
                )
              : Icon(
                  Icons.help_outline,
                  size: _getResponsiveIconSize(context, 32),
                  color: Colors.white,
                ),
        ),
      ),
    );
  }

  Widget _buildFinalStats(
      BuildContext context, MemoryGameController controller) {
    return Container(
      padding: EdgeInsets.all(_getResponsivePadding(context, 16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 16)),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 3,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: _getResponsivePadding(context, 8),
              horizontal: _getResponsivePadding(context, 12),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.amber.shade100,
                  Colors.yellow.shade50,
                  Colors.amber.shade100,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(_getResponsiveSize(context, 12)),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber.shade700,
                  size: _getResponsiveIconSize(context, 18),
                ),
                SizedBox(width: _getResponsiveSize(context, 6)),
                Text(
                  'Game Statistics',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 14),
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _getResponsiveSize(context, 12)),
          _buildStatRow(context, 'Final Score', '${controller.score}',
              Icons.star_rounded),
          SizedBox(height: _getResponsiveSize(context, 8)),
          _buildStatRow(context, 'Total Attempts', '${controller.attempts}',
              Icons.touch_app_rounded),
          SizedBox(height: _getResponsiveSize(context, 8)),
          _buildStatRow(context, 'Matched Pairs', '${controller.matchedPairs}',
              Icons.extension_rounded),
          SizedBox(height: _getResponsiveSize(context, 8)),
          _buildStatRow(context, 'Difficulty',
              controller.selectedDifficultyString, Icons.trending_up_rounded),
        ],
      ),
    );
  }

  Widget _buildStatRow(
      BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _getResponsivePadding(context, 6),
        horizontal: _getResponsivePadding(context, 12),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 12)),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_getResponsivePadding(context, 6)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade100,
                  Colors.blue.shade50,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(_getResponsiveSize(context, 6)),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: _getResponsiveIconSize(context, 16),
            ),
          ),
          SizedBox(width: _getResponsiveSize(context, 8)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 13),
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: _getResponsivePadding(context, 4),
              horizontal: _getResponsivePadding(context, 8),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.indigo.shade100,
                  Colors.indigo.shade50,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(_getResponsiveSize(context, 6)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 13),
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayAgainButton(
      BuildContext context, MemoryGameController controller) {
    return Container(
      width: double.infinity,
      height: _getResponsiveSize(context, 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade400,
            Colors.purple.shade500,
            Colors.indigo.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 20)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_getResponsiveSize(context, 20)),
          onTap: controller.resetGame,
          splashColor: Colors.white.withOpacity(0.3),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _getResponsivePadding(context, 16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: _getResponsiveIconSize(context, 28),
                ),
                SizedBox(width: _getResponsiveSize(context, 8)),
                Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
