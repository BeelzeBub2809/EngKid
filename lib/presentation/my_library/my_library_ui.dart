import 'package:EngKid/presentation/my_library/my_library_controller.dart';
import 'package:EngKid/utils/images.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLibraryScreen extends GetView<MyLibraryController>{
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImage.backgroundBlue),
                fit: BoxFit.fill,
              )
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(LocalImage.backButton),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(LocalImage.backButton),
                                fit: BoxFit.cover,
                              )
                          ),
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MY LIBRARY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF0707),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 100,
                            runSpacing: 50,
                            children: List.generate(3, (index) {
                              return GradeButton(
                                grade: index + 1,
                                onTap: () {
                                  print('Tapped Grade ${index + 1}');
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 100,
                            runSpacing: 50,
                            children: List.generate(2, (index) {
                              return GradeButton(
                                grade: index + 4,
                                onTap: () {
                                  print('Tapped Grade ${index + 3}');
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 40,
                right: 40,
                child: Container(
                  width: 150,
                  height: 190,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(LocalImage.mascotWelcome),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradeButton extends StatelessWidget {
  final int grade;
  final VoidCallback onTap;

  const GradeButton({
    super.key,
    required this.grade,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(LocalImage.gradeShape),
                  fit: BoxFit.cover,
                )
            ),
          ),
          Positioned(
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.shade700,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                'Grade $grade',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black26,
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