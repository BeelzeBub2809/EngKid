import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:EngKid/utils/gamelibfunction.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'coloring_controller.dart';

class CharacterConst {
  static const int kernSpace = 0;
}

class BaseButton extends SpriteComponent with Tappable {
  late Coloring gameTC;
  late Sprite svgImg;
  late Vector2 imgSize;
  late Vector2 imgPos;

  Function onTapEvent;
  BaseButton(
      {required this.gameTC,
      required this.svgImg,
      required this.imgSize,
      required this.imgPos,
      required this.onTapEvent})
      : super() {
    sprite = svgImg;
    position = imgPos;
    anchor = Anchor.center;
    size = imgSize;
    gameTC.add(this);
  }
  @override
  bool onTapDown(TapDownInfo info) {
    onTapEvent();
    return super.onTapDown(info);
  }
}

class TheColorCircle extends CircleComponent with Tappable {
  late Coloring gameTC;
  late Color color;
  late double cirRad;
  late Vector2 cirPos;

  late bool canBeChange;

  TheColorCircle(
      {required this.gameTC,
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

    gameTC.add(this);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (canBeChange) {
      gameTC.changeCurrentColor(color);
    }
    return super.onTapDown(info);
  }

  void setImageColor(Color color) {
    this.color = color;
    paint.color = color;
  }
}

class ImageDraw extends SpriteComponent with Tappable, Draggable {
  late Coloring gameTC;
  late Sprite spriteHold;
  late Vector2 spriteSize;
  late Vector2 spritePos;

  late int imgWidth;
  late int imgHeight;

  late ByteData imageData;
  late ByteData layerImageData;

  late List<Sprite> imgHistory;

  Color transperent = const Color.fromARGB(0, 0, 0, 0);
  ImageDraw(
      {required this.gameTC,
      required this.spriteHold,
      required this.spriteSize,
      required this.spritePos})
      : super() {
    imgWidth = spriteHold.image.width;
    imgHeight = spriteHold.image.height;

    size.x = imgWidth * spriteSize.x;
    size.y = imgHeight * spriteSize.y;
    position = Vector2(spritePos.x - imgWidth * spriteSize.x / 2,
        spritePos.y - imgHeight * spriteSize.y / 2);

    sprite = spriteHold;
    gameTC.add(this);
  }
  @override
  Future<void>? onLoad() async {
    imageData = (await sprite?.image.toByteData())!;
    layerImageData = ByteData.view(imageData.buffer);
    imgHistory = <Sprite>[];
    return super.onLoad();
  }

  bool isInside(x, y) {
    if ((x < 0 || x >= imgWidth || y < 0 || y >= imgHeight)) {
      return false;
    }
    final color = getPixelColor(layerImageData, imgWidth, imgHeight, x, y);
    if (color == transperent || color == const Color.fromARGB(255, 0, 0, 0)) {
      return false;
    }
    return true;
  }

  void paintColorToImage(Vector2 gameVector) {
    Color currentColor = gameTC.currentColor;
    final local = gameCorToLocal(gameVector);
    // var offset = Offset(local[0], local[1]);
    final int x = local[0] ~/ spriteSize.x;
    final int y = local[1] ~/ spriteSize.y;
    addHistory();
    spanFill(x, y, currentColor);
    decodeImageFromPixels(
      imageData.buffer.asUint8List(),
      imgWidth,
      imgHeight,
      PixelFormat.rgba8888,
      (Image result) async {
        sprite = Sprite(result);
      },
    );
  }

  void spanFill(int x, int y, Color replacementColor) {
    final stack = <List<int>>[];
    stack.add([x, y]);
    while (stack.isNotEmpty) {
      final pixel = stack.removeLast();
      final px = pixel[0];
      final py = pixel[1];
      final color = getPixelColor(imageData, imgWidth, imgHeight, px, py);
      final colorLayer =
          getPixelColor(layerImageData, imgWidth, imgHeight, px, py);
      if (color != replacementColor) {
        if (colorLayer.red > 60 ||
            colorLayer.blue > 60 ||
            colorLayer.green > 60) {
          setPixelColor(
              imageData, imgWidth, imgHeight, px, py, replacementColor);

          if (px > 0) {
            stack.add([px - 1, py]);
          }

          if (px < imgWidth - 1) {
            stack.add([px + 1, py]);
          }

          if (py > 0) {
            stack.add([px, py - 1]);
          }

          if (py < imgHeight - 1) {
            stack.add([px, py + 1]);
          }
        }
      }
    }
  }

