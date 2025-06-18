import 'package:get/get.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/domain/quiz/quiz_usecases.dart';
import 'package:EngKid/presentation/question/question_controller.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/dialog/dialog_noti_question.dart';

import '../../../../widgets/dialog/dialog_single_question.dart';


class MatchedController extends GetxController {
  final Question question;
  final QuizUseCases quizUseCases;
  final void Function() nextQuestion;
  final int readingId;
  final QuestionController questionController;

  MatchedController({
    required this.nextQuestion,
    required this.question,
    required this.quizUseCases,
    required this.readingId,
    required this.questionController
  });

  late int maxLength = 0;
  late bool isMatchingImage = true;

  final RxBool _isLongA = false.obs;
  final RxBool _isLongB = false.obs;
  final RxBool _isLong = false.obs;
  final RxBool _isCompleted = false.obs;

  final List<Rx<Option>> optionsA = List<Rx<Option>>.empty(growable: true);
  final List<Rx<Option>> optionsB = List<Rx<Option>>.empty(growable: true);

  bool get isLongA => _isLongA.value;
  bool get isLongB => _isLongB.value;
  bool get isLong => _isLong.value;
  bool get isCompleted => _isCompleted.value;
  @override
  void onInit() {
    super.onInit();
    initData();
    questionController.readQuestion(question,null);
  }

  void initData() {
    optionsA.assignAll([]);
    optionsB.assignAll([]);
    _isCompleted.value = false;
    final List<Option> tmp1 = [];
    question.options
        .where((element) => element.optionType == 'question')
        .toList()
        .asMap()
        .forEach((index, value) {
      if (value.image == "") {
        isMatchingImage = false;
      }
      final Option tmp =
      value.copyWith(position: index, positionOriginal: index + 1);
      tmp1.add(tmp);
    });
    optionsA.assignAll(List<Option>.from(LibFunction.shuffle(tmp1)).map(
          (e) => e.obs,
    ));
    final List<Option> tmp2 = [];
    question.options
        .where((element) => element.optionType == 'answer')
        .toList()
        .asMap()
        .forEach((index, value) {
      final Option tmp = value.copyWith(
        position: index,
        positionOriginal: index +
            1 +
            question.options
                .where((element) => element.optionType == 'question')
                .toList()
                .length,
      );
      tmp2.add(tmp);
    });

    optionsB.assignAll(List<Option>.from(LibFunction.shuffle(tmp2)).map(
          (e) => e.obs,
    ));
    if (optionsA.length > optionsB.length) {
      maxLength = optionsA.length;
      List.generate(maxLength - optionsB.length, (index) {
        optionsB.add(Option(position: optionsB.length + index).obs);
      });
    } else {
      maxLength = optionsB.length;
      List.generate(maxLength - optionsA.length, (index) {
        optionsA.add(Option(position: optionsA.length + index).obs);
      });
    }
    optionsA;
    optionsB;

    optionsA.every((element) {
      if (element.value.option.length >= 10) {
        // _isLongA.value = true;
        _isLong.value = true;
        return false;
      }
      return true;
    });
    optionsB.every((element) {
      if (element.value.option.length >= 10) {
        // _isLongB.value = true;
        _isLong.value = true;
        return false;
      }
      return true;
    });

    // _isLongA.value = true;
    // _isLongB.value = true;
    // _isLong.value = true;
  }

  void onCorrect({required Option dataA, required Option dataB}) async {
    final int indexA = optionsA
        .indexWhere((element) => element.value.optionId == dataA.optionId);
    final int indexB = optionsB
        .indexWhere((element) => element.value.optionId == dataB.optionId);
    if (indexA == -1 || indexB == -1) return;
    optionsA[indexA](optionsA[indexB].value);
    optionsA[indexB](dataA.copyWith(isChecked: true));
    optionsB[indexB](optionsB[indexB].value.copyWith(isChecked: true));
    LibFunction.effectTrueAnswer();
    _isCompleted.value = true;
  }

  void cancelRelation(int index) async {
    await LibFunction.effectExit();
    optionsA[index](optionsA[index].value.copyWith(isChecked: false));
    optionsB[index](optionsB[index].value.copyWith(isChecked: false));
  }

  void onSubmit() async {
    if (Get.isDialogOpen!) return;
    final List<Rx<Option>> ltsOptionChecked =
    optionsA.toList();

    if (ltsOptionChecked.isEmpty) {
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

    final List<String> result = [];
    ltsOptionChecked.asMap().forEach((index, value) {
      if (value.value.optionId != -1 && value.value.isChecked) {
        result.add(
            "${value.value.position}-${value.value.positionOriginal}|${optionsB[index].value.position}-${optionsB[index].value.positionOriginal}");
      }
    });
    result.sort((a, b){
      final answerA = a.split("-");
      final answerB = b.split("-");
      return int.parse(answerA[0]) - int.parse(answerB[0]);
    });
    final ltsCurrectConnection = question.currectConnection.split(",");
    ltsCurrectConnection
        .removeWhere((item) => ["", null, false].contains(item));
    ltsCurrectConnection.sort((a, b) {
      final answerA = a.split("-");
      final answerB = b.split("-");
      return int.parse(answerA[0]) - int.parse(answerB[0]);
    });

    final bool isCorrect = result.join(',') == ltsCurrectConnection.join(',');

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
