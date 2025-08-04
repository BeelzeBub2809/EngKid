import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:EngKid/domain/core/app_usecases.dart';

class UserGuideController extends GetxController {
  final AppUseCases appUseCases;
  UserGuideController({
    required this.appUseCases,
  });
  // final UserService _userService = Get.find<UserService>();
  // late PdfControllerPinch pdfControllerPinch;

  // final int _initialPage = 1;
  final RxBool _isLoading = true.obs;
  final RxBool _isPdfReady = false.obs;
  final RxBool _isRendering = false.obs;
  final RxBool _isShowControl = true.obs;
  final RxDouble _ratio = (16 / 9).obs;
  final RxString _corruptedPathPDF = "".obs;
  final RxInt _totalPage = 0.obs;
  final RxInt _currentPage = 0.obs;

  bool get isLoading => _isLoading.value;
  bool get isPdfReady => _isPdfReady.value;
  bool get isRendering => _isRendering.value;
  bool get isShowControl => _isShowControl.value;
  double get ratio => _ratio.value;
  Timer? t;
  String get corruptedPathPDF => _corruptedPathPDF.value;
  int get totalPage => _totalPage.value;
  int get currentPage => _currentPage.value;

  set totalPage(int value) {
    _totalPage.value = value;
  }

  set currentPage(int value) {
    _currentPage.value = value;
  }

  void setPdfReady() {
    _isPdfReady.value = true;
    _isRendering.value = false;
  }

  void startRendering() {
    _isRendering.value = true;
  }

  @override
  void onInit() {
    initPdf();
    super.onInit();
  }

  Future<void> initPdf() async {
    try {
      _isLoading.value = true;
      final bool? isPhuHuynh = Get.arguments;
      print("Loading PDF for isPhuHuynh: $isPhuHuynh");

      final f = await fromAsset(
          isPhuHuynh == true
              ? "assets/pdfs/user_guide_parent.pdf"
              : "assets/pdfs/user_guide_student.pdf",
          isPhuHuynh == true
              ? "user_guide_parent.pdf"
              : "user_guide_student.pdf");

      print("PDF file path: ${f.path}");
      print("PDF file exists: ${await f.exists()}");
      print("PDF file size: ${await f.length()} bytes");

      _corruptedPathPDF.value = f.path;
      _isLoading.value = false;
    } catch (e) {
      print("Error loading PDF: $e");
      _isLoading.value = false;
    }
  }

  void screenPress() {
    if (t?.isActive ?? false) t?.cancel();
    _isShowControl.value = true;
    t = Timer(
      const Duration(seconds: 2),
      () {
        t = null;
        _isShowControl.value = false;
      },
    );
  }

  Future<File> fromAsset(String asset, String filename) async {
    try {
      print("Loading asset: $asset");
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      // Check if file already exists and delete it to ensure fresh copy
      if (await file.exists()) {
        await file.delete();
      }

      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      print("Asset size: ${bytes.length} bytes");

      await file.writeAsBytes(bytes, flush: true);

      // Verify the file was written correctly
      if (await file.exists()) {
        print("File written successfully to: ${file.path}");
        print("File size on disk: ${await file.length()} bytes");
      } else {
        throw Exception('File was not written to disk');
      }

      return file;
    } catch (e) {
      print("Error in fromAsset: $e");
      throw Exception('Error parsing asset file: $e');
    }
  }

  @override
  void dispose() {
    // pdfControllerPinch.dispose();
    super.dispose();
  }
}
