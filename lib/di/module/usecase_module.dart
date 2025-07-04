import 'package:EngKid/data/core/remote/api/ebook_category_api/ebook_category_api.dart';
import 'package:EngKid/data/core/remote/api/topic_api/topic_api.dart';
import 'package:EngKid/data/ebook_category/ebook_category_repo.dart';
import 'package:EngKid/data/topic_reading/topic_reading_repo.dart';
import 'package:EngKid/domain/ebook_category/ebook_category_usecase.dart';
import 'package:EngKid/domain/topic/topic_reading_usecases.dart';
import 'package:EngKid/data/core/remote/api/ebook_api/ebook_api.dart';
import 'package:EngKid/data/ebook/ebook_repo.dart';
import 'package:EngKid/domain/ebook/ebook_usecases.dart';
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
    Get.lazyPut<TopicReadingUsecases>(
      () => TopicReadingUsecases(
        TopicReadingRepositoryImp(
          topicApi: getIt.get<TopicApi>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<EBookUsecases>(
      () => EBookUsecases(
        EbookRepoImp(
          eBookApi: getIt.get<EBookApi>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<EBookCategoryUsecases>(
      () => EBookCategoryUsecases(
        EbookCategoryRepoImp(
          eBookCateApi: getIt.get<EBookCategoryApi>(),
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
