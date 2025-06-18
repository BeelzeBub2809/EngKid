import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_noti_question.dart';
import 'package:EngKid/widgets/dialog/dialog_single_question.dart';

class MultipleChoiceController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final int readingId;
  final QuestionController questionController;

  MultipleChoiceController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.readingId,
    required this.questionController
  });

  final RxBool _isCompleted = false.obs;
  final RxBool _isLong = false.obs;
  final RxBool _isHasCorrectAnswer = false.obs;
  final List<Rx<Option>> _options = List<Rx<Option>>.empty(growable: true);

  bool get isCompleted => _isCompleted.value;
  bool get isLong => _isLong.value;
  List<Rx<Option>> get options => _options;

  late bool isMultiChoiceImage = true;

  @override
  void onInit() {
    super.onInit();
    initData();
    questionController.readQuestion(question,_options);
  }

  void initData() {
    _isCompleted.value = false;
    _options.assignAll(
      // LibFunction.shuffle(question.options) if want to shuffle options
        List<Option>.from(question.options).map((e) {
          if (e.image == "") {
            isMultiChoiceImage = false;
          }
          if (e.option.split("\n").length - 1 > 2) {
            _isLong.value = true;
          }
          if(e.isCorrect == "1"){
            _isHasCorrectAnswer.value = true;
          }
          return e.obs;
        }).toList());
  }

  void handleCheckedCheckBox({
    required int index,
  }) async {
    _options[index](options[index]
        .value
        .copyWith(isChecked: !options[index].value.isChecked));
    LibFunction.effectTrueAnswer();
    _isCompleted.value = true;
  }

  Future<void> onSubmit() async {
    if (Get.isDialogOpen!) return;
    final List<Rx<Option>> ltsOptionChecked =
    _options.where((element) => element.value.isChecked).toList();
    if (ltsOptionChecked.isEmpty && _isHasCorrectAnswer.value) {
      LibFunction.effectWrongAnswer();
      Get.dialog(
        DialogNotiQuestion(
          type: TypeDialog.warning,
          onNext: () {},
          onReTry: () {},
          onClose: () {},
        ),
        barrierDismissible: false,
        barrierColor: null,
      );
      return;
    }
    final bool isCorrect = _options
        .where((element) =>
    element.value.isChecked && element.value.isCorrect == "1")
        .toList()
        .length ==
        question.options
            .where((element) => element.isCorrect == "1")
            .toList()
            .length &&
        _options.where((element) => element.value.isChecked).toList().length ==
            question.options
                .where((element) => element.isCorrect == "1")
                .toList()
                .length;

    final isFinalQuestion = questionController.isFinalQuestion();

    if(_isHasCorrectAnswer.value){
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
                "question_answer[${question.questionId}]": ltsOptionChecked
                    .map((e) => e.value.optionId)
                    .toList()
                    .join(","),
              },
            );
            nextQuestion();
          },
          onReTry: () {
            questionController.relearnQuestion();
          },
          onClose: () {},
        ),
        barrierDismissible: false,
        barrierColor: null,
      );
    }else{
      quizUseCases.submitQuestion(
        readingId: readingId,
        questionId: question.questionId,
        isCorrect: true,
        attempt: question.attempt,
        duration: questionController.getTimeDoingQuizFromStorage(),
        isCompleted: isFinalQuestion,
        data: {
          "question_answer[${question.questionId}]": ltsOptionChecked
              .map((e) => e.value.optionId)
              .toList()
              .join(","),
        },
      );

      questionController.updateCheckCorrectAnswer(questionController.questionIndex, isCorrect);
      nextQuestion();
    }
    //
    // if(!_isHasCorrectAnswer.value){
    //   quizUseCases.submitQuestion(
    //     readingId: readingId,
    //     questionId: question.questionId,
    //     isCorrect: true,
    //     attempt: question.attempt,
    //     data: {
    //       "question_answer[${question.questionId}]": ltsOptionChecked
    //           .map((e) => e.value.optionId)
    //           .toList()
    //           .join(","),
    //     },
    //   );
    //   nextQuestion();
    // }else{
    //   if (isCorrect) {
    //     LibFunction.effectTrueAnswer();
    //   } else {
    //     LibFunction.effectWrongAnswer();
    //   }
    //   Get.dialog(
    //     DialogNotiQuestion(
    //       type: isCorrect? TypeDialog.success : TypeDialog.failed,
    //       onNext: () {
    //         quizUseCases.submitQuestion(
    //           readingId: readingId,
    //           questionId: question.questionId,
    //           isCorrect: isCorrect||!_isHasCorrectAnswer.value,
    //           attempt: question.attempt,
    //           data: {
    //             "question_answer[${question.questionId}]": ltsOptionChecked
    //                 .map((e) => e.value.optionId)
    //                 .toList()
    //                 .join(","),
    //           },
    //         );
    //         nextQuestion();
    //       },
    //       onReTry: () {
    //         initData();
    //       },
    //       onClose: () {},
    //     ),
    //     barrierDismissible: false,
    //     barrierColor: null,
    //   );
    // }
  }
}
