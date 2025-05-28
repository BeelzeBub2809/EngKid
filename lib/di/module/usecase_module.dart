import 'package:get/get.dart';
import 'package:EzLish/data/core/remote/api/user_api/user_api.dart';
import 'package:EzLish/data/core/remote/api/auth_api/auth_api.dart';
import 'package:EzLish/data/core/remote/app_repo.dart';
import 'package:EzLish/data/login/login_repo.dart';
import 'package:EzLish/di/injection.dart';
import 'package:EzLish/domain/core/entities/feedback/feedback_usecases.dart';
import 'package:EzLish/domain/organization/organization_usecases.dart';
import 'package:EzLish/domain/quiz/quiz_usecases.dart';
import 'package:EzLish/domain/survey/survey_usecases.dart';
import 'package:EzLish/domain/core/app_usecases.dart';
import 'package:EzLish/domain/login/login_usecases.dart';
import 'package:EzLish/domain/start_board/star_board_usecases.dart';

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
