import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../../../utils/images.dart';
import 'missing_word_controller.dart';

class MissingWordUI extends StatelessWidget {
  const MissingWordUI({super.key});

  static bool _isToastShowing = false;
  static bool _lastFeedbackState = false;

  double _getResponsiveSize(BuildContext context, double baseSize,
      {double minSize = 0, double maxSize = double.infinity}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isLandscape = screenWidth > screenHeight;
    final referenceSize = isLandscape ? screenWidth : screenHeight;
    final baseReference =
        isLandscape ? 1200 : 667; // Increased base reference for landscape

    final scaleFactor = referenceSize / baseReference;
    final responsiveSize = baseSize * scaleFactor;
    return responsiveSize.clamp(minSize, maxSize);
  }

  double _getResponsivePadding(BuildContext context, double basePadding) {
    return _getResponsiveSize(context, basePadding,
        minSize: basePadding * 0.5,
        maxSize: basePadding * 1.0); // Reduced max padding
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    return _getResponsiveSize(context, baseFontSize,
        minSize: baseFontSize * 0.6,
        maxSize: baseFontSize * 0.9); // Reduced font sizes
  }

  double _getResponsiveIconSize(BuildContext context, double baseIconSize) {
    return _getResponsiveSize(context, baseIconSize,
        minSize: baseIconSize * 0.6,
        maxSize: baseIconSize * 1.0); // Reduced icon sizes
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return GetBuilder<MissingWordController>(
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          return true;
        },
        child: OKToast(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.backgroundBlue),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Obx(() {
                  final controller = Get.find<MissingWordController>();
                  // Listen for feedback changes and show toast
                  if (controller.showFeedback &&
                      !_isToastShowing &&
                      !_lastFeedbackState) {
                    _isToastShowing = true;
                    _lastFeedbackState = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final message = _getFeedbackMessage(controller);
                      _showToast(context, message, controller.isCorrectAnswer);
                      // Reset flags after toast duration
                      Future.delayed(
                          Duration(
                              milliseconds: controller.isCorrectAnswer
                                  ? 1500
                                  : 2000), () {
                        _isToastShowing = false;
                      });
                    });
                  }

                  // Reset the last feedback state when showFeedback becomes false
                  if (!controller.showFeedback && _lastFeedbackState) {
                    _lastFeedbackState = false;
                  }

                  switch (controller.gameState) {
                    case MissingWordGameState.loading:
                      return _buildLoadingScreen(context, controller);
                    case MissingWordGameState.playing:
                      return _buildGamePlay(context, controller);
                    case MissingWordGameState.finished:
                      return _buildGameComplete(context, controller);
                    default:
                      return _buildLoadingScreen(context, controller);
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(
      BuildContext context, MissingWordController controller) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: _getResponsiveSize(context, 4),
          ),
          SizedBox(height: _getResponsiveSize(context, 20)),
          Text(
            'Preparing game...',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 18),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamePlay(
      BuildContext context, MissingWordController controller) {
    return Column(
      children: [
        // Row 1: Game Header and Stats (1/3 of screen)
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(_getResponsivePadding(context, 16)),
            child: Column(
              children: [
                _buildGameHeader(context, controller),
                SizedBox(height: _getResponsiveSize(context, 15)),
                Expanded(
                  child: _buildGameStats(context, controller),
                ),
              ],
            ),
          ),
        ),

        // Row 2: Game Content and Keyboard (2/3 of screen)
        Expanded(
          flex: 2,
          child: Row(
            children: [
              // Game content area (word display and input)
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(_getResponsivePadding(context, 16)),
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildWordDisplay(context, controller),
                      ),
                    ],
                  ),
                ),
              ),

