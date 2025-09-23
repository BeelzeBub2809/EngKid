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
                  case GameState.loading:
                    return _buildLoadingScreen(context, controller);

                  case GameState.playing:
                    return _buildGamePlay(context, controller);

                  case GameState.finished:
                    return _buildGameComplete(context, controller);

                  default:
                    return _buildLoadingScreen(context, controller);
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
                        if (controller.errorMessage.isEmpty) ...[
                          // Loading state
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
                            'Loading Memory Game',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(context, 20),
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          SizedBox(height: _getResponsiveSize(context, 12)),
                          Text(
                            'Fetching words from server...',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(context, 16),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          // Error state
                          Container(
                            padding: EdgeInsets.all(
                                _getResponsivePadding(context, 16)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.red.shade100,
                                  Colors.red.shade50,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red.shade600,
                              size: _getResponsiveIconSize(context, 32),
                            ),
                          ),
                          SizedBox(height: _getResponsiveSize(context, 24)),
                          Text(
                            'Failed to Load Game',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(context, 20),
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          SizedBox(height: _getResponsiveSize(context, 12)),
                          Text(
                            controller.errorMessage,
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(context, 14),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: _getResponsiveSize(context, 20)),
                          _buildRetryButton(context, controller),
                        ],
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

  Widget _buildRetryButton(
      BuildContext context, MemoryGameController controller) {
    return Container(
      width: double.infinity,
      height: _getResponsiveSize(context, 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade500,
            Colors.blue.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 16)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_getResponsiveSize(context, 16)),
          onTap: controller.resetGame,
          splashColor: Colors.white.withOpacity(0.3),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: _getResponsiveIconSize(context, 20),
                ),
                SizedBox(width: _getResponsiveSize(context, 8)),
                Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
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
                    _buildGoNextButton(context, controller),
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
              _buildCompactInfoItem(context, 'Words',
                  '${controller.words.length}', Icons.image_rounded),
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
                      ? _buildCardContent(
                          card, index, controller, context, fontSize, iconSize)
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

    // Determine based on number of cards and screen size
    final cardCount = controller.cards.length;

    if (isPortrait) {
      // Portrait orientation
      if (cardCount <= 12) {
        return 3; // 3x4 grid for small games
      } else if (cardCount <= 16) {
        return 4; // 4x4 grid for medium games
      } else {
        return 4; // 4x6 grid for large games
      }
    } else {
      // Landscape orientation - fallback
      if (cardCount <= 12) {
        return 4; // 4x3 grid
      } else if (cardCount <= 16) {
        return 4; // 4x4 grid
      } else {
        return 6; // 6x4 grid
      }
    }
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
          _buildStatRow(context, 'Words Used', '${controller.words.length}',
              Icons.abc_rounded),
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

  Widget _buildGoNextButton(
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
          onTap: () {
            // Navigate back to reading space
            Get.back();
          },
          splashColor: Colors.white.withOpacity(0.3),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: _getResponsivePadding(context, 16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: _getResponsiveIconSize(context, 28),
                ),
                SizedBox(width: _getResponsiveSize(context, 8)),
                Text(
                  'Continue',
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

  Widget _buildCardContent(
      MemoryCard card,
      int index,
      MemoryGameController controller,
      BuildContext context,
      double fontSize,
      double iconSize) {
    if (card.type == CardType.word) {
      // Word card: Show word text + pronunciation button
      return Column(
        key: ValueKey('word_content_$index'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Word text
          Text(
            card.content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 0.45,
              fontWeight: FontWeight.bold,
              color: card.isMatched
                  ? Colors.green.shade800
                  : Colors.indigo.shade700,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Pronunciation button
          GestureDetector(
            onTap: () => controller.playPronunciation(card.word),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: card.isMatched
                    ? Colors.green.shade100
                    : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: card.isMatched
                        ? Colors.green.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.volume_up_rounded,
                size: iconSize * 0.6,
                color: card.isMatched
                    ? Colors.green.shade700
                    : Colors.blue.shade700,
              ),
            ),
          ),
        ],
      );
    } else {
      // Image card: Show word image covering the entire box
      return Container(
        key: ValueKey('image_content_$index'),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: card.isMatched
                  ? Colors.green.withOpacity(0.2)
                  : Colors.purple.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: card.image.isNotEmpty
              ? Image.network(
                  card.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: card.isMatched
                            ? Colors.green.shade50
                            : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: card.isMatched
                              ? Colors.green.shade600
                              : Colors.purple.shade600,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: card.isMatched
                            ? Colors.green.shade50
                            : Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: iconSize * 0.8,
                            color: card.isMatched
                                ? Colors.green.shade400
                                : Colors.purple.shade400,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Image\nUnavailable',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize * 0.25,
                              color: card.isMatched
                                  ? Colors.green.shade600
                                  : Colors.purple.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    color: card.isMatched
                        ? Colors.green.shade50
                        : Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: iconSize * 0.8,
                        color: card.isMatched
                            ? Colors.green.shade400
                            : Colors.purple.shade400,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No Image',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize * 0.25,
                          color: card.isMatched
                              ? Colors.green.shade600
                              : Colors.purple.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }
  }
}
