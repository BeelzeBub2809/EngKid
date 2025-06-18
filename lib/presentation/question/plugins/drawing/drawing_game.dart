import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:EngKid/utils/gamelibfunction.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

import 'drawing_controller.dart';

class DrawingConst {
  static const maxHistory = 15;
  static const pencilChoose = 0;
  static const brushChoose = 1;
  static const painChoose = 2;
  static const eraserChoose = 3;

  static Color eraserColor = Colors.white;

  static double pencilBrushSize = 3;
  static double brushBrushSize = 6;
  static double eraserBrushSize = 6;

  static double similarBoundary = 0.3;
}

class DrawBoard extends PositionComponent with Tappable, Draggable {
  late bool isPainting = false;
  //late double imgScale = 0.8;
  List<Vector2> listLine = <Vector2>[];
  late Color colorLine;
  late DrawingGame gameDraw;
  late PictureRecorder recorder;
  late Canvas curCanvas;
  late double brushSize = DrawingConst.pencilBrushSize;
  Paint defaultPaint = Paint();
  bool isNeedSave = false;

  late ByteData imageData;

  late Vector2 sizeToScreen;

  DrawBoard(widthSize, heightSize, pos, gDraw) : super() {
    // width = widthSize * imgScale;
    // height = heightSize * imgScale;
    sizeToScreen = Vector2(widthSize, heightSize);
    width = 1365;
    height = 768;
    scale = Vector2(sizeToScreen.x / width, sizeToScreen.y / height);
    position = pos - sizeToScreen / 2;
    gameDraw = gDraw;
    colorLine = gameDraw.currentColor;
  }

  Future<void> saveCurrentImage() async {
    isNeedSave = false;
    isPainting = false;
    curCanvas = Canvas(PictureRecorder(),
        Rect.fromPoints(const Offset(0, 0), Offset(width, height)));

    Image image = await recorder
        .endRecording()
        .toImage(size.x.toInt(), size.y.toInt())
        .then((image) => image.resize(Vector2(width, height)));
    // print(image.toByteData(format: ImageByteFormat.png).toString());
    // gameDraw.currentImage = await recorder
    //     .endRecording()
    //     .toImage(size.x.toInt(), size.y.toInt())
    //     .then((image) => image.resize(Vector2(width, height)));

    gameDraw.currentImage = image;

    //await saveToFile(image);
    // gameDraw.currentImage = await recorder.endRecording().toImage(
    //     (size.x * window.devicePixelRatio).floor(),
    //     (size.y * window.devicePixelRatio).floor()).then((image) => image.resize(Vector2(width, height)));

    gameDraw.history.add(gameDraw.currentImage);
    if (gameDraw.history.length > DrawingConst.maxHistory) {
      gameDraw.history.removeAt(0);
    }
    listLine = <Vector2>[];
    // print('init canvas');
    // print(image);
    initCanvas();
  }

  Future<void> saveToFile(Image curImg) async {
    var pngBytes = (await curImg
        .toByteData(format: ImageByteFormat.png)
        .then((value) => value?.buffer.asUint8List()))!;
    final result = await ImageGallerySaver.saveImage(pngBytes,
        quality: 60, name: "EOS_Drawing", isReturnImagePathOfIOS: false);
    // final result = await ImageGallerySaver.saveFile(sprite.toString(),
    //     name: "${appDocDir.path}/img.png", isReturnPathOfIOS: false);
    if (result["isSuccess"]) {
      LibFunction.toast("save_success");
    }
  }

  void initCanvas() {
    recorder = PictureRecorder();
    final Rect rect =
        Rect.fromPoints(const Offset(0, 0), Offset(width, height));
    curCanvas = Canvas(recorder, rect);
    curCanvas.drawCircle(Offset.infinite, 2, Paint());
    // print(curCanvas.isBlank);
    // curCanvas.scale(1 * window.devicePixelRatio);
  }

  @override
  Future<void> onLoad() async {
    initCanvas();
    await saveCurrentImage();
    isNeedSave = true; //init save
  }

