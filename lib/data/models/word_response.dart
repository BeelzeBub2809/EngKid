import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/word/word_entity.dart';

part 'word_response.g.dart';

@JsonSerializable()
class WordResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'status')
  final int status;

  @JsonKey(name: 'errors')
  final dynamic errors;

  @JsonKey(name: 'data')
  final List<WordData> data;

  const WordResponse({
    required this.success,
    required this.message,
    required this.status,
    this.errors,
    required this.data,
  });

  factory WordResponse.fromJson(Map<String, dynamic> json) =>
      _$WordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WordResponseToJson(this);
}

@JsonSerializable()
class WordData {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'word')
  final String word;

  @JsonKey(name: 'note')
  final String note;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'level')
  final int level;

  @JsonKey(name: 'type')
  final int type;

  @JsonKey(name: 'is_active')
  final int isActive;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'games')
  final List<GameInfoData> games;

  const WordData({
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

  factory WordData.fromJson(Map<String, dynamic> json) =>
      _$WordDataFromJson(json);

  Map<String, dynamic> toJson() => _$WordDataToJson(this);

  WordEntity toEntity() {
    return WordEntity(
      id: id,
      word: word,
      note: note,
      image: image,
      level: level,
      type: type,
      isActive: isActive == 1,
      createdAt: DateTime.parse(createdAt),
      games: games.map((game) => game.toEntity()).toList(),
    );
  }
}

@JsonSerializable()
class GameInfoData {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'game_words')
  final GameWordsData gameWords;

  const GameInfoData({
    required this.id,
    required this.name,
    required this.gameWords,
  });

  factory GameInfoData.fromJson(Map<String, dynamic> json) =>
      _$GameInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameInfoDataToJson(this);

  GameInfo toEntity() {
    return GameInfo(
      id: id,
      name: name,
      gameWords: gameWords.toEntity(),
    );
  }
}

@JsonSerializable()
class GameWordsData {
  @JsonKey(name: 'sequence_order')
  final int sequenceOrder;

  const GameWordsData({
    required this.sequenceOrder,
  });

  factory GameWordsData.fromJson(Map<String, dynamic> json) =>
      _$GameWordsDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameWordsDataToJson(this);

  GameWords toEntity() {
    return GameWords(
      sequenceOrder: sequenceOrder,
    );
  }
}
