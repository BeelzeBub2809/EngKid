class Choice {
  final int value;
  final String label;
  String pathChecked;
  String pathUnChecked;
  bool isChecked;

  Choice({
    required this.value,
    required this.label,
    this.pathChecked = '',
    this.pathUnChecked = '',
    this.isChecked = false,
  });
}

class SurveyChoice {
  final List<Choice> choices;
  final String name;
  final int success;
  final String quiz;
  String explains;
  String groupQuizName;
  int choosen;
  SurveyChoice({
    required this.choices,
    required this.name,
    required this.success,
    required this.quiz,
    required this.choosen,
    this.explains = '',
    this.groupQuizName = '',
  });
}

class GroupQuiz {
  final String name;
  final List<SurveyChoice> surveyChoices;
  GroupQuiz({
    required this.name,
    required this.surveyChoices,
  });
}
