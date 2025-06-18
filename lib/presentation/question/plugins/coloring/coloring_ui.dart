import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'coloring_controller.dart';
import 'coloring_game.dart';

class ColoringScreen extends StatelessWidget {
  const ColoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final coloring = Coloring();

    final controller = Get.find<ColoringController>();
    controller.contextDialog = context;
    coloring.controller = controller;
    return Obx(
      () => controller.isStarted
          ? GameWidget(
              game: coloring,
            )
          : Stack(
              children: [
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(LocalImage.coloringBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.32 * size.height),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 0.03 * size.height),
                          ImageText(
                            text: 'start',
                            pathImage: LocalImage.shapeButton,
                            isUpperCase: true,
                            onTap: () {
                              controller.onPressStartColoring();
                            },
                            width: 0.16 * size.width,
                            height: 0.14 * size.height,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