  @override
  void update(double dt) {
    // ignore: unnecessary_null_comparison
    if (recorder == null) {
      initCanvas();
    }
    render(curCanvas);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) async {
    canvas.drawRect(Rect.fromPoints(const Offset(0, 0), Offset(width, height)),
        BasicPalette.white.paint());
    // ignore: unnecessary_null_comparison
    if (gameDraw.currentImage != null) {
      canvas.drawImage(gameDraw.currentImage, const Offset(0, 0), defaultPaint);
    }
    // if (mapLine.isNotEmpty) {
    //   mapLine.forEach((key, value) {
    //     final paint = Paint()
    //       ..strokeWidth = brushSize
    //       ..color = value
    //       ..style = PaintingStyle.stroke;
    //     final line = Path();
    //     if (key.isNotEmpty) {
    //       line.moveTo(key[0].x, key[0].y);
    //       canvas.drawCircle(Offset(key[0].x, key[0].y), brushSize / 2,
    //           Paint()..color = value);
    //       Vector2 relativePos = key[0];
    //       for (var i = 1; i < key.length; i++) {
    //         // canvas.drawCircle(
    //         //     Offset(listLine[i].x - position.x, listLine[i].y - position.y),
    //         //     2,
    //         //     BasicPalette.red.paint());
    //         line.relativeLineTo(
    //             key[i].x - relativePos.x, key[i].y - relativePos.y);
    //         relativePos = key[i];
    //       }
    //       canvas.drawPath(line, paint);
    //     }
    //   });
    // }
    if (listLine.isNotEmpty) {
      final paint = Paint()
        ..strokeWidth = brushSize / scale.y
        ..color = colorLine
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(listLine[0].x, listLine[0].y);
      canvas.drawCircle(Offset(listLine[0].x, listLine[0].y),
          brushSize / 2 / scale.y, Paint()..color = colorLine);
      Vector2 relativePos = listLine[0];
      for (var i = 1; i < listLine.length; i++) {
        // canvas.drawCircle(
        //     Offset(listLine[i].x - position.x, listLine[i].y - position.y),
        //     2,
        //     BasicPalette.red.paint());
        path.relativeLineTo(
            listLine[i].x - relativePos.x, listLine[i].y - relativePos.y);
        relativePos = listLine[i];
      }
      canvas.drawPath(path, paint);
    }
    if (canvas == curCanvas && isNeedSave) {
      await saveCurrentImage();
    }
    super.render(canvas);
  }

  Color getPixelColor(
    ByteData rgbaImageData,
    int imageWidth,
    int imageHeight,
    int x,
    int y,
  ) {
    final byteOffset = x * 4 + y * imageWidth * 4;

    final r = rgbaImageData.getUint8(byteOffset);
    final g = rgbaImageData.getUint8(byteOffset + 1);
    final b = rgbaImageData.getUint8(byteOffset + 2);
    final a = rgbaImageData.getUint8(byteOffset + 3);
    return Color.fromARGB(a, r, g, b);
  }

  void setPixelColor(
    ByteData rgbaImageData,
    int imageWidth,
    int imageHeight,
    int x,
    int y,
    Color color,
  ) {
    final byteOffset = x * 4 + y * imageWidth * 4;

    final r = color.red;
    final g = color.green;
    final b = color.blue;
    final a = color.alpha;
    rgbaImageData.setUint8(byteOffset, r);
    rgbaImageData.setUint8(byteOffset + 1, g);
    rgbaImageData.setUint8(byteOffset + 2, b);
    rgbaImageData.setUint8(byteOffset + 3, a);
  }

  void spanFill(int x, int y, Color replacementColor) {
    final stack = <List<int>>[];

    stack.add([x, y]);

    final filterColor =
        getPixelColor(imageData, width.toInt(), height.toInt(), x, y);

    if (filterColor == replacementColor) {
      return;
    }
    var colorSimilar = colorSimilarCalculate(filterColor, replacementColor);

    while (stack.isNotEmpty) {
      final pixel = stack.removeLast();
      final px = pixel[0];
      final py = pixel[1];

      final color =
          getPixelColor(imageData, width.toInt(), height.toInt(), px, py);

      if (color == filterColor) {
        setPixelColor(
            imageData, width.toInt(), height.toInt(), px, py, replacementColor);

        if (px > 0) {
          stack.add([px - 1, py]);
        }

        if (px < width.toInt() - 1) {
          stack.add([px + 1, py]);
        }

        if (py > 0) {
          stack.add([px, py - 1]);
        }

        if (py < height.toInt() - 1) {
          stack.add([px, py + 1]);
        }
      } else {
        var similarCal = colorSimilarCalculate(filterColor, color);
        if (similarCal < colorSimilar / 2 &&
            similarCal < DrawingConst.similarBoundary) {
          setPixelColor(imageData, width.toInt(), height.toInt(), px, py,
              replacementColor);

          if (px > 0) {
            stack.add([px - 1, py]);
          }

          if (px < width.toInt() - 1) {
            stack.add([px + 1, py]);
          }

          if (py > 0) {
            stack.add([px, py - 1]);
          }

          if (py < height.toInt() - 1) {
            stack.add([px, py + 1]);
          }
        }
      }
    }
  }

