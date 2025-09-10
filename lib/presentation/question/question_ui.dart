import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/presentation/core/topic_service.dart';
import 'package:EngKid/presentation/core/user_service.dart';
import 'package:EngKid/presentation/question/plugins/Fill%20Table/fill_table_controller.dart';
import 'package:EngKid/presentation/question/plugins/Fill%20Table/fill_table_ui.dart';
import 'package:EngKid/presentation/question/plugins/achieve_star/achieve_controller.dart';
import 'package:EngKid/presentation/question/plugins/achieve_star/achieve_star_ui.dart';
import 'package:EngKid/presentation/question/plugins/crossword_puzzle/crossword_puzzle_controller.dart';
import 'package:EngKid/presentation/question/plugins/crossword_puzzle/crossword_puzzle_ui.dart';
import 'package:EngKid/presentation/question/plugins/drawing/drawing_controller.dart';
import 'package:EngKid/presentation/question/plugins/drawing/drawing_ui.dart';
import 'package:EngKid/presentation/question/plugins/coloring/coloring_controller.dart';
import 'package:EngKid/presentation/question/plugins/coloring/coloring_ui.dart';
import 'package:EngKid/presentation/question/plugins/final_question_screen/final_question_screen_controller.dart';
import 'package:EngKid/presentation/question/plugins/final_question_screen/final_question_screen_ui.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:EngKid/presentation/question/plugins/fill_word/fill_word_controller.dart';
import 'package:EngKid/presentation/question/plugins/fill_word/fill_word_ui.dart';
import 'package:EngKid/presentation/question/plugins/fill_blank/fill_blank_controller.dart';
import 'package:EngKid/presentation/question/plugins/fill_blank/fill_blank_ui.dart';
import 'package:EngKid/presentation/question/plugins/jigsaw_puzzle/jigsaw_puzzle_controller.dart';
import 'package:EngKid/presentation/question/plugins/jigsaw_puzzle/jigsaw_puzzle_ui.dart';
import 'package:EngKid/presentation/question/plugins/matched/matched_controller.dart';
import 'package:EngKid/presentation/question/plugins/matched/matched_ui.dart';
import 'package:EngKid/presentation/question/plugins/multiple_choice/multiple_choice_controller.dart';
import 'package:EngKid/presentation/question/plugins/multiple_choice/multiple_choice_ui.dart';
import 'package:EngKid/presentation/question/plugins/read/read_controller.dart';
import 'package:EngKid/presentation/question/plugins/read/read_ui.dart';
import 'package:EngKid/presentation/question/plugins/single_choice/single_choice_controller.dart';
import 'package:EngKid/presentation/question/plugins/single_choice/single_choice_ui.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'plugins/video/video_controller.dart';
import 'plugins/video/video_ui.dart';

