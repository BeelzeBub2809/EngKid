import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_svg/svg.dart';
import 'package:EngKid/utils/im_utils.dart';
import 'package:EngKid/utils/images.dart';
import 'package:EngKid/utils/lib_function.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// * A widget that displays an image from a URL, caching it locally.
/// Supports SVG and other image formats.
class CacheImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final dynamic boxFit;
  const CacheImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final futureFile = LibFunction.getSingleFile(url);
    // final List<String> fileType = url.split('.');

    // switch (fileType[fileType.length - 1]) {
    //   case 'svg':
    //     if (!kIsWeb) {
    //       return FutureBuilder<File>(
    //         future: futureFile,
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             return SvgPicture.file(
    //               snapshot.data!,
    //               width: width,
    //               height: height,
    //             );
    //           }
    //           return const SizedBox();
    //         },
    //       );
    //     }
    //     return FutureBuilder<File>(
    //       future: futureFile,
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return Image.file(
    //             snapshot.data!,
    //             width: width,
    //             height: height,
    //             fit: BoxFit.cover,
    //           );
    //         }
    //         return const SizedBox();
    //       },
    //     );
    //   default:
    if (IMUtils.isSvg(url)) {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        placeholderBuilder: (context) => const CircularProgressIndicator(),
      );
    }
    // else {
    //   return FadeInImage.assetNetwork(
    //     width: width,
    //     height: height,
    //     image: url,
    //     placeholder: LocalImage.loginBg,
    //     imageErrorBuilder: (context, url, error) {
    //       return Image.asset(
    //         LocalImage.loginBg,
    //         width: width,
    //         height: height,
    //       );
    //     },
    //     fit: boxFit,
    //   );
    // }
    return FutureBuilder<File>(
      future: futureFile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.file(
            snapshot.data!,
            width: width,
            height: height,
            fit: boxFit,
          );
        }
        return const SizedBox();
      },
    );
    //   }
  }
}

bool isSvg(String url) {
  return url.toLowerCase().endsWith(".svg");
}
