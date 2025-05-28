import 'package:flutter/material.dart';
import 'package:EzLish/utils/app_color.dart';
import 'package:get/get.dart';

import '../../utils/font_size.dart';
import 'item_bottom_sheet_model.dart';

class CommonWidget {
  CommonWidget._();
  static bottomSheet(List<ItemBottomSheetModel> data, Function? function,
      BuildContext context) {
    return showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  function!(index);
                },
                child: IntrinsicHeight(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: _itemBottomSheet(
                        title: data[index].title ?? '',
                        url: data[index].iconUrl,
                        icon: data[index].icon),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Widget _itemBottomSheet({String? title, String? url, IconData? icon}) {
    return Row(
      children: [
        Container(
            alignment: Alignment.center,
            height: 30,
            width: 30,
            padding: EdgeInsets.all(url != null ? 0 : 7),
            decoration: const BoxDecoration(
                color: AppColor.blue, shape: BoxShape.circle),
            child: url != null
                ? Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  )
                : ClipRRect(
                    child: Image.asset(
                      url ?? '',
                      fit: BoxFit.cover,
                    ),
                  )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            title?.tr ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: const Icon(
              Icons.navigate_next_rounded,
              size: 22,
              color: Colors.black,
            )),
      ],
    );
  }

  static Future<T?> dialog<T>({
    required Widget body,
    String? id,
    bool? barrierDismissible,
    String? message,
    Widget? bottom,
  }) {
    return Get.dialog<T>(
      TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.5, end: 1.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastEaseInToSlowEaseOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
              ),
              child: Center(
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7)),
                  padding: const EdgeInsets.all(15),
                  child: IntrinsicHeight(
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              message?.tr ?? 'Thông báo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Fontsize.larger,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          body,
                          const SizedBox(height: 10),
                          bottom ?? const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible ?? true,
    );
  }

  static Widget textFieldWithTitle(
      {required String title,
      required Widget child,
      bool isValidate = false,
      String? validateNotify,
      double horizontal = 5,
      bool? isRegister = false,
      double vertical = 0}) {
    bool isError =
        (validateNotify == '' || validateNotify == null) ? false : true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * 0.02),
        Text(title,
            style: TextStyle(
                fontSize: isRegister == true ? Fontsize.normal : 15,
                fontStyle:
                    isRegister == true ? FontStyle.normal : FontStyle.italic,
                fontWeight:
                    isRegister == true ? FontWeight.w500 : FontWeight.w400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(
          height: 5,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                  color:
                      isValidate ? AppColor.red : Colors.grey.withOpacity(0.1),
                  width: 1)),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontal, vertical: vertical),
              child: child),
        ),
        Visibility(
          visible: isError,
          child: const SizedBox(
            height: 5,
          ),
        ),
        Visibility(
            visible: isError,
            child: Text(validateNotify?.tr ?? '',
                style: const TextStyle(fontSize: 12, color: AppColor.red)))
      ],
    );
  }
}