  double colorSimilarCalculate(Color a, Color b) {
    // int aValue = a.value + 1;
    // int bValue = b.value + 1;
    //
    // return ((aValue.toDouble() - bValue) / (aValue + bValue)).abs();
    double disR = ((a.red - b.red) * (a.red - b.red)) /
        ((a.red + b.red) * (a.red + b.red) + 1);
    double disG = ((a.green - b.green) * (a.green - b.green)) /
        ((a.green + b.green) * (a.green + b.green) + 1);
    double disB = ((a.blue - b.blue) * (a.blue - b.blue)) /
        ((a.blue + b.blue) * (a.blue + b.blue) + 1);
    return disR + disG + disB;
  }

  Vector2 gameCorToLocal(Vector2 game) {
    final x = position[0];
    final y = position[1];

    final lX = game[0] - x;
    final lY = game[1] - y;
    return Vector2(lX, lY);
  }

  Future<void> paintColorToImage(Vector2 gameVector) async {
    Color currentColor = gameDraw.currentColor;
    final local = gameCorToLocal(gameVector);

    final int x = local[0].toInt();
    final int y = local[1].toInt();
    // addHistory();
    spanFill(x, y, currentColor);
    decodeImageFromPixels(
      imageData.buffer.asUint8List(),
      width.toInt(),
      height.toInt(),
      PixelFormat.rgba8888,
      (Image result) async {
        gameDraw.currentImage = result;
        isPainting = false;
        isNeedSave = true;
      },
    );
  }

  Future<void> paintColor(Vector2 position) async {
    imageData = (await gameDraw.currentImage.toByteData())!;
    isPainting = true;
    await paintColorToImage(position);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (isPainting) {
      LibFunction.toast("waiting");
    } else {
      listLine = <Vector2>[];
      colorLine = gameDraw.currentColor;

      Vector2 tapPos = Vector2(info.eventPosition.game.x / scale.x,
          info.eventPosition.game.y / scale.y);
      if (gameDraw.currentTool != DrawingConst.painChoose) {
        savePosition(tapPos);
      }
      switch (gameDraw.currentTool) {
        case DrawingConst.pencilChoose:
          brushSize = DrawingConst.pencilBrushSize;
          break;
        case DrawingConst.brushChoose:
          brushSize = DrawingConst.brushBrushSize;
          break;
        case DrawingConst.painChoose:
          //Paint choose color to range
          paintColor(tapPos);
          break;
        case DrawingConst.eraserChoose:
          brushSize = DrawingConst.eraserBrushSize;
          colorLine = DrawingConst.eraserColor;
          break;
        default:
          break;
      }
      if (gameDraw.currentTool != DrawingConst.eraserChoose) {
        colorLine = gameDraw.currentColor;
      } else {}
    }
    return super.onTapDown(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (gameDraw.currentTool != DrawingConst.painChoose) {
      isNeedSave = true;
    }
    return super.onTapUp(info);
  }

  @override
  bool onDragStart(DragStartInfo info) {
    // curCanvas.restore();
    return super.onDragStart(info);
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (gameDraw.currentTool != DrawingConst.painChoose) {
      Vector2 tapPos = Vector2(info.eventPosition.game.x / scale.x,
          info.eventPosition.game.y / scale.y);
      savePosition(tapPos);
    }

    return super.onDragUpdate(info);
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    isNeedSave = true;
    return super.onDragEnd(info);
  }

  void savePosition(Vector2 gameVector) {
    Vector2 currentPosition = gameVector - position;
    if (currentPosition.x >= 0 &&
        currentPosition.x <= width &&
        currentPosition.y >= 0 &&
        currentPosition.y <= height) {
      listLine.add(currentPosition);
    }
  }
}

class BaseButton extends SpriteComponent with Tappable {
  late DrawingGame gameDraw;
  late Sprite svgImg;
  late Vector2 imgSize;
  late Vector2 imgPos;

