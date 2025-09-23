class WordEntity {
  final int id;
  final String word;
  final String note;
  final String image;
  final int level;
  final int type;
  final bool isActive;
  final DateTime createdAt;
  final List<GameInfo> games;

  const WordEntity({
    required this.id,
    required this.word,
    required this.note,
    required this.image,
    required this.level,
    required this.type,
    required this.isActive,
    required this.createdAt,
    required this.games,
  });
}

class GameInfo {
  final int id;
  final String name;
  final GameWords gameWords;

  const GameInfo({
    required this.id,
    required this.name,
    required this.gameWords,
  });
}

class GameWords {
  final int sequenceOrder;

  const GameWords({
    required this.sequenceOrder,
  });
}