class QuestionScreen extends GetView<QuestionController> {
  QuestionScreen({super.key});
  final TopicService _topicService = Get.find<TopicService>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(LocalImage.topicBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Navigator(
                key: Get.nestedKey(AppRoute.quizNestedRouteKey),
                initialRoute: controller.pluginRouteNames[0],
                // initialRoute: AppRoute.drawing,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case AppRoute.video:
                      return GetPageRoute(
                        page: () => VideoScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => VideoController(
                              question: controller
                                  .questionList[controller.questionIndex],
                              readingId: controller.readingId,
                              quizUseCases: Get.find(),
                              nextQuestion: () => controller.onNextBtnPress(),
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.singleChoice:
                      return GetPageRoute(
                        page: () => SingleChoiceScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => SingleChoiceController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () => controller.onNextBtnPress(),
                                questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.multipleChoice:
                      return GetPageRoute(
                        page: () => MultipleChoiceScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => MultipleChoiceController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () => controller.onNextBtnPress(),
                                questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.matched:
                      return GetPageRoute(
                        page: () => MatchedScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => MatchedController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () => controller.onNextBtnPress(),
                                questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.fillWord:
                      return GetPageRoute(
                        page: () => FillWordScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => FillWordController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () =>
                                    controller.onNextBtnPress(),
                                questionController: controller),

                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.fillBlank:
                      return GetPageRoute(
                        page: () => FillBlankScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => FillBlankController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () => controller.onNextBtnPress(),
                                setIsFullScreen: (bool value) {
                                  controller.isFullScreen = value;
                                },
                                questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.fillTable:
                      return GetPageRoute(
                        page: () => FillTableScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => FillTableController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () => controller.onNextBtnPress(),
                                setIsFullScreen: (bool value) {
                                  controller.isFullScreen = value;
                                },
                                questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.crosswordPuzzle:
                      return GetPageRoute(
                        page: () => CrosswordPuzzleScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => CrosswordPuzzleController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () => controller.onNextBtnPress(),
                                setIsFullScreen: (bool value) {
                                  controller.isFullScreen = value;
                                },
                                questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.coloring:
                      return GetPageRoute(
                        page: () => const ColoringScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => ColoringController(
                              question: controller
                                  .questionList[controller.questionIndex],
                              readingId: controller.readingId,
                              quizUseCases: Get.find(),
                              nextQuestion: () => controller.onNextBtnPress(),
                              coloringUrl: controller.coloringUrl,
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.jigsawPuzzle:
                      return GetPageRoute(
                        page: () => JigsawPuzzleScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => JigsawPuzzleController(
                                question: controller
                                    .questionList[controller.questionIndex],
                                readingId: controller.readingId,
                                quizUseCases: Get.find(),
                                nextQuestion: () => controller.onNextBtnPress(),
                                questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );

                    case AppRoute.read:
                      return GetPageRoute(
                        page: () => ReadScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => ReadController(
                              question: controller
                                  .questionList[controller.questionIndex],
                              readingId: controller.readingId,
                              quizUseCases: Get.find(),
                              nextQuestion: () => controller.onNextBtnPress(),
                              setIsFullScreen: (bool value) {
                                controller.isFullScreen = value;
                              },
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.drawing:
                      return GetPageRoute(
                        page: () => const DrawingScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => DrawingController(
                              question: controller
                                  .questionList[controller.questionIndex],
                              quizUseCases: Get.find(),
                              nextQuestion: () => controller.onNextBtnPress(),
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.achieveStar:
                      return GetPageRoute(
                        page: () => AchieveStarScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => AchieveStarController(
                              question: controller
                                  .questionList[controller.questionIndex],
                              quizUseCases: Get.find(),
                              nextQuestion: () => controller.onNextBtnPress(),
                              backQuestion: () => controller.backQuestion(),
                              relearn: () => controller.relearnQuestion(),
                              setIsFullScreen: (bool value) {
                                controller.isFullScreen = value;
                              },
                              readingId: controller.readingId,
                              questionController: controller
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    case AppRoute.questionFinalScreen:
                      return GetPageRoute(
                        page: () => FinalQuestionScreen(),
                        binding: BindingsBuilder(
                              () => Get.create(
                                () => FinalQuestionScreenController(
                              question: controller
                                  .questionList[controller.questionIndex],
                              quizUseCases: Get.find(),
                              nextQuestion: () => controller.onNextBtnPress(),
                              backQuestion: () => controller.backQuestion(),
                              relearn: () => controller.relearn(),
                              setIsFullScreen: (bool value) {
                                controller.isFullScreen = value;
                              },
                              readingId: controller.readingId,
                            ),
                          ),
                        ),
                        transition: controller.isBack
                            ? Transition.leftToRightWithFade
                            : Transition.rightToLeftWithFade,
                      );
                    default:
                      return GetPageRoute(page: () => Container());
                  }
                },
              ),
              Obx(
                    () => controller.isFullScreen
                    ? const SizedBox()
                    : Positioned.fill(
                  top: 0.02 * size.height,
                  left: 0.01 * size.width,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        ImageButton(
                          onTap: () {
                            controller.onStopBtnPress();
                          },
                          semantics: 'home',
                          pathImage: LocalImage.buttonHome,
                          height: 0.075 * size.width,
                          width: 0.075 * size.width,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if(!_topicService.isCaculator)
                Obx(
                      () => controller.isFullScreen
                      ? const SizedBox()
                      : Positioned.fill(
                    bottom: 0.02 * size.height,
                    left: 0.01 * size.width,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ImageButton(
                        onTap: () {
                          controller.backQuestion();
                        },
                        semantics: 'back',
                        pathImage: LocalImage.backButton,
                        height: 0.075 * size.width,
                        width: 0.075 * size.width,
                      ),
                    ),
                  ),
                ),
              if (_topicService.isCaculator)
                Obx(
                      () => (controller.isFullScreen ||
                      !controller
                          .questionList[controller.questionIndex].isLearned)
                      ? const SizedBox()
                      : Positioned.fill(
                    bottom: 0.02 * size.height,
                    left: 0.01 * size.width,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ImageButton(
                        onTap: () {
                          controller.onNextBtnPress();
                        },
                        semantics: 'next',
                        pathImage: LocalImage.nextButton,
                        height: 0.075 * size.width,
                        width: 0.075 * size.width,
                      ),
                    ),
                  ),
                )
              else
                Obx(
                      () => !controller.isFullScreen
                      ? Positioned.fill(
                    bottom: 0.02 * size.height,
                    left: 0.01 * size.width,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ImageButton(
                        onTap: () {
                          controller.onNextBtnPress();
                        },
                        semantics: 'next',
                        pathImage: LocalImage.nextButton,
                        height: 0.075 * size.width,
                        width: 0.075 * size.width,
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
