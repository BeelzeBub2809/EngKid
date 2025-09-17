class PuzzlePiece {
  final int id;
  final String imagePath;
  final int correctPosition;
  final String letter;
  int currentPosition;
  bool isPlaced;

  PuzzlePiece({
    required this.id,
    required this.imagePath,
    required this.correctPosition,
    required this.letter,
    this.currentPosition = -1,
    this.isPlaced = false,
  });

  bool get isInCorrectPosition => currentPosition == correctPosition;

  PuzzlePiece copyWith({
    int? currentPosition,
    bool? isPlaced,
  }) {
    return PuzzlePiece(
      id: id,
      imagePath: imagePath,
      correctPosition: correctPosition,
      letter: letter,
      currentPosition: currentPosition ?? this.currentPosition,
      isPlaced: isPlaced ?? this.isPlaced,
    );
  }
}

class PuzzleData {
  final String word;
  final String backgroundImagePath;
  final String audioPath;
  final List<PuzzlePiece> pieces;
  final int difficulty;

  PuzzleData({
    required this.word,
    required this.backgroundImagePath,
    required this.audioPath,
    required this.pieces,
    required this.difficulty,
  });

  bool get isCompleted {
    return pieces.every((piece) => piece.isInCorrectPosition);
  }

  double get completionPercentage {
    int correctPieces = pieces.where((piece) => piece.isInCorrectPosition).length;
    return correctPieces / pieces.length;
  }
}