  Color addColor(Color color1, double size1, Color color2, double size2) {
    double sum = size1 + size2;
    int a = ((color1.alpha * size1 + color2.alpha * size2) / sum).floor();
    int r = ((color1.red * size1 + color2.red * size2) / sum).floor();
    int g = ((color1.green * size1 + color2.green * size2) / sum).floor();
    int b = ((color1.blue * size1 + color2.blue * size2) / sum).floor();
    return Color.fromARGB(r, g, b, a);
  }

  void addHistory() {
    int historyLength = 15;
    while (imgHistory.length > historyLength - 1) {
      imgHistory.removeAt(0);
    }
    imgHistory.add(sprite as Sprite);
  }

  Future<void> undoImg() async {
    if (imgHistory.isNotEmpty) {
      Sprite history = imgHistory.removeLast();
      sprite = history;
      imageData = (await (sprite?.image.toByteData()))!;
    }
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    undoImg();
    return super.onDragEnd(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    Vector2 tapPos = info.eventPosition.game;
    paintColorToImage(tapPos);
    return super.onTapUp(info);
  }

  Vector2 gameCorToLocal(Vector2 game) {
    final x = position[0];
    final y = position[1];

    final lX = game[0] - x;
    final lY = game[1] - y;
    return Vector2(lX, lY);
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

  Future<void> saveSpriteToFile() async {
    // var pngBytes = (await sprite?.image
    //     .toByteData(format: ImageByteFormat.png)
    //     .then((value) => value?.buffer.asUint8List()))!;
    if (sprite == null || sprite?.image == null) {
      print("Sprite or Sprite image is null.");
      LibFunction.toast("save_failed"); // Handle error as needed
      return;
    }

    var pngBytes = (await sprite!.image
        .toByteData(format: ImageByteFormat.png)
        .then((value) => value?.buffer.asUint8List()));

    if (pngBytes == null) {
      print("Failed to convert sprite to byte data.");
      LibFunction.toast("save_failed"); // Handle error as needed
      return;
    }
    // print(base64Encode(pngBytes));
    if (kIsWeb) {
      // Convert the Uint8List to a Blob
      final blob = html.Blob([pngBytes]);

      // Create an object URL from the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create a download link and trigger it
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Coloring.png")
        ..click();

      // Revoke the object URL after the download
      Future.delayed(const Duration(seconds: 1), () {
        html.Url.revokeObjectUrl(url);
      });

      LibFunction.toast("save_success");
    } else {
      final result = await ImageGallerySaver.saveImage(pngBytes,
          quality: 60, name: "Coloring", isReturnImagePathOfIOS: false);
      if (result["isSuccess"]) {
        LibFunction.toast("save_success");
      }
    }
    // final result = await ImageGallerySaver.saveFile(sprite.toString(),
    //     name: "${appDocDir.path}/img.png", isReturnPathOfIOS: false);
  }
}

class Coloring extends FlameGame with HasDraggables, HasTappables {
  final SpriteComponent handCursor = SpriteComponent();

  late final List<TheColorCircle> colorTable = <TheColorCircle>[];
  late List<Vector2> wordPosList = <Vector2>[];

  //=========== Drawing image ================
  late ImageDraw imageDraw;
  late ColoringController controller;
  bool isComplete = false;

  //============ Choose and drag Color =================
  late TheColorCircle currentColorHolder;
  late Color currentColor;
  @override
  Future<void> onLoad() async {
    //================= Warning log ====================
    add(SpriteComponent()
      ..sprite = await loadSprite(LocalImage.coloringGameBg)
      ..size = size);

    // if (totalCharWidth > size[0] * 0.8) {
    //   scale = size[0] * 0.8 / totalCharWidth;
    // }
//============ Drawing Image ================
    double imageSize = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 0.8);
    // double imageLeftMargin = GameLibFunction.scaleForCurrentValue(
    //     size, GameLibFunction.designScreen, 180);
    // final drawingSize = size * imageSize;
    imageDraw = ImageDraw(
        gameTC: this,
        spriteHold: await loadSprite(controller.coloringUrl),
        spriteSize: Vector2(imageSize, imageSize),
        spritePos: Vector2(size.x, size.y) / 2);

    //=========== UI_ColorTable ==============
    //-----------Color Holder-------------
    double colorSize = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 50);
    double colorMargin = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 60);
    double marginRight = size.x - colorSize - colorMargin / 2;

