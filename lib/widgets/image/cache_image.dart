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

    // If it's an SVG
    if (IMUtils.isSvg(url)) {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        placeholderBuilder: (context) => const CircularProgressIndicator(),
        fit: boxFit,
      );
    } else {
      print("CacheImage: $url");
      return FadeInImage.assetNetwork(
        width: width,
        height: height,
        image: url,
        placeholder: LocalImage.backgroundBlue,
        imageErrorBuilder: (context, url, error) {
          return Image.asset(
            LocalImage.backgroundBlue,
            width: width,
            height: height,
          );
        },
        fit: boxFit,
      );
    }
  }
}

bool isSvg(String url) {
  return url.toLowerCase().endsWith(".svg");
}
