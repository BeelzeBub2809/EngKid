import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_noti_question.dart';

import '../../../../widgets/dialog/dialog_single_question.dart';

class JigsawPuzzleController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final int readingId;
  final QuestionController questionController;

  JigsawPuzzleController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.readingId,
    required this.questionController
  });

  final List<Rx<Option>> _options = List<Rx<Option>>.empty(growable: true);

  final RxBool _isCompleted = false.obs;

  bool get isCompleted => _isCompleted.value;
  List<Rx<Option>> get options => _options;

  @override
  void onInit() {
    super.onInit();
    initData();
    questionController.readQuestion(question,_options);
  }

  void initData() {
    _isCompleted.value = false;
    _options
        .assignAll(List<Option>.from(LibFunction.shuffle(question.options)).map(
          (e) => e.obs,
    ));
  }

  void onCorrect(Rx<Option> data, int index) async {
    final int idx = _options
        .indexWhere((element) => element.value.optionId == data.value.optionId);
    if (idx == -1) return;

    _options[idx](options[idx].value.copyWith(position: index));
    LibFunction.effectTrueAnswer();
    _checkDone();
  }

  void _checkDone() async {
    if (_options.where((element) => element.value.position == -1).isEmpty) {
      _isCompleted.value = true;
    }
  }

  String getImageInPosition(int index) {
    final Rx<Option>? option =
    _options.firstWhereOrNull((element) => element.value.position == index);
    if (option == null) return "";
    return option.value.image;
  }

  bool enableDragTo(int index) {
    return _options.indexWhere((element) => element.value.position == index) ==
        -1;
  }

  bool checkCorrectAnswer() {
    for (final Rx<Option> element in _options) {
      if (int.parse(element.value.order) != element.value.position + 1) {
        return false;
      }
    }
    return true;
  }

  void cancelRelation(int index) async {
    final int idx =
    _options.indexWhere((element) => element.value.position == index);
    if (idx == -1) return;
    _isCompleted.value = false;
    _options[idx](options[idx].value.copyWith(position: -1));
    LibFunction.effectExit();
  }

  void onSubmit() async {
    if (Get.isDialogOpen!) return;
    final isCorrect = checkCorrectAnswer();
    final List<String> result = [];
    _options.asMap().forEach((index, value) {
      if (value.value.position != -1) {
        result.add(
            "$index-${index + 1}|${value.value.position}-${(value.value.position + 3) + 1}");
      }
    });

    final isFinalQuestion = questionController.isFinalQuestion();

    if (isCorrect) {
      LibFunction.effectTrueAnswer();
    } else {
      LibFunction.effectWrongAnswer();
    }
    await Future.delayed(const Duration(milliseconds: 200));
    Get.dialog(
        DialogSingleQuestion(
            type: isCorrect ? TypeSingleDialog.success : TypeSingleDialog.failed,
            onNext: () {
              quizUseCases.submitQuestion(
                readingId: readingId,
                questionId: question.questionId,
                isCorrect: isCorrect,
                attempt: question.attempt,
                duration: questionController.getTimeDoingQuizFromStorage(),
                isCompleted: isFinalQuestion,
                data: {
                  "question_answer[${question.questionId}]": result.join(','),
                },
              );

              questionController.updateCheckCorrectAnswer(questionController.questionIndex, isCorrect);
              nextQuestion();
            },
            onReTry: (){},
            onClose: (){})
    );

    //
    // if (isCorrect) {
    //   LibFunction.effectTrueAnswer();
    // } else {
    //   LibFunction.effectWrongAnswer();
    // }
    // Get.dialog(
    //   DialogNotiQuestion(
    //     type: isCorrect ? TypeDialog.success : TypeDialog.failed,
    //     onNext: () {
    //       quizUseCases.submitQuestion(
    //         readingId: readingId,
    //         questionId: question.questionId,
    //         isCorrect: isCorrect,
    //         attempt: question.attempt,
    //         data: {
    //           "question_answer[${question.questionId}]": result.join(','),
    //         },
    //       );
    //       nextQuestion();
    //     },
    //     onReTry: () {
    //       initData();
    //     },
    //     onClose: () {},
    //   ),
    //   barrierDismissible: false,
    //   barrierColor: null,
    // );
  }
}
