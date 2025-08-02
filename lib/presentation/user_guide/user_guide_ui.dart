import 'dart:async';
import 'dart:io';
import 'package:EngKid/presentation/user_guide/user_guide_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/font_size.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:EngKid/widgets/button/image_button.dart';
import 'package:EngKid/widgets/loading/loading_dialog.dart';
import 'package:EngKid/utils/images.dart';

class UserGuideUI extends GetView<UserGuideController> {
  UserGuideUI({super.key});
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final pixelRatio = View.of(context).devicePixelRatio;
    final logicalScreenSize = View.of(context).physicalSize / pixelRatio;
    final logicalWidth = logicalScreenSize.width;
    final logicalHeight = logicalScreenSize.height;
    final paddingLeft =
        View.of(context).padding.left / View.of(context).devicePixelRatio;
    final paddingRight =
        View.of(context).padding.right / View.of(context).devicePixelRatio;
    final paddingTop =
        View.of(context).padding.top / View.of(context).devicePixelRatio;
    final paddingBottom =
        View.of(context).padding.bottom / View.of(context).devicePixelRatio;

    final safeWidth = logicalWidth - paddingLeft - paddingRight;
    final safeHeight = logicalHeight - paddingTop - paddingBottom;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(LocalImage.messageBg),
                fit: BoxFit.fill,
              ),
            ),
            width: safeWidth,
            height: safeHeight,
            child: Center(
              child: Obx(() => controller.isLoading
                  ? LoadingDialog(
                      sizeIndi: 0.2 * size.width,
                      color: AppColor.blue,
                      des: "",
                    )
                  : Container(
                      width: 0.8 * safeWidth,
                      height: 0.8 * safeWidth / controller.ratio,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: PDFView(
                        filePath: controller.corruptedPathPDF,
                        enableSwipe: true,
                        swipeHorizontal: false,
                        autoSpacing: false,
                        pageFling: false,
                        pageSnap: true,
                        defaultPage: 0,
                        fitPolicy: FitPolicy.WIDTH,
                        preventLinkNavigation: false,
                        backgroundColor: Colors.grey.shade200,
                        onRender: (int? pages) {
                          print("=== PDF RENDER EVENT ===");
                          print("Pages rendered: $pages");
                          print("File path: ${controller.corruptedPathPDF}");
                          controller.totalPage = pages ?? 0;
                          controller.setPdfReady();
                          print(
                              "PDF rendered successfully with ${pages} pages");
                          print("=== PDF RENDER COMPLETE ===");
                        },
                        onError: (error) {
                          print("=== PDF ERROR EVENT ===");
                          print("PDF Error: $error");
                          print("File path: ${controller.corruptedPathPDF}");
                          print(
                              "File exists: ${File(controller.corruptedPathPDF).existsSync()}");
                          print("=== PDF ERROR END ===");
                        },
                        onPageError: (page, error) {
                          print("=== PDF PAGE ERROR EVENT ===");
                          print("Page $page Error: $error");
                          print("=== PDF PAGE ERROR END ===");
                        },
                        onViewCreated: (PDFViewController pdfViewController) {
                          _controller.complete(pdfViewController);
                        },
                        onLinkHandler: (String? uri) {
                          // debugPrint('goto uri: $uri');
                        },
                        onPageChanged: (int? page, int? total) {
                          controller.currentPage = page ?? 0;
                        },
                      ),
                    )),
            ),
          ),

          // Page indicator
          Positioned.fill(
            bottom: 8,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(
                    Radius.circular(LibFunction.scaleForCurrentValue(size, 60)),
                  ),
                ),
                child: Obx(() => Text(
                      '${controller.currentPage + 1}/${controller.totalPage}',
                      style: TextStyle(
                        fontSize: Fontsize.small,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )),
              ),
            ),
          ),

          // Back button
          Positioned.fill(
            top: 0.02 * size.width,
            left: 0.02 * size.width,
            child: Align(
              alignment: Alignment.topLeft,
              child: ImageButton(
                onTap: () => Get.back(),
                semantics: 'back',
                pathImage: LocalImage.backNoShadow,
                height: 0.05 * size.width,
                width: 0.05 * size.width,
              ),
            ),
          ),

          // Previous page button
          FutureBuilder<PDFViewController>(
            future: _controller.future,
            builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
              if (snapshot.hasData) {
                return Positioned.fill(
                  left: 0.01 * size.width,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ImageButton(
                      onTap: () async {
                        final int currentPage =
                            (await snapshot.data!.getCurrentPage()) ?? 0;
                        if (currentPage > 0) {
                          await snapshot.data!.setPage(currentPage - 1);
                        }
                      },
                      semantics: 'previous',
                      pathImage: LocalImage.swiperBack,
                      height: 0.05 * size.width,
                      width: 0.05 * size.width,
                    ),
                  ),
                );
              }
              return Container();
            },
          ),

          // Next page button
          FutureBuilder<PDFViewController>(
            future: _controller.future,
            builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
              if (snapshot.hasData) {
                return Positioned.fill(
                  right: 0.01 * size.width,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ImageButton(
                      onTap: () async {
                        final int currentPage =
                            (await snapshot.data!.getCurrentPage()) ?? 0;
                        if (currentPage < (controller.totalPage - 1)) {
                          await snapshot.data!.setPage(currentPage + 1);
                        }
                      },
                      semantics: 'next',
                      pathImage: LocalImage.swiperNext,
                      height: 0.05 * size.width,
                      width: 0.05 * size.width,
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
