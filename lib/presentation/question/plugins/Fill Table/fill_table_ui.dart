import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/shape/shape_quiz.dart';
import 'package:EngKid/domain/quiz/entities/question/question.dart';
import 'fill_table_controller.dart';

class FillTableScreen extends StatefulWidget {
  const FillTableScreen({super.key});

  @override
  _FillTableScreenState createState() => _FillTableScreenState();
}

class _FillTableScreenState extends State<FillTableScreen> {
  final controller = Get.find<FillTableController>();
  final List<TableRow> _rows = [];
  int rowNumber = 0;

  @override
  void initState() {
    super.initState();
    // Add the header row initially
    _rows.add(_buildTableRowHeader(controller.question.childQuestion));
    if(controller.isHasImage){
      _rows.add(_buildTableRowImage(controller.question.childQuestion));
    }
  }

  TableRow _buildTableRow(String hint, List<Question> questions) {
    return TableRow(
      children: questions.asMap().entries.map((entry) {
        final columnIndex = entry.key; // Index of the current column
        final question = entry.value; // The question object

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              controller.onChangeInput(
                rowIndex: rowNumber, // Pass the row index dynamically
                columnIndex: columnIndex, // Current column index
                input: value, // The input value
              );
            },
          ),
        );
      }).toList()
    );
  }

  TableRow _buildTableRowHeader(List<Question> questions) {
    return TableRow(
      children: questions.map((entry) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            entry.question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildTableRowImage(List<Question> questions) {
  return TableRow(
    children: questions.map((entry) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: entry.image1 != ''
            ? GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final Size size = MediaQuery.of(context).size;
                      return Dialog(
                        child: CacheImage(
                          url: entry.image1,
                          width: 0.6 * size.width,
                          height: 0.6 * size.height,
                          boxFit: BoxFit.contain,
                        ),
                      );
                    },
                  );
                },
                child: Builder(
                  builder: (context) {
                    final Size size = MediaQuery.of(context).size;
                    return CacheImage(
                      url: entry.image1,
                      width: 0.1 * size.width,
                      height: 0.1 * size.height,
                      boxFit: BoxFit.contain,
                    );
                  },
                ),
              )
            : const SizedBox(),
      );
    }).toList(),
  );
}

  void _addNewRow() {
    setState(() {
      _rows.add(_buildTableRow(
        'enter_answer'.tr,
        controller.question.childQuestion,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

      return Obx(() =>Stack(
        children: [
          ShapeQuiz(
            content: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0), // Left and right margin
                  child: Table(
                    border: TableBorder.all(color: Colors.grey), // Optional border
                    children: _rows,
                  ),
                ),
              ],
            ),
            onSubmit: () {
              controller.onSubmitPress();
            },
            quiz: controller.question.question,
            bg: controller.question.background,
            sub: 'Em hãy ấn vào dấu + màu đỏ và điền câu trả lời vào ô trống',
            level: controller.question.level,
            isCompleted: controller.isCompleted,
            question: controller.question,
          ),
          Positioned(
            // top: 0.35 * size.height + 60*(_rows.length-1)>0.8*size.height?0.8*size.height:0.35 * size.height + 60*(_rows.length-1),
            top: 0.35 *size.height,
            left: 0.1855 * size.width,
            child: FloatingActionButton(
              onPressed: _addNewRow,
              backgroundColor: Colors.red,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ));
  }
}