              // Keyboard area
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(_getResponsivePadding(context, 16)),
                  child: Column(
                    children: [
                      _buildWordInput(context, controller),
                      SizedBox(height: _getResponsiveSize(context, 10)),
                      Expanded(
                        child: _buildKeyboard(context, controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameHeader(
      BuildContext context, MissingWordController controller) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: _getResponsiveIconSize(context, 40),
            height: _getResponsiveIconSize(context, 40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius:
                  BorderRadius.circular(_getResponsiveSize(context, 20)),
            ),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: _getResponsiveIconSize(context, 24),
            ),
          ),
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'Missing Word Game',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: _getResponsivePadding(context, 12),
            vertical: _getResponsivePadding(context, 6),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius:
                BorderRadius.circular(_getResponsiveSize(context, 15)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timer,
                color: Colors.orange,
                size: _getResponsiveIconSize(context, 16),
              ),
              SizedBox(width: _getResponsiveSize(context, 4)),
              Obx(() => Text(
                    Get.find<MissingWordController>().getTimeFormatted(),
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 14),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameStats(
      BuildContext context, MissingWordController controller) {
    return Column(children: [
      // XP Progress Bar
      GetBuilder<MissingWordController>(
        builder: (controller) {
          final progressValue = controller.getProgressValue();
          final currentWord = controller.getCurrentWordNumber();
          final totalWords = controller.getTotalWords();

          if (totalWords == 0) return const SizedBox.shrink();

          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: _getResponsiveSize(context, 12)),
            padding: EdgeInsets.all(_getResponsivePadding(context, 12)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius:
                  BorderRadius.circular(_getResponsiveSize(context, 10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: _getResponsiveSize(context, 4),
                  offset: Offset(0, _getResponsiveSize(context, 2)),
                ),
              ],
            ),
            child: Column(
              children: [
                // Progress text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Game Progress',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 12),
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    Text(
                      '$currentWord/$totalWords words (${(progressValue * 100).round()}%)',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 11),
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _getResponsiveSize(context, 8)),
                // Progress bar
                Stack(
                  children: [
                    Container(
                      height: _getResponsiveSize(context, 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(
                            _getResponsiveSize(context, 5)),
                      ),
                    ),
                    Container(
                      height: _getResponsiveSize(context, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            _getResponsiveSize(context, 5)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            _getResponsiveSize(context, 5)),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(progressValue),
                          ),
                        ),
                      ),
                    ),
                    // XP effect - sparkling animation
                    if (progressValue > 0)
                      Positioned(
                        right: _getResponsiveSize(context, 4),
                        top: _getResponsiveSize(context, 2),
                        child: Icon(
                          Icons.auto_awesome,
                          size: _getResponsiveIconSize(context, 8),
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildWordDisplay(
      BuildContext context, MissingWordController controller) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.all(_getResponsivePadding(context, 16)), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            _getResponsiveSize(context, 12)), // Reduced radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: _getResponsiveSize(context, 6), // Reduced shadow
            offset: Offset(0, _getResponsiveSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Complete the word:',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 14), // Reduced font
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                  width: _getResponsiveSize(context, 10)), // Reduced spacing
              GestureDetector(
                onTap: () => controller.playWordPronunciation(),
                child: Container(
                  padding: EdgeInsets.all(
                      _getResponsivePadding(context, 6)), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(
                        _getResponsiveSize(context, 15)), // Reduced radius
                  ),
                  child: Icon(
                    Icons.volume_up,
                    color: Colors.blue[700],
                    size: _getResponsiveIconSize(
                        context, 18), // Reduced icon size
                  ),
                ),
              ),
              SizedBox(width: _getResponsiveSize(context, 8)),
              GestureDetector(
                onTap: () => _showWordImagePopup(context, controller),
                child: Container(
                  padding: EdgeInsets.all(
                      _getResponsivePadding(context, 6)), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(
                        _getResponsiveSize(context, 15)), // Reduced radius
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.purple[700],
                    size: _getResponsiveIconSize(
                        context, 18), // Reduced icon size
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _getResponsiveSize(context, 5)), // Reduced spacing
          Obx(() => Text(
                Get.find<MissingWordController>().getDisplayWord(),
                style: TextStyle(
                  fontSize:
                      _getResponsiveFontSize(context, 36), // Reduced word font
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                  letterSpacing:
                      _getResponsiveSize(context, 6), // Reduced spacing
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              )),
          SizedBox(height: _getResponsiveSize(context, 8)), // Small spacing
          // Pronunciation display
          Obx(() {
            final controller = Get.find<MissingWordController>();
            final pronunciation = controller.currentWordPronunciation;
            if (pronunciation.isNotEmpty) {
              return Text(
                pronunciation,
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 20),
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              );
            }
            return const SizedBox.shrink();
          }),
          SizedBox(height: _getResponsiveSize(context, 8)), // Small spacing
          // Definition display with translation option
          // Obx(() {
          //   final controller = Get.find<MissingWordController>();
          //   final definition = controller.currentWordDefinition;
          //   if (definition.isNotEmpty) {
          //     return FutureBuilder<String>(
          //       future: controller.getTranslatedDefinitionText(),
          //       builder: (context, snapshot) {
          //         final displayText = snapshot.data ?? definition;
          //         return Container(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: _getResponsivePadding(context, 16),
          //             vertical: _getResponsivePadding(context, 8),
          //           ),
          //           margin: EdgeInsets.symmetric(
          //             horizontal: _getResponsivePadding(context, 20),
          //           ),
          //           decoration: BoxDecoration(
          //             color: controller.isTranslationEnabled
          //                 ? Colors.green[50]
          //                 : Colors.blue[50],
          //             borderRadius: BorderRadius.circular(8),
          //             border: Border.all(
          //               color: controller.isTranslationEnabled
          //                   ? Colors.green[200]!
          //                   : Colors.blue[200]!,
          //             ),
          //           ),
          //           child: Row(
          //             children: [
          //               // Translation toggle button
          //               GestureDetector(
          //                 onTap: () => controller.toggleTranslation(),
          //                 child: Container(
          //                   padding: EdgeInsets.all(
          //                     _getResponsivePadding(context, 4),
          //                   ),
          //                   decoration: BoxDecoration(
          //                     color: controller.isTranslationEnabled
          //                         ? Colors.green[100]
          //                         : Colors.blue[100],
          //                     borderRadius: BorderRadius.circular(6),
          //                   ),
          //                   child: Icon(
          //                     Icons.translate,
          //                     size: _getResponsiveIconSize(context, 14),
          //                     color: controller.isTranslationEnabled
          //                         ? Colors.green[700]
          //                         : Colors.blue[700],
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(width: _getResponsiveSize(context, 8)),
          //               // Definition text
          //               Expanded(
          //                 child: snapshot.connectionState ==
          //                         ConnectionState.waiting
          //                     ? Row(
          //                         children: [
          //                           SizedBox(
          //                             width: _getResponsiveSize(context, 12),
          //                             height: _getResponsiveSize(context, 12),
          //                             child: CircularProgressIndicator(
          //                               strokeWidth: 2,
          //                               valueColor:
          //                                   AlwaysStoppedAnimation<Color>(
          //                                 Colors.grey[600]!,
          //                               ),
          //                             ),
          //                           ),
          //                           SizedBox(
          //                               width: _getResponsiveSize(context, 8)),
          //                           Text(
          //                             'Translating...',
          //                             style: TextStyle(
          //                               fontSize:
          //                                   _getResponsiveFontSize(context, 12),
          //                               color: Colors.grey[600],
          //                               fontStyle: FontStyle.italic,
          //                             ),
          //                           ),
          //                         ],
          //                       )
          //                     : Text(
          //                         displayText,
          //                         style: TextStyle(
          //                           fontSize:
          //                               _getResponsiveFontSize(context, 20),
          //                           color: Colors.grey[700],
          //                           height: 1.3,
          //                         ),
          //                         textAlign: TextAlign.center,
          //                         maxLines: 3,
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   }
          //   return const SizedBox.shrink();
          // }),

          SizedBox(height: _getResponsiveSize(context, 15)), // Reduced spacing
          Text(
            'Missing ${controller.getMissingLetterCount()} letter(s)',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 15), // Reduced font
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordInput(
      BuildContext context, MissingWordController controller) {
    return GestureDetector(
      onTap: () => controller.showKeyboard(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsivePadding(context, 20),
          vertical: _getResponsivePadding(context, 15),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_getResponsiveSize(context, 10)),
          border: Border.all(
            color:
                controller.isKeyboardVisible ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: _getResponsiveSize(context, 4),
              offset: Offset(0, _getResponsiveSize(context, 2)),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.keyboard,
              color: Colors.grey[600],
              size: _getResponsiveIconSize(context, 20),
            ),
            SizedBox(width: _getResponsiveSize(context, 12)),
            Expanded(
              child: Obx(() {
                final controller = Get.find<MissingWordController>();
                return Text(
                  controller.userInput.isEmpty
                      ? 'Tap to enter missing letters...'
                      : controller.userInput.toUpperCase(),
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 18),
                    color: controller.userInput.isEmpty
                        ? Colors.grey[400]
                        : Colors.blue[700],
                    fontWeight: controller.userInput.isEmpty
                        ? FontWeight.normal
                        : FontWeight.bold,
                    letterSpacing: _getResponsiveSize(context, 2),
                  ),
                );
              }),
            ),
            Obx(() {
              final controller = Get.find<MissingWordController>();
              if (controller.userInput.length ==
                  controller.getMissingLetterCount()) {
                return GestureDetector(
                  onTap: () => controller.onKeyPressed('ENTER'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsivePadding(context, 12),
                      vertical: _getResponsivePadding(context, 6),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius:
                          BorderRadius.circular(_getResponsiveSize(context, 8)),
                    ),
                    child: Text(
                      'CHECK',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 12),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message, bool isSuccess) {
    showToast(
      message,
      duration: Duration(milliseconds: isSuccess ? 1500 : 2000),
      position: ToastPosition.top,
      backgroundColor: isSuccess
          ? Colors.green.withOpacity(0.9)
          : Colors.red.withOpacity(0.9),
      radius: _getResponsiveSize(context, 10),
      textStyle: TextStyle(
        fontSize: _getResponsiveFontSize(context, 36),
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      animationBuilder: (context, child, animationController, position) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animationController,
            curve: Curves.elasticOut,
          )),
          child: child,
        );
      },
    );
  }

  Widget _buildKeyboard(
      BuildContext context, MissingWordController controller) {
    const List<List<String>> keyboardLayout = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['BACKSPACE', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'ENTER'],
    ];

    return Container(
      padding:
          EdgeInsets.all(_getResponsivePadding(context, 12)), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(
            _getResponsiveSize(context, 12)), // Reduced radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: _getResponsiveSize(context, 6), // Reduced shadow
            offset: Offset(0, _getResponsiveSize(context, 3)),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: keyboardLayout
            .map((row) => _buildKeyboardRow(context, controller, row))
            .toList(),
      ),
    );
  }

  Widget _buildKeyboardRow(BuildContext context,
      MissingWordController controller, List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) => _buildKey(context, controller, key)).toList(),
    );
  }

  Widget _buildKey(
      BuildContext context, MissingWordController controller, String key) {
    final isSpecialKey = ['BACKSPACE', 'ENTER'].contains(key);
    final keyWidth = isSpecialKey
        ? _getResponsiveSize(context, 63) // Reduced special key width
        : _getResponsiveSize(context, 36); // Reduced normal key width
    final keyHeight = _getResponsiveSize(context, 36); // Reduced key height

    return Container(
      margin:
          EdgeInsets.all(_getResponsiveSize(context, 1.5)), // Reduced margin
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.canInputLetter
              ? () => controller.onKeyPressed(key)
              : null,
          borderRadius: BorderRadius.circular(
              _getResponsiveSize(context, 4)), // Reduced radius
          child: Container(
            width: keyWidth,
            height: keyHeight,
            decoration: BoxDecoration(
              color: _getKeyColor(key, controller),
              borderRadius: BorderRadius.circular(
                  _getResponsiveSize(context, 4)), // Reduced radius
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(1, 1),
                  blurRadius: 1, // Reduced shadow
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Center(
              child: _getKeyContent(context, key),
            ),
          ),
        ),
      ),
    );
  }

  Color _getKeyColor(String key, MissingWordController controller) {
    if (!controller.canInputLetter) {
      return Colors.grey[200]!;
    }

    switch (key) {
      case 'ENTER':
        return controller.userInput.length == controller.getMissingLetterCount()
            ? Colors.green[100]!
            : Colors.grey[200]!;
      case 'BACKSPACE':
        return Colors.red[100]!;
      default:
        return Colors.white;
    }
  }

  Widget _getKeyContent(BuildContext context, String key) {
    switch (key) {
      case 'BACKSPACE':
        return Icon(
          Icons.backspace_outlined,
          size: _getResponsiveIconSize(context, 14), // Reduced icon size
          color: Colors.red[700],
        );
      case 'ENTER':
        return Text(
          'CHECK',
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 8), // Reduced font size
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        );
      default:
        return Text(
          key,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 12), // Reduced font size
            fontWeight: FontWeight.bold,
            color: Colors.grey[700]!,
          ),
        );
    }
  }

  String _getFeedbackMessage(MissingWordController controller) {
    if (controller.isCorrectAnswer) {
      final points = ((10 +
                  (controller.currentLevel * 2) +
                  (controller.getMissingLetterCount() * 5)) *
              controller.bonusMultiplier)
          .round();
      return 'Excellent! Well done! +$points points';
    } else {
      // Check if this is from wrong key press or wrong complete answer
      if (controller.userInput.length < controller.getMissingLetterCount()) {
        return 'Wrong letter! -5 points. Streak reset.';
      } else {
        return 'Try again! The correct letters are: ${controller.currentWord!.missingLetters.join('').toUpperCase()}';
      }
    }
  }

  Widget _buildGameComplete(
      BuildContext context, MissingWordController controller) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(_getResponsivePadding(context, 20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Trophy and Title Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(_getResponsivePadding(context, 24)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(_getResponsiveSize(context, 16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: _getResponsiveSize(context, 8),
                    offset: Offset(0, _getResponsiveSize(context, 4)),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Game Results Title
                  Text(
                    'Game Results',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 32),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.emoji_events,
                    size: _getResponsiveIconSize(context, 80),
                    color: Colors.amber,
                  ),
                  SizedBox(height: _getResponsiveSize(context, 16)),
                  Text(
                    'Time\'s Up!',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 28),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: _getResponsiveSize(context, 8)),
                  Text(
                    'Great job completing the challenge!',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(context, 16),
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: _getResponsiveSize(context, 10)),

            // Stats Section
            _buildCompactGameSummary(context, controller),

            SizedBox(height: _getResponsiveSize(context, 10)),

            // Buttons Section
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: _getResponsivePadding(context, 16),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                              _getResponsiveSize(context, 12)),
                        ),
                        child: Center(
                          child: Text(
                            'Exit',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(context, 18),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: _getResponsiveSize(context, 16)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: _getResponsivePadding(context, 16),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[400]!, Colors.green[600]!],
                          ),
                          borderRadius: BorderRadius.circular(
                              _getResponsiveSize(context, 12)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: _getResponsiveIconSize(context, 20),
                              ),
                              SizedBox(width: _getResponsiveSize(context, 8)),
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: _getResponsiveFontSize(context, 18),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSummary(
      BuildContext context, MissingWordController controller) {
    return Container(
      padding: EdgeInsets.all(_getResponsivePadding(context, 24)),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(context, 'Final Score',
                  controller.score.toString(), Icons.star, Colors.amber),
              _buildSummaryItem(context, 'Levels Reached',
                  controller.currentLevel.toString(), Icons.flag, Colors.blue),
              _buildSummaryItem(
                  context,
                  'Best Streak',
                  controller.consecutiveCorrect.toString(),
                  Icons.trending_up,
                  Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactGameSummary(
      BuildContext context, MissingWordController controller) {
    return Container(
      padding:
          EdgeInsets.all(_getResponsivePadding(context, 12)), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(
            _getResponsiveSize(context, 10)), // Reduced radius
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCompactSummaryItem(context, 'Score',
                controller.score.toString(), Icons.star, Colors.amber),
          ),
          SizedBox(width: _getResponsiveSize(context, 8)), // Reduced spacing
          Expanded(
            child: _buildCompactSummaryItem(context, 'Level',
                controller.currentLevel.toString(), Icons.flag, Colors.blue),
          ),
          SizedBox(width: _getResponsiveSize(context, 8)), // Reduced spacing
          Expanded(
            child: _buildCompactSummaryItem(
                context,
                'Streak',
                controller.consecutiveCorrect.toString(),
                Icons.trending_up,
                Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: _getResponsiveIconSize(context, 32)),
        SizedBox(height: _getResponsiveSize(context, 8)),
        Text(
          value,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 24),
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: _getResponsiveFontSize(context, 12),
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCompactSummaryItem(BuildContext context, String label,
      String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(_getResponsivePadding(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: _getResponsiveIconSize(context, 32)),
          SizedBox(height: _getResponsiveSize(context, 8)),
          Text(
            value,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, 14),
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper method to get progress color based on completion percentage
  Color _getProgressColor(double progressValue) {
    if (progressValue < 0.25) {
      return Colors.red[400]!; // Just started - red
    } else if (progressValue < 0.5) {
      return Colors.orange[500]!; // Quarter way - orange
    } else if (progressValue < 0.75) {
      return Colors.yellow[600]!; // Half way - yellow
    } else if (progressValue < 1.0) {
      return Colors.lightGreen[500]!; // Almost done - light green
    } else {
      return Colors.green[600]!; // Completed - green
    }
  }

  // Show word image in popup
  void _showWordImagePopup(
      BuildContext context, MissingWordController controller) {
    final imageUrl = controller.getCurrentWordImageUrl();

    if (imageUrl.isEmpty) {
      // Show message if no image available
      showToast(
        'No image available for this word',
        duration: const Duration(milliseconds: 2000),
        position: ToastPosition.center,
        backgroundColor: Colors.orange.withOpacity(0.9),
        radius: _getResponsiveSize(context, 10),
        textStyle: TextStyle(
          fontSize: _getResponsiveFontSize(context, 16),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              minHeight: MediaQuery.of(context).size.height * 0.4,
              minWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(_getResponsiveSize(context, 16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: _getResponsiveSize(context, 10),
                    offset: Offset(0, _getResponsiveSize(context, 5)),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Container(
                    padding: EdgeInsets.all(_getResponsivePadding(context, 16)),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(_getResponsiveSize(context, 16)),
                        topRight:
                            Radius.circular(_getResponsiveSize(context, 16)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Word Image',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: EdgeInsets.all(
                                _getResponsivePadding(context, 4)),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(
                                  _getResponsiveSize(context, 20)),
                            ),
                            child: Icon(
                              Icons.close,
                              size: _getResponsiveIconSize(context, 20),
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Image content
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.all(_getResponsivePadding(context, 16)),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              _getResponsiveSize(context, 12)),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: _getResponsiveSize(context, 200),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue[600]!),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: _getResponsiveSize(context, 200),
                                padding: EdgeInsets.all(
                                    _getResponsivePadding(context, 20)),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(
                                      _getResponsiveSize(context, 12)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: _getResponsiveIconSize(context, 48),
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(
                                        height:
                                            _getResponsiveSize(context, 12)),
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(
                                        fontSize:
                                            _getResponsiveFontSize(context, 16),
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
