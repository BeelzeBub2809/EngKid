import 'package:EzLish/domain/core/app_reponsitory.dart';
import 'package:EzLish/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EzLish/domain/core/entities/app_setting/entities/reading_sequence_setting/reading_sequence_setting.dart';
import 'package:EzLish/domain/core/entities/app_setting/entities/star_setting/star_setting.dart';
import 'package:EzLish/domain/core/entities/entities.dart';
import 'package:EzLish/domain/core/entities/grade_reading/grade_reading.dart';
import 'package:EzLish/domain/core/entities/lesson/lesson.dart';
import 'package:EzLish/domain/core/entities/submit_answer/submit_answer.dart';
import 'package:EzLish/domain/grade/entities/entities.dart';
import 'package:EzLish/domain/quiz/entities/entites.dart';
import 'package:EzLish/domain/start_board/entities/entities.dart';
import 'package:EzLish/domain/topic/entities/entites.dart';

class AppUseCases {
  final AppRepository _appRepository;
  AppUseCases(this._appRepository);
  // Future<UserInfo> getUserInfo(int id) => _appRepository.getUserInfo(id);
}
