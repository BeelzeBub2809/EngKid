import 'package:EngKid/domain/core/app_reponsitory.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/reading_sequence_setting/reading_sequence_setting.dart';
import 'package:EngKid/domain/core/entities/app_setting/entities/star_setting/star_setting.dart';
import 'package:EngKid/domain/core/entities/entities.dart';
import 'package:EngKid/domain/core/entities/grade_reading/grade_reading.dart';
import 'package:EngKid/domain/core/entities/lesson/lesson.dart';
import 'package:EngKid/domain/core/entities/submit_answer/submit_answer.dart';
import 'package:EngKid/domain/grade/entities/entities.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/start_board/entities/entities.dart';
import 'package:EngKid/domain/topic/entities/entites.dart';

class AppUseCases {
  final AppRepository _appRepository;
  AppUseCases(this._appRepository);
  // Future<UserInfo> getUserInfo(int id) => _appRepository.getUserInfo(id);
}
