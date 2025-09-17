import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'image_puzzle_controller.dart';

class ImagePuzzleGameUI extends GetView<ImagePuzzleGameController> {
  const ImagePuzzleGameUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingScreen();
        }

        if (controller.showingCompleteImage.value) {
          return _buildPreviewScreen();
        }

        return _buildGameScreen();
      }),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB),
            Color(0xFFB0E0E6),
          ],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildPreviewScreen() {
    return Container(
      decoration: controller.isNetworkImage
        ? BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(controller.currentPuzzle.value!.backgroundImagePath),
              fit: BoxFit.cover,
            ),
          )
        : const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF87CEEB), Color(0xFFB0E0E6)],
            ),
          ),
      child: SafeArea(
        child: Column(
          children: [
            // Header với countdown
            Container(
              margin: EdgeInsets.all(4.w),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    'Nhìn kỹ: ${controller.previewCountdown.value}s',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ],
              ),
            ),

            const Spacer(),

            // GO Button
            Container(
              margin: EdgeInsets.all(4.w),
              child: GestureDetector(
                onTap: controller.startGame,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'GO',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFFB0E0E6)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // KHU VỰC PUZZLE
            Expanded(
              child: Obx(() {
                final word = controller.currentPuzzle.value?.word ?? '';
                final pieces = word.length;
                if (word.isEmpty) return const SizedBox.shrink();
                return _buildPuzzleArea(word, pieces);
              }),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  Obx(() {
                    final word = controller.currentPuzzle.value?.word ?? '';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(word.length, (index) {
                        final pieceIndex = controller.currentOrder[index];
                        final letter = word[pieceIndex];
                        final isCorrect = pieceIndex == index;
                        final screenWidth = 92.w;
                        final pieceWidth = screenWidth / word.length;

                        return Container(
                          width: pieceWidth * 0.8,
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: pieceWidth * 0.1),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? const Color(0xFF4CAF50).withOpacity(0.9)
                                : const Color(0xFFFF6B35).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                  SizedBox(height: 2.h),
                  Obx(() => controller.gameCompleted.value
                      ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'WELL DONE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleArea(String word, int pieces) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(pieces, (index) {
        return _buildPuzzlePiece(
          index: index,
          totalPieces: pieces,
        );
      }),
    );
  }

  // ĐÃ SỬA ĐỔI: Không còn Positioned, hoạt động trong Row
  Widget _buildPuzzlePiece({
    required int index,
    required int totalPieces,
  }) {
    // Dùng Expanded để mỗi mảnh tự động chia đều chiều rộng
    return Expanded(
      child: Obx(() {
        final pieceIndex = controller.currentOrder[index];
        final isDragged = controller.draggedIndex.value == index;

        return LayoutBuilder(
          builder: (context, constraints) {
            final pieceWidth = constraints.maxWidth;
            final pieceHeight = constraints.maxHeight;

            return DragTarget<int>(
              onAccept: (fromIndex) {
                controller.swapPieces(fromIndex, index);
              },
              onWillAccept: (fromIndex) => fromIndex != null && fromIndex != index,
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    border: candidateData.isNotEmpty
                        ? Border.all(color: Colors.yellow, width: 4)
                        : isDragged
                        ? Border.all(color: Colors.blue, width: 2)
                        : Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  clipBehavior: Clip.hardEdge, // Dòng này cắt widget tĩnh
                  child: Draggable<int>(
                    data: index,
                    feedback: Material(
                      color: Colors.transparent,
                      child: ClipRect(
                        child: SizedBox(
                          width: pieceWidth,
                          height: pieceHeight,
                          child: _buildPuzzlePieceContent(pieceIndex, totalPieces, pieceWidth, pieceHeight),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    onDragStarted: () => controller.startDragging(index),
                    onDragEnd: (_) => controller.stopDragging(),
                    child: _buildPuzzlePieceContent(pieceIndex, totalPieces, pieceWidth, pieceHeight),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildPuzzlePieceContent(int pieceIndex, int totalPieces, double pieceWidth, double pieceHeight) {
    final backgroundUrl = controller.currentPuzzle.value?.backgroundImagePath ?? '';

    if (!controller.isNetworkImage) {
      // ... code dự phòng không đổi
    }

    // Giữ lại logic OverflowBox và Transform.translate của bạn
    return OverflowBox(
      alignment: Alignment.centerLeft,
      maxWidth: double.infinity,
      child: Transform.translate(
        offset: Offset(-pieceIndex * pieceWidth, 0),
        // Sử dụng một SizedBox có kích thước chính xác
        child: SizedBox(
          width: pieceWidth * totalPieces, // Tổng chiều rộng của toàn bộ ảnh
          height: pieceHeight,             // Chiều cao chính xác của khu vực puzzle
          child: Image.network(
            backgroundUrl,
            // BoxFit.fill sẽ kéo dãn ảnh để lấp đầy SizedBox này
            // mà không giữ tỷ lệ. Điều này là cần thiết để logic
            // cắt ảnh của bạn hoạt động chính xác.
            fit: BoxFit.fill,
            // Ép buộc Image phải có kích thước này, bỏ qua tỷ lệ nội tại
            width: pieceWidth * totalPieces,
            height: pieceHeight,
          ),
        ),
      ),
    );
  }
}
