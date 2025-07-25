import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'memory_game_controller.dart';

class MemoryGameUI extends GetView<MemoryGameController> {
  const MemoryGameUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Memory Games',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.timerActive ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (controller.timerActive) {
                    controller.pauseGame();
                  } else {
                    controller.resumeGame();
                  }
                },
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildGameHeader(),
              const SizedBox(height: 20),
              if (!controller.gameStarted) ...[
                _buildGameTypeSelector(),
                const SizedBox(height: 20),
                _buildDifficultySelector(),
                const SizedBox(height: 20),
                _buildGameSettings(),
                const SizedBox(height: 30),
                _buildStartButton(),
              ] else ...[
                _buildGameProgress(),
                const SizedBox(height: 20),
                _buildGameContent(),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.psychology,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Train Your Memory',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  controller.gameStarted
                      ? 'Round ${controller.currentRound + 1}/${controller.rounds}'
                      : 'Choose your challenge',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (controller.gameStarted) ...[
            Column(
              children: [
                const Text(
                  'Score',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${controller.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Game Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MemoryGameType.values.map((type) {
              final isSelected = controller.selectedGameType == type;
              return GestureDetector(
                onTap: () => controller.setGameType(type),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4A90E2)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4A90E2)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getGameTypeIcon(type),
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getGameTypeName(type),
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Difficulty Level',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: MemoryDifficulty.values.map((difficulty) {
              final isSelected = controller.selectedDifficulty == difficulty;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.setDifficulty(difficulty),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getDifficultyColor(difficulty)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? _getDifficultyColor(difficulty)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getDifficultyIcon(difficulty),
                          color:
                              isSelected ? Colors.white : Colors.grey.shade600,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDifficultyName(difficulty),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Game Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time Limit',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: controller.gameTimeLimit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [30, 60, 90, 120, 0].map((seconds) {
                        return DropdownMenuItem(
                          value: seconds,
                          child: Text(
                            seconds == 0 ? 'No limit' : '${seconds}s',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setTimeLimit(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rounds',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: controller.rounds,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [3, 5, 10, 15].map((rounds) {
                        return DropdownMenuItem(
                          value: rounds,
                          child: Text('$rounds rounds'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setRounds(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.startGame,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: const Text(
          'Start Memory Challenge',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGameProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Round',
                  '${controller.currentRound + 1}/${controller.rounds}'),
              _buildStatItem('Score', '${controller.score}'),
              _buildStatItem(
                  'Accuracy', '${(controller.accuracy * 100).round()}%'),
              if (controller.gameTimeLimit > 0)
                _buildStatItem('Time', '${controller.timeRemaining}s'),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: controller.progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildGameContent() {
    switch (controller.selectedGameType) {
      case MemoryGameType.cardMatching:
        return _buildCardMatchingGame();
      case MemoryGameType.sequenceMemory:
        return _buildSequenceGame();
      case MemoryGameType.wordMemory:
        return _buildWordMemoryGame();
      case MemoryGameType.colorPattern:
        return _buildColorPatternGame();
      case MemoryGameType.numberSequence:
        return _buildNumberSequenceGame();
    }
  }

  Widget _buildCardMatchingGame() {
    final cards = controller.cards;
    final gridSize = _getCardGridSize();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Matching',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const Text(
            'Flip cards to find matching pairs',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize.first,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return GestureDetector(
                onTap: () => controller.flipCard(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: card.isFlipped || card.isMatched
                        ? card.color.withOpacity(0.1)
                        : const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: card.isMatched
                          ? Colors.green
                          : card.isFlipped
                              ? card.color
                              : const Color(0xFF4A90E2),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: card.isFlipped || card.isMatched
                        ? Text(
                            card.content,
                            style: const TextStyle(fontSize: 24),
                          )
                        : const Icon(
                            Icons.help_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSequenceGame() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sequence Memory',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Text(
            controller.showingSequence
                ? 'Watch the sequence...'
                : controller.waitingForInput
                    ? 'Repeat the sequence'
                    : 'Get ready...',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final isHighlighted = controller.sequence
                  .any((item) => item.index == index && item.isHighlighted);
              final sequenceItem = controller.sequence
                      .where((item) => item.index == index)
                      .isNotEmpty
                  ? controller.sequence
                      .where((item) => item.index == index)
                      .first
                  : null;

              return GestureDetector(
                onTap: controller.waitingForInput
                    ? () => controller.addToPlayerSequence(index)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? (sequenceItem?.color ?? Colors.blue)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isHighlighted
                          ? (sequenceItem?.color ?? Colors.blue)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            isHighlighted ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWordMemoryGame() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Word Memory',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Text(
            controller.showMemoryItems
                ? 'Memorize these words (${controller.memoryTime}s remaining)'
                : controller.waitingForInput
                    ? 'Select the words you memorized'
                    : 'Get ready...',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          if (controller.showMemoryItems) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.wordsToMemorize.map((word) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else if (controller.waitingForInput) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.availableWords.map((word) {
                final isSelected = controller.selectedWords.contains(word);
                return GestureDetector(
                  onTap: () => controller.selectWord(word),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4A90E2)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4A90E2)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.waitingForInput
                    ? controller.submitWordSelection
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Submit Selection'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColorPatternGame() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color Pattern',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Text(
            controller.showingSequence
                ? 'Watch the color pattern...'
                : controller.waitingForInput
                    ? 'Repeat the color pattern'
                    : 'Get ready...',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
              Colors.pink,
              Colors.cyan
            ].asMap().entries.map((entry) {
              final index = entry.key;
              final color = entry.value;
              final isHighlighted = controller.sequence
                  .any((item) => item.index == index && item.isHighlighted);

              return GestureDetector(
                onTap: controller.waitingForInput
                    ? () => controller.addToPlayerSequence(index)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isHighlighted ? Colors.white : Colors.transparent,
                      width: 4,
                    ),
                    boxShadow: isHighlighted
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSequenceGame() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number Sequence',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Text(
            controller.showingSequence
                ? 'Watch the number sequence...'
                : controller.waitingForInput
                    ? 'Repeat the number sequence'
                    : 'Get ready...',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final number = index + 1;
              final isHighlighted = controller.sequence
                  .any((item) => item.index == index && item.isHighlighted);

              return GestureDetector(
                onTap: controller.waitingForInput
                    ? () => controller.addToPlayerSequence(index)
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? const Color(0xFF4A90E2)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isHighlighted
                          ? const Color(0xFF4A90E2)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            isHighlighted ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getGameTypeIcon(MemoryGameType type) {
    switch (type) {
      case MemoryGameType.cardMatching:
        return Icons.flip_to_front;
      case MemoryGameType.sequenceMemory:
        return Icons.linear_scale;
      case MemoryGameType.wordMemory:
        return Icons.text_fields;
      case MemoryGameType.colorPattern:
        return Icons.palette;
      case MemoryGameType.numberSequence:
        return Icons.format_list_numbered;
    }
  }

  String _getGameTypeName(MemoryGameType type) {
    switch (type) {
      case MemoryGameType.cardMatching:
        return 'Card Matching';
      case MemoryGameType.sequenceMemory:
        return 'Sequence Memory';
      case MemoryGameType.wordMemory:
        return 'Word Memory';
      case MemoryGameType.colorPattern:
        return 'Color Pattern';
      case MemoryGameType.numberSequence:
        return 'Number Sequence';
    }
  }

  IconData _getDifficultyIcon(MemoryDifficulty difficulty) {
    switch (difficulty) {
      case MemoryDifficulty.easy:
        return Icons.sentiment_satisfied;
      case MemoryDifficulty.medium:
        return Icons.sentiment_neutral;
      case MemoryDifficulty.hard:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  String _getDifficultyName(MemoryDifficulty difficulty) {
    switch (difficulty) {
      case MemoryDifficulty.easy:
        return 'Easy';
      case MemoryDifficulty.medium:
        return 'Medium';
      case MemoryDifficulty.hard:
        return 'Hard';
    }
  }

  Color _getDifficultyColor(MemoryDifficulty difficulty) {
    switch (difficulty) {
      case MemoryDifficulty.easy:
        return Colors.green;
      case MemoryDifficulty.medium:
        return Colors.orange;
      case MemoryDifficulty.hard:
        return Colors.red;
    }
  }

  List<int> _getCardGridSize() {
    switch (controller.selectedDifficulty) {
      case MemoryDifficulty.easy:
        return [3, 4]; // 3 columns, 4 rows
      case MemoryDifficulty.medium:
        return [4, 4]; // 4 columns, 4 rows
      case MemoryDifficulty.hard:
        return [4, 6]; // 4 columns, 6 rows
    }
  }
}
