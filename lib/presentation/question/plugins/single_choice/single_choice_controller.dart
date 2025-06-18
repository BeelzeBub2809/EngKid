import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_noti_question.dart';
import 'package:EngKid/widgets/dialog/dialog_single_question.dart';

class SingleChoiceController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final int readingId;
  final QuestionController questionController;

  SingleChoiceController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.readingId,
    required this.questionController
  });

  final List<Rx<Option>> _options = List<Rx<Option>>.empty(growable: true);
  final RxBool _isCompleted = false.obs;

  List<Rx<Option>> get options => _options;
  bool get isCompleted => _isCompleted.value;

  late bool isSingleChoiceImage = true;

  final List<String> pathChecked = [
    LocalImage.aChecked,
    LocalImage.bChecked,
    LocalImage.cChecked,
    LocalImage.dChecked,
  ];
  final List<String> pathUnChecked = [
    LocalImage.a,
    LocalImage.b,
    LocalImage.c,
    LocalImage.d,
  ];

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
          isSingleChoiceImage = false;
        }
        return e.obs;
      }).toList(),
    );
  }

  void handleCheckedRadioButton(int index) async {
    final int indexChecked =
    _options.indexWhere((element) => element.value.isChecked == true);
    if (indexChecked != -1) {
      _options[indexChecked](
          options[indexChecked].value.copyWith(isChecked: false));
    }
    _options[index](options[index].value.copyWith(isChecked: true));
    LibFunction.effectConfirmPop();
    _isCompleted.value = true;
    questionController.stopReadingQuestion();
  }

  bool checkCorrectAnswer() {
    final Rx<Option>? option =
    _options.firstWhereOrNull((element) => element.value.isChecked == true);
    if (option == null) {
      return false;
    } else {
      return option.value.isCorrect == "1";
    }
  }

  void onSubmit() async {
    if (Get.isDialogOpen!) return;
    final Rx<Option>? option =
    _options.firstWhereOrNull((element) => element.value.isChecked == true);
    final isCorrect = checkCorrectAnswer();
    final isFinalQuestion = questionController.isFinalQuestion();

    if (isCorrect) {
      LibFunction.effectTrueAnswer();
    } else {
      LibFunction.effectWrongAnswer();
    }
    await Future.delayed(const Duration(milliseconds: 200));
    await Get.dialog(
        DialogSingleQuestion(
            type: isCorrect ? TypeSingleDialog.success : TypeSingleDialog.failed,
            onNext: () async {
              questionController.updateCheckCorrectAnswer(questionController.questionIndex, isCorrect);
              //wait for 100 miliseconds
              questionController.onNextBtnPress();
              quizUseCases.submitQuestion(
                readingId: readingId,
                questionId: question.questionId,
                isCorrect: isCorrect,
                attempt: question.attempt,
                duration: questionController.doQuizDuration,
                isCompleted: isFinalQuestion,
                data: {
                  "question_answer[${question.questionId}]":
                  "${option == null ? "" : option.value.optionId}",
                },
              );
            },
            onReTry: (){},
            onClose: (){})
    );
  }
}