  Function onTapEvent;
  BaseButton(
      {required this.gameDraw,
      required this.svgImg,
      required this.imgSize,
      required this.imgPos,
      required this.onTapEvent})
      : super() {
    sprite = svgImg;
    position = imgPos;
    anchor = Anchor.center;
    size = imgSize;
    gameDraw.add(this);
  }
  @override
  bool onTapDown(TapDownInfo info) {
    onTapEvent();
    return super.onTapDown(info);
  }
}

class ChooseBrush extends SvgComponent with Tappable {
  late DrawingGame gameDraw;
  late Svg svgImg;
  late double imgSize;
  late Vector2 imgPos;
  late Color curColor;
  // late Paint colorPaint;
  late int chooseIndex;

  late Vector2 deltaSelectPos;
  late Vector2 brushBeginnerPos;

  late SvgComponent background;
  late bool isHavingBackground = false;

  Function onTapEvent;
  late bool isBeingChoose = true;
  ChooseBrush(
      {required this.gameDraw,
      required this.svgImg,
      Svg? svgBackground,
      required this.imgSize,
      required this.imgPos,
      required this.curColor,
      required this.chooseIndex,
      required this.deltaSelectPos,
      required this.brushBeginnerPos,
      required this.onTapEvent})
      : super() {
    svg = svgImg;
    position = imgPos + brushBeginnerPos;
    anchor = Anchor.centerLeft;
    size = svgImg.pictureInfo.size.toVector2();
    scale = Vector2(imgSize, imgSize) * 1.2;

    if (svgBackground != null) {
      background = SvgComponent(
          svg: svgBackground,
          size: svgBackground.pictureInfo.size.toVector2(),
          scale: Vector2(imgSize, imgSize) * 1.2,
          position: imgPos + brushBeginnerPos,
          anchor: Anchor.centerLeft);
      background.tint(curColor);
      gameDraw.add(background);
      isHavingBackground = true;
    }
    //opacity = 0.5;
    // colorPaint = Paint()
    //   ..color = curColor
    //   ..style = PaintingStyle.fill;
    gameDraw.add(this);

    unchooseThisRender();
  }

  void setBackground(Color color) {
    if (isHavingBackground) {
      background.tint(color);
    }
  }

  // @override
  // void render(Canvas canvas) {

  //   final width = size.x;
  //   final height = size.y;
  //   Rect rect = Rect.fromCenter(center: Offset(width/2, height/2), width: width, height: height);
  //   canvas.drawRect(rect, colorPaint);
  //   super.render(canvas);
  // }

  @override
  bool onTapDown(TapDownInfo info) {
    onTapEvent();
    return super.onTapDown(info);
  }

  chooseThisRender() {
    if (isBeingChoose) return;
    scale *= 1.5;
    opacity = 1;
    position -= deltaSelectPos;
    if (isHavingBackground) {
      background.scale *= 1.5;
      background.opacity = 1;
      background.position -= deltaSelectPos;
    }
    isBeingChoose = true;
  }

  unchooseThisRender() {
    if (!isBeingChoose) return;
    scale /= 1.5;
    opacity = 0.5;
    position += deltaSelectPos;
    if (isHavingBackground) {
      background.scale /= 1.5;
      background.opacity = 0.4;
      background.position += deltaSelectPos;
    }
    isBeingChoose = false;
  }
}

class TheColorCircle extends CircleComponent with Tappable {
  late DrawingGame gameDraw;
  late Color color;
  late double cirRad;
  late Vector2 cirPos;

  late bool canBeChange;

  TheColorCircle(
      {required this.gameDraw,
      required this.color,
      required this.cirRad,
      required this.cirPos,
      required this.canBeChange})
      : super() {
    radius = cirRad;
    position = cirPos;
    anchor = Anchor.center;
    paint = BasicPalette.red.paint()..style = PaintingStyle.fill;
    paint.color = color;

    gameDraw.add(this);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (canBeChange) {
      gameDraw.changeCurrentColor(color);
    }
    return super.onTapDown(info);
  }

  void setImageColor(Color color) {
    this.color = color;
    paint.color = color;
  }
}

class DrawingGame extends FlameGame with HasDraggables, HasTappables {
  final SpriteComponent handCursor = SpriteComponent();

  late final List<TheColorCircle> colorTable = <TheColorCircle>[];
  late final List<ChooseBrush> drawingStuffs = <ChooseBrush>[];
  late int currentTool = DrawingConst.pencilChoose;
  late List<Vector2> wordPosList = <Vector2>[];

  //=========== Drawing image ================
  // late ImageDraw imageDraw;
  late DrawingController controller;
  bool isComplete = false;

  late DrawBoard drawBroad;

