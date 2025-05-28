import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: avoid_classes_with_only_static_members
class Fontsize {
  static double smallest = kIsWeb ? 3.sp : 8.sp;
  static double small = kIsWeb ? 6.sp : 11.sp;
  static double smaller = kIsWeb ? 5.sp : 10.sp;
  static double normal = kIsWeb ? 7.sp : 12.sp;
  static double larger = kIsWeb ? 9.sp : 14.sp;
  static double large = kIsWeb ? 11.sp : 16.sp;
  static double huge = kIsWeb ? 13.sp : 18.sp;
  static double bigger = kIsWeb ? 15.sp : 20.sp;
  static double biggest = kIsWeb ? 17.sp : 22.sp;
}