    double y = -3.1;
    currentColorHolder = TheColorCircle(
        gameTC: this,
        color: const Color.fromARGB(255, 28, 33, 194),
        cirRad: colorSize * 1.2,
        cirPos: Vector2(
            marginRight, size.y / 2 + (colorSize * 1.2 + colorMargin) * y),
        canBeChange: false);
    currentColor = currentColorHolder.color;
    y++;
    colorTable.add(TheColorCircle(
        gameTC: this,
        color: const Color.fromARGB(255, 28, 33, 194),
        cirRad: colorSize,
        cirPos: Vector2(
            marginRight, size.y / 2 + (colorSize * 1.2 + colorMargin) * y),
        canBeChange: true));
    y++;
    colorTable.add(TheColorCircle(
        gameTC: this,
        color: const Color.fromARGB(255, 250, 3, 194),
        cirRad: colorSize,
        cirPos: Vector2(
            marginRight, size.y / 2 + (colorSize * 1.2 + colorMargin) * y),
        canBeChange: true));
    y++;
    colorTable.add(TheColorCircle(
        gameTC: this,
        color: const Color.fromARGB(255, 28, 223, 4),
        cirRad: colorSize,
        cirPos: Vector2(
            marginRight, size.y / 2 + (colorSize * 1.2 + colorMargin) * y),
        canBeChange: true));
    y++;
    colorTable.add(TheColorCircle(
        gameTC: this,
        color: const Color.fromARGB(255, 228, 233, 194),
        cirRad: colorSize,
        cirPos: Vector2(
            marginRight, size.y / 2 + (colorSize * 1.2 + colorMargin) * y),
        canBeChange: true));
    y++;

    BaseButton(
        gameTC: this,
        svgImg: await loadSprite(LocalImage.coloringColorWheel),
        imgPos: Vector2(
            marginRight, size.y / 2 + (colorMargin * 1.2 + colorSize) * y),
        imgSize: Vector2(colorSize, colorSize) * 2,
        onTapEvent: () {
          controller.openColorPicker();
        });
    controller.pickColorEvent = (color) => {changeCurrentColor(color)};

    //====== Other UI ============
    Vector2 btnSize = GameLibFunction.scaleForCurrentVector2(
        size, GameLibFunction.designScreen, Vector2(100, 100));
    double btnMargin = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 120);
    double btnDistance = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 20);
    double btnMarginBottom = GameLibFunction.scaleForCurrentValue(
        size, GameLibFunction.designScreen, 100);

    // BaseButton(
    //     gameTC: this,
    //     svgImg: await loadSprite(LocalImage.coloringDone),
    //     imgPos: Vector2(
    //         btnMargin, size.y - btnMarginBottom - (btnDistance + btnSize.y)),
    //     imgSize: btnSize,
    //     onTapEvent: () async {
    //       controller.nextQuestion();
    //     });
    BaseButton(
        gameTC: this,
        svgImg: await loadSprite(LocalImage.coloringTakingPicture),
        imgPos: Vector2(btnMargin,
            size.y - btnMarginBottom - (btnDistance + btnSize.y) * 2),
        imgSize: btnSize,
        onTapEvent: () async {
          await LibFunction.effectConfirmPop();
          LibFunction.toast("save_success");
          imageDraw.saveSpriteToFile();
        });
    BaseButton(
        gameTC: this,
        svgImg: await loadSprite(LocalImage.coloringUndo),
        imgPos: Vector2(btnMargin,
            size.y - btnMarginBottom - (btnDistance + btnSize.y) * 3),
        imgSize: btnSize,
        onTapEvent: () async {
          await LibFunction.effectConfirmPop();
          imageDraw.undoImg();
        });

    //====== End Other UI ===========
  }

  int calculateTotalWidth(List<Sprite> lstSprite) {
    int totalWidth = 0;

    for (final sprite in lstSprite) {
      totalWidth += sprite.image.width;
      totalWidth += CharacterConst.kernSpace; //character space
    }

    return totalWidth;
  }

  List<Vector2> calculateSpritePos(
    List<Sprite> lstSpr,
    Vector2 size,
    double scale,
  ) {
    final double totalSizeX = calculateTotalWidth(lstSpr) * scale;
    final List<Vector2> result = <Vector2>[];
    double prePos = size[0] / 2 - totalSizeX / 2;
    final double centerY = size[1] / 2;
    for (int i = 0; i < lstSpr.length; i++) {
      final charWidth = lstSpr[i].image.width * scale;
      final charHeight = lstSpr[i].image.height * scale;
      final double x = prePos;
      final double y = centerY - charHeight / 2;
      result.add(Vector2(x, y));
      prePos += charWidth;
      prePos += CharacterConst.kernSpace * scale;
    }

    return result;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }

  void changeCurrentColor(Color color) {
    currentColor = color;
    currentColorHolder.setImageColor(color);
  }
}