  //============ Choose and drag Color =================
  late TheColorCircle currentColorHolder;
  Color currentColor = const Color.fromARGB(255, 28, 33, 194);
  late Image currentImage;
  List<Image> history = <Image>[];

  late double widthSize;
  late double heightSize;

  @override
  Future<void> onLoad() async {
    // Sprite img = Spri;
    // currentImage = await img.toImage();
    //================= Warning log ====================
    add(SpriteComponent()
      ..sprite = await loadSprite(LocalImage.drawingGameBg)
      ..size = size);

    //=========== UI_ColorTable ==============
    //--------------Background-------------
    double pencilcaseSizeScale = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 1.05);
    double pencilcaseSizePos = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 180);
    SpriteComponent pencilcase = SpriteComponent()
      ..sprite = await loadSprite(LocalImage.pencilcase)
      ..scale = Vector2(-pencilcaseSizeScale, pencilcaseSizeScale)
      ..anchor = Anchor.centerRight
      ..position = Vector2(size.x - pencilcaseSizePos, size.y / 2);
    add(pencilcase);
    //-----------Color Holder-------------
    double brushImgSize = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 0.8);
    double colorSize = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 50);
    double colorMargin = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 60);
    Vector2 brushSelectPos = GameLibFunction.scaleForCurrentVector2(
        size, GameLibFunction.designScreen, Vector2(80, 0));
    Vector2 brushBeginnerPos = GameLibFunction.scaleForCurrentVector2(
        size, GameLibFunction.designScreen, Vector2(-20, 0));
    double marginRight = size.x - colorMargin;

    double y = -3;
    TheColorCircle(
        gameDraw: this,
        color: const Color.fromARGB(255, 200, 153, 24),
        cirRad: colorSize * 1.2,
        cirPos: Vector2(
            marginRight, size.y / 2 + (colorSize * 1.2 + colorMargin) * y),
        canBeChange: false);
    currentColorHolder = TheColorCircle(
        gameDraw: this,
        color: currentColor,
        cirRad: colorSize * 1,
        cirPos: Vector2(
            marginRight, size.y / 2 + (colorSize * 1.2 + colorMargin) * y),
        canBeChange: true);

    y++;
    var pencil = ChooseBrush(
        gameDraw: this,
        curColor: currentColor,
        svgImg: await loadSvg(LocalImage.coloringPencilImg),
        svgBackground: await loadSvg(LocalImage.coloringPencilBg),
        imgPos: Vector2(marginRight - colorSize * 2,
            size.y / 2 + (colorSize + colorMargin) * y),
        imgSize: brushImgSize,
        chooseIndex: DrawingConst.pencilChoose,
        deltaSelectPos: brushSelectPos,
        brushBeginnerPos: brushBeginnerPos,
        onTapEvent: () async {
          changeTool(DrawingConst.pencilChoose);
          LibFunction.effectConfirmPop();
        });
    drawingStuffs.add(pencil);
    changeTool(DrawingConst.pencilChoose);
    y++;
    var brush = ChooseBrush(
        gameDraw: this,
        chooseIndex: DrawingConst.brushChoose,
        svgImg: await loadSvg(LocalImage.coloringColorBrushImg),
        svgBackground: await loadSvg(LocalImage.coloringColorBrushBg),
        curColor: currentColor,
        imgPos: Vector2(marginRight - colorSize * 2,
            size.y / 2 + (colorSize + colorMargin) * y),
        imgSize: brushImgSize,
        deltaSelectPos: brushSelectPos,
        brushBeginnerPos: brushBeginnerPos,
        onTapEvent: () async {
          LibFunction.effectConfirmPop();
          changeTool(DrawingConst.brushChoose);
        });
    drawingStuffs.add(brush);
    y++;

    var paint = ChooseBrush(
        gameDraw: this,
        chooseIndex: DrawingConst.painChoose,
        svgImg: await loadSvg(LocalImage.paintboxImg),
        svgBackground: await loadSvg(LocalImage.paintboxBg),
        curColor: currentColor,
        imgPos: Vector2(marginRight - colorSize * 2,
            size.y / 2 + (colorSize + colorMargin) * y),
        imgSize: brushImgSize * 1 / 2,
        deltaSelectPos: brushSelectPos,
        brushBeginnerPos: brushBeginnerPos,
        onTapEvent: () async {
          LibFunction.effectConfirmPop();
          changeTool(DrawingConst.painChoose);
        });
    drawingStuffs.add(paint);
    y++;
    var eraser = ChooseBrush(
        gameDraw: this,
        chooseIndex: DrawingConst.eraserChoose,
        svgImg: await loadSvg(LocalImage.coloringEraser),
        curColor: currentColor,
        imgPos: Vector2(marginRight - colorSize * 2,
            size.y / 2 + (colorSize + colorMargin) * y),
        imgSize: brushImgSize * 2 / 3,
        deltaSelectPos: brushSelectPos,
        brushBeginnerPos: brushBeginnerPos,
        onTapEvent: () async {
          LibFunction.effectConfirmPop();
          changeTool(DrawingConst.eraserChoose);
        });
    drawingStuffs.add(eraser);
    y++;

    BaseButton(
        gameDraw: this,
        svgImg: await loadSprite(LocalImage.coloringColorWheel),
        imgPos:
            Vector2(marginRight, size.y / 2 + (colorSize + colorMargin) * y),
        imgSize: Vector2(colorSize, colorSize) * 2,
        onTapEvent: () {
          controller.openColorPicker();
        });
    controller.pickColorEvent = (color) => {changeCurrentColor(color)};

    //====== Other UI ============
    Vector2 btnSize = GameLibFunction.scaleForCurrentVector2(
        size, GameLibFunction.designScreen, Vector2(100, 100));
    double btnMarginLeft = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 120);
    double btnDistance = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 20);
    double btnMarginBottom = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 100);

    BaseButton(
        gameDraw: this,
        svgImg: await loadSprite(LocalImage.coloringDone),
        imgPos: Vector2(btnMarginLeft,
            size.y - btnMarginBottom - (btnDistance + btnSize.y)),
        imgSize: btnSize,
        onTapEvent: () async {
          controller.nextQuestion();
        });
    BaseButton(
        gameDraw: this,
        svgImg: await loadSprite(LocalImage.coloringTakingPicture),
        imgPos: Vector2(btnMarginLeft,
            size.y - btnMarginBottom - (btnDistance + btnSize.y) * 2),
        imgSize: btnSize,
        onTapEvent: () async {
          LibFunction.effectConfirmPop();
          LibFunction.toast("save_success");
          saveToFile();
        });
    BaseButton(
        gameDraw: this,
        svgImg: await loadSprite(LocalImage.coloringUndo),
        imgPos: Vector2(btnMarginLeft,
            size.y - btnMarginBottom - (btnDistance + btnSize.y) * 3),
        imgSize: btnSize,
        onTapEvent: () async {
          LibFunction.effectConfirmPop();
          undoHistory();
        });
    //====== End Other UI ===========

    widthSize = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 1920 * 0.8);
    heightSize = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 1080 * 0.8);
    drawBroad =
        DrawBoard(widthSize, heightSize, Vector2(size.x, size.y) / 2, this);
    add(drawBroad);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }

  void changeCurrentColor(Color color) {
    currentColor = color;
    currentColorHolder.setImageColor(color);
    for (var ds in drawingStuffs) {
      ds.setBackground(currentColor);
    }
  }

  void changeTool(newTool) {
    if (currentTool >= 0) {
      drawingStuffs[currentTool].unchooseThisRender();
    }
    currentTool = newTool;
    drawingStuffs[newTool].chooseThisRender();
  }

  void undoHistory() {
    if (history.length > 1) {
      history.removeLast();
      currentImage = history[history.length - 1];
      // drawBroad.render(drawBroad.curCanvas);
    }
  }

  Future<void> saveToFile() async {
    Image curImg = currentImage;
    var pngBytes = (await curImg
        .toByteData(format: ImageByteFormat.png)
        .then((value) => value?.buffer.asUint8List()))!;
    // print(base64Encode(pngBytes));
    if(kIsWeb){
      // Convert the Uint8List to a Blob
      final blob = html.Blob([pngBytes]);

      // Create an object URL from the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create a download link and trigger it
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Drawing.png")
        ..click();

      // Revoke the object URL after the download
      Future.delayed(const Duration(seconds: 1), () {
        html.Url.revokeObjectUrl(url);
      });

      LibFunction.toast("save_success");
    }else{
      final result = await ImageGallerySaver.saveImage(pngBytes,
          quality: 60, name: "Drawing", isReturnImagePathOfIOS: false);
      if (result["isSuccess"]) {
        LibFunction.toast("save_success");
      }
    }
    // final result = await ImageGallerySaver.saveFile(sprite.toString(),
    //     name: "${appDocDir.path}/img.png", isReturnPathOfIOS: false);

  }
}
