import 'package:flutter/material.dart';
import 'package:EngKid/domain/quiz/entities/entites.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/image/cache_image.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'package:EngKid/widgets/text/regular_text.dart';

/// A custom quiz widget for displaying shape quizzes.
/// This widget is designed to present a quiz question with images and options for the user to select.
class ShapeQuiz extends StatelessWidget {
  const ShapeQuiz({
    super.key,
    required this.quiz,
    required this.content,
    required this.onSubmit,
    this.level = "Applying",
    this.bg = '',
    this.isCompleted = false,
    this.sub = "Em có thể chọn nhiều đáp án nhé!",
    this.scrollController,
    required this.question,
  });

  final String quiz;
  final Widget content;
  final Function onSubmit;
  final String bg;
  final String sub;
  final String level;
  final bool isCompleted;
  final ScrollController? scrollController;
  final Question question;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String image_1 = question.image1;
    final String image_2 = question.image2;
    final String image_3 = question.image3;
    final String image_4 = question.image4;
    final String image_5 = question.image5;
    final String image_6 = question.image6;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: bg == ""
                ? Container(
                    width: size.width,
                    height: size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.quizBg),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : CacheImage(url: bg, width: size.width, height: size.height),
          ),
          SizedBox(
            width: size.width,
            height: size.height,
            child: Padding(
              padding: EdgeInsets.only(
                left: 0.05 * size.height,
                right: 0.05 * size.height,
                bottom: 0.05 * size.height,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.03 * size.height),
                    child: Image.asset(
                      level == "1"
                          ? LocalImage.level1
                          : level == "2"
                              ? LocalImage.level2
                              : LocalImage.level3,
                      width: 0.18 * size.width,
                      height: 0.73 * size.height,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.05 * size.height),
                        child: Container(
                          width: 0.75 * size.width,
                          height: 0.85 * size.height,
                          padding: EdgeInsets.only(top: 0.1 * size.height),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(LocalImage.shapeQuiz),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              SizedBox(
                                width: 0.6 * size.width,
                                child: RegularText(
                                  quiz,
                                  maxLines: 100,
                                  style: TextStyle(
                                    color: AppColor.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: Fontsize.large,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    size.width * 0.01,
                                    size.height * 0.01,
                                    size.width * 0.01,
                                    size.height * 0.01),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (image_1 != "")
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  final Size size =
                                                      MediaQuery.of(context)
                                                          .size;
                                                  return Dialog(
                                                    child: CacheImage(
                                                      url: image_1,
                                                      width: size.width * 0.8,
                                                      height: size.height * 0.8,
                                                      boxFit: BoxFit.contain,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: CacheImage(
                                              url: image_1,
                                              width: size.width * 0.33 * 0.7,
                                              height: size.height * 0.33 * 0.7,
                                              boxFit: BoxFit.contain,
                                            ),
                                          ),
                                        if (image_2 != "")
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    final Size size =
                                                        MediaQuery.of(context)
                                                            .size;
                                                    return Dialog(
                                                      child: CacheImage(
                                                        url: image_2,
                                                        width: size.width * 0.8,
                                                        height:
                                                            size.height * 0.8,
                                                        boxFit: BoxFit.contain,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: CacheImage(
                                                url: image_2,
                                                width: size.width * 0.33 * 0.7,
                                                height:
                                                    size.height * 0.33 * 0.7,
                                                boxFit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        if (image_3 != "")
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    final Size size =
                                                        MediaQuery.of(context)
                                                            .size;
                                                    return Dialog(
                                                      child: CacheImage(
                                                        url: image_3,
                                                        width: size.width * 0.8,
                                                        height:
                                                            size.height * 0.8,
                                                        boxFit: BoxFit.contain,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: CacheImage(
                                                url: image_3,
                                                width: size.width * 0.33 * 0.7,
                                                height:
                                                    size.height * 0.33 * 0.7,
                                                boxFit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: size.height *
                                            0.02), // Add spacing between the rows
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (image_4 != "")
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      final Size size =
                                                          MediaQuery.of(context)
                                                              .size;
                                                      return Dialog(
                                                        child: CacheImage(
                                                          url: image_4,
                                                          width:
                                                              size.width * 0.8,
                                                          height:
                                                              size.height * 0.8,
                                                          boxFit:
                                                              BoxFit.contain,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: CacheImage(
                                                  url: image_4,
                                                  width:
                                                      0.33 * size.width * 0.7,
                                                  height:
                                                      0.33 * size.height * 0.7,
                                                  boxFit: BoxFit.contain,
                                                ),
                                              )),
                                        if (image_5 != "")
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      final Size size =
                                                          MediaQuery.of(context)
                                                              .size;
                                                      return Dialog(
                                                        child: CacheImage(
                                                          url: image_5,
                                                          width: 0.8 *
                                                              size.width *
                                                              0.7,
                                                          height: 0.8 *
                                                              size.height *
                                                              0.7,
                                                          boxFit:
                                                              BoxFit.contain,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: CacheImage(
                                                  url: image_5,
                                                  width:
                                                      0.33 * size.width * 0.7,
                                                  height:
                                                      0.33 * size.height * 0.7,
                                                  boxFit: BoxFit.contain,
                                                ),
                                              )),
                                        if (image_6 != "")
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      final Size size =
                                                          MediaQuery.of(context)
                                                              .size;
                                                      return Dialog(
                                                        child: CacheImage(
                                                          url: image_5,
                                                          width:
                                                              0.8 * size.height,
                                                          height:
                                                              0.8 * size.height,
                                                          boxFit:
                                                              BoxFit.contain,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: CacheImage(
                                                  url: image_5,
                                                  width: 0.33 * size.height,
                                                  height: 0.33 * size.height,
                                                  boxFit: BoxFit.contain,
                                                ),
                                              )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                sub,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.gray,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  fontSize: Fontsize.smallest + 5,
                                ),
                              ),
                              content,
                              SizedBox(height: 0.12 * size.height),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        // top: -0.05 * size.height,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ImageText(
                            text: 'question',
                            isUpperCase: true,
                            onTap: () {},
                            pathImage: LocalImage.shapeQuizTitle,
                            width: 0.16 * size.width,
                            height: 0.14 * size.height,
                            style: TextStyle(
                                fontSize: Fontsize.huge - 1,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Positioned.fill(
                          bottom: 0.01 * size.height,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ImageText(
                              text: 'reply',
                              onTap: () async {
                                onSubmit();
                              },
                              pathImage: LocalImage.shapeQuizTitle,
                              width: 0.12 * size.width,
                              height: 0.1 * size.height,
                              style: TextStyle(
                                  fontSize: Fontsize.larger - 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
