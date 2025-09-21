import 'package:EngKid/data/core/remote/api/ebook_category_api/ebook_category_api.dart';
import 'package:EngKid/data/core/remote/api/feedback_api/feedback_api.dart';
import 'package:EngKid/data/core/remote/api/learning_path_api/learning_path_api.dart';
import 'package:EngKid/data/core/remote/api/notification_api/notification_api.dart';
import 'package:EngKid/data/core/remote/api/question_api/question_api.dart';
import 'package:EngKid/data/core/remote/api/reading_api/reading_api.dart';
import 'package:EngKid/data/child/child_repo.dart';
import 'package:EngKid/data/core/remote/api/child_api/child_api.dart';
import 'package:EngKid/data/core/remote/api/student_reading_api/student_reading_api.dart';
import 'package:EngKid/data/core/remote/api/topic_api/topic_api.dart';
import 'package:EngKid/data/ebook_category/ebook_category_repo.dart';
import 'package:EngKid/data/feedback/feedback_repo.dart';
import 'package:EngKid/data/learning_path/learning_path_repo.dart';
import 'package:EngKid/data/notificaiton/notification_repo.dart';
import 'package:EngKid/data/question/question_repo.dart';
import 'package:EngKid/data/reading/reading_repo.dart';
import 'package:EngKid/data/star_board/star_board_repo.dart';
import 'package:EngKid/data/topic_reading/topic_reading_repo.dart';
import 'package:EngKid/domain/ebook_category/ebook_category_usecase.dart';
import 'package:EngKid/domain/feedback/feedback_usecases.dart';
import 'package:EngKid/domain/learning_path/learning_path_usecases.dart';
import 'package:EngKid/domain/notificaiton/notification_usecase.dart';
import 'package:EngKid/domain/question/question_usecases.dart';
import 'package:EngKid/domain/reading/reading_usecases.dart';
import 'package:EngKid/domain/core/entities/child_profile/child_profiles_usecase.dart';
import 'package:EngKid/domain/start_board/star_board_responsitory.dart';
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
    Get.lazyPut<ReadingUsecases>(
      () => ReadingUsecases(
        ReadingRepositoryImp(
            readingApi: getIt.get<ReadingApi>(),
            studentReadingApi: getIt.get<StudentReadingApi>()),
      ),
      fenix: true,
    );
    Get.lazyPut<QuestionUsecases>(
      () => QuestionUsecases(
        QuestionRepositoryImp(
          questionApi: getIt.get<QuestionApi>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<ChildProfilesUsecases>(
      () => ChildProfilesUsecases(
        ChildRepositoryImp(
          childApi: getIt.get<ChildApi>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<StarBoardUseCases>(
      () => StarBoardUseCases(
        StarBoardRepoImp(
          studentReadingApi: getIt.get<StudentReadingApi>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<NotificationUsecases>(
      () => NotificationUsecases(
        NotificationRepositoryImp(
          notificationApi: getIt.get<NotificationApi>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<FeedbackUsecases>(
      () => FeedbackUsecases(
        FeedbackRepositoryImp(
          feedbackApi: getIt.get<FeedbackApi>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<LearningPathUseCases>(
      () => LearningPathUseCases(
        LearningPathRepositoryImp(
          learningPathApi: getIt.get<LearningPathApi>(),
        ),
      ),
      fenix: true,
    );
  }
}
