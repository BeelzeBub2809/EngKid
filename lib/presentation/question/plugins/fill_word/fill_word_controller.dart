import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_noti_question.dart';

import '../../../../widgets/dialog/dialog_single_question.dart';

class FillWordController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final int readingId;
  final QuestionController questionController;

  FillWordController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.readingId,
    required this.questionController
  });

  late bool isMulti = true;
  late bool isLong = false;
  final RxBool _isCompleted = false.obs;
  RxList<Option> questions = RxList<Option>.empty(growable: true);
  RxList<Option> answers = RxList<Option>.empty(growable: true);

  bool get isCompleted => _isCompleted.value;

  @override
  void onInit() {
    super.onInit();
    initData();
    questionController.readQuestion(question,null);
  }

  void initData() {
    questions.assignAll([]);
    answers.assignAll([]);
    _isCompleted.value = false;
    if (question.options
        .where((element) => element.optionType == 'question')
        .toList()
        .length >
        1) {
      List<String> groups = question.currectConnection.split(',');
      List<String> pairs = [];
      for (String group in groups) {
        pairs.addAll(group.split('|'));
      }
      List<String> uniquePairs = pairs.toSet().toList();
      if(uniquePairs.length == pairs.length){
        isMulti = false;
      }
    }

    question.options
        .where((el) => el.optionType == "question")
        .toList()
        .asMap()
        .forEach((index, value) {
      if (value.option.length > 5 && !isLong) {
        isLong = true;
      }

      questions
          .add(value.copyWith(position: index, positionOriginal: 1 + index));
      if (index <
          question.options
              .where((el) => el.optionType == "answer")
              .toList()
              .length) {
        questions.add(const Option(optionType: "answer"));
      }
    });
    final List<Option> tmp = [];
    question.options
        .where((el) => el.optionType == "answer")
        .toList()
        .asMap()
        .forEach((index, value) {
      if (value.option.length > 5 && !isLong) {
        isLong = true;
      }
      tmp.add(value.copyWith(
          position: index,
          positionOriginal: question.options
              .where((el) => el.optionType == "question")
              .toList()
              .length +
              1 +
              index));
    });
    answers.assignAll(RxList<Option>.from(LibFunction.shuffle(tmp)));

    print('test drag and drop');
    print(questions);
  }

  void onCorrect(int optionId, int idx) async {
    final int index =
    answers.indexWhere((element) => element.optionId == optionId);
    if (isMulti) {
      final index1 =
      answers.indexWhere((element) => element.optionId == optionId);
      answers[index1] = answers[index1].copyWith(isChecked: true);
      // List<int> temp = questions[idx].checkedAnswer;
      List<int> temp = List.from(questions[idx].checkedAnswer);
      if (!temp.contains(optionId)) {
        temp.add(optionId);
      }
      // temp.assign(optionId);
      questions[idx] = questions[idx].copyWith(checkedAnswer: temp);
      // print(temp);
    } else {
      if (index != -1) {
        if (questions[idx].optionId != -1) {
          final int indexUnChecked = answers.indexWhere(
                  (element) => element.optionId == questions[idx].optionId);
          if (indexUnChecked != -1) {
            answers[indexUnChecked] =
                answers[indexUnChecked].copyWith(isChecked: false);
          }
        }
        answers[index] = answers[index].copyWith(isChecked: true);
        questions[idx] = (answers[index].copyWith(isChecked: true));
      }
    }
    _isCompleted.value = true;
    await LibFunction.effectTrueAnswer();
  }

  void cancelRelation(int optionId,int idx) async {
    if (optionId == -1) return;
    if (!isMulti) {
      final int index1 =
      questions.indexWhere((element) => element.optionId == optionId);
      final int index2 =
      answers.indexWhere((element) => element.optionId == optionId);
      questions[index1] = const Option(optionType: "answer");
      answers[index2] = answers[index2].copyWith(isChecked: false);
    } else {
      final index =
      answers.indexWhere((element) => element.optionId == optionId);
      answers[index] = answers[index].copyWith(isChecked: false);
      List<int> temp = List.from(questions[idx].checkedAnswer);
      if (temp.contains(optionId)) {
        temp.remove(optionId);
      }
      // temp.assign(optionId);
      questions[idx] = questions[idx].copyWith(checkedAnswer: temp);
    }
    LibFunction.effectExit();
  }

  Future<void> onSubmit() async {
    if (Get.isDialogOpen!) return;
    final List<String> result = [];
    final List<Option> tmp = answers.where((p0) => p0.isChecked).toList();

    if (tmp.isEmpty) {
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

    tmp.sort((a, b) => a.positionOriginal - b.positionOriginal);
    if (!isMulti) {
      questions.asMap().forEach((index, value) {
        if (value.optionType == "answer" &&
            value.isChecked &&
            value.optionId != -1) {
          result.add(
              "${questions[index - 1].position}-${questions[index - 1].positionOriginal}|${value.position}-${value.positionOriginal}");
        }
      });
    } else {
      // tmp.asMap().forEach((index, value) {
      //   if (value.optionId != -1) {
      //     result.add("0-1|${value.position}-${value.positionOriginal}");
      //   }
      // });

      questions.asMap().forEach((index, value) {
        if (value.optionType == "question" &&
            value.optionId != -1){
          List<int> temp = List.from(value.checkedAnswer);
          temp.sort((a, b) => a - b);
          temp.asMap().forEach((key, answerId) {
            final answerIndex = answers.indexWhere((element) => element.optionId == answerId);
            final answer = answers[answerIndex];
            result.add("${value.position}-${value.positionOriginal}|${answer.position}-${answer.positionOriginal}");
          });
        }
      });
    }

    final ltsCurrectConnection = question.currectConnection.split(",");
    ltsCurrectConnection
        .removeWhere((item) => ["", null, false].contains(item));
    ltsCurrectConnection.sort((a, b) {
      final partsA = a.split('|');
      final partsB = b.split('|');

      final resultBefore = partsA[0].compareTo(partsB[0]);
      if (resultBefore != 0) {
        return resultBefore;
      }

      return partsA[1].compareTo(partsB[1]);
    });
    // print(ltsCurrectConnection);
    final bool isCorrect = result.join(',') == ltsCurrectConnection.join(",");

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
