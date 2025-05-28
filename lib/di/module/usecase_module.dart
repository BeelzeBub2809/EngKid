import 'package:get/get.dart';
import 'package:EngKid/data/core/remote/api/user_api/user_api.dart';
import 'package:EngKid/data/core/remote/api/auth_api/auth_api.dart';
import 'package:EngKid/data/core/remote/app_repo.dart';
import 'package:EngKid/data/login/login_repo.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/domain/core/entities/feedback/feedback_usecases.dart';
import 'package:EngKid/domain/organization/organization_usecases.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/domain/survey/survey_usecases.dart';
import 'package:EngKid/domain/core/app_usecases.dart';
import 'package:EngKid/domain/login/login_usecases.dart';
import 'package:EngKid/domain/start_board/star_board_usecases.dart';

class UseCaseModule {
  void provides() {
    Get.put(
      AppUseCases(
        AppRepositoryImp(
          userApi: getIt.get<UserApi>(),
        ),
      ),
    );

    Get.lazyPut<LoginUsecases>(
      () => LoginUsecases(
        LoginRepositoryImp(
          authApi: getIt.get<AuthApi>(),
        ),
      ),
      fenix: true,
    );
    //
    //
    // Get.lazyPut<QuizUseCases>(
    //   () => QuizUseCases(),
    //   fenix: true,
    // );
  }
}
