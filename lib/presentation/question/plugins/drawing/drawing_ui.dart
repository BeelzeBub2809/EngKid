import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/widgets/text/image_text.dart';
import 'drawing_controller.dart';
import 'drawing_game.dart';

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final drawing = DrawingGame();
    final controller = Get.find<DrawingController>();
    controller.contextDialog = context;
    drawing.controller = controller;
    return Obx(
      () => controller.isStarted
          ? Stack(
              children: [
                GameWidget(
                  game: drawing,
                ),
                // Back button positioned at top-left for game screen
                Positioned(
                  top: 0.05 * size.height,
                  left: 0.02 * size.width,
                  child: ImageText(
                    text: 'back',
                    pathImage: LocalImage.shapeButton,
                    isUpperCase: true,
                    onTap: () {
                      controller.onPressBack();
                    },
                    width: 0.12 * size.width,
                    height: 0.08 * size.height,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(LocalImage.drawingBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Back button positioned at top-left
                Positioned(
                  top: 0.05 * size.height,
                  left: 0.02 * size.width,
                  child: ImageText(
                    text: 'back',
                    pathImage: LocalImage.shapeButton,
                    isUpperCase: true,
                    onTap: () {
                      controller.onPressBack();
                    },
                    width: 0.12 * size.width,
                    height: 0.08 * size.height,
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
                              controller.onPressStartDrawing();
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
