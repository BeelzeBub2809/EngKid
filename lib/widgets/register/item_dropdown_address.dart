import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import '../../utils/font_size.dart';

/// A custom dropdown widget for selecting addresses.
/// This widget displays a title, a dropdown menu with address options, and handles selection changes.
class ItemDropdownAddress extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final Map<String, dynamic>? selectedItem;
  final Function(Map<String, dynamic>?) onChanged;
  final double width;
  final bool? isAddChild;
  final String? validateValue;

  const ItemDropdownAddress({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.width,
    this.isAddChild,
    this.validateValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = items.indexWhere((item) =>
    item['id'] == selectedItem?['id'] && item['name'] == selectedItem?['name']);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:  EdgeInsets.only(top :isAddChild == true ? Get.height * 0.05 : 0 ),
          child: Text(
            title.tr,
            style: TextStyle(
              fontSize: Fontsize.larger,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox( width : isAddChild == true ? Get.height * 0.1 : 0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: selectedIndex >= 0 ? selectedIndex : null,

                  onChanged: (int? index) {
                    if (index != null && index >= 0 && index < items.length) {
                      onChanged(items[index]);
                    }
                  },
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.red),
                  hint: Text(
                    title.tr.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: List.generate(items.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        items[index]['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            if(validateValue != null && validateValue!.isNotEmpty)
              SizedBox(height: Get.height * 0.02),

            if(validateValue != null && validateValue!.isNotEmpty)
              Text(validateValue!.tr,style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColor.red))
          ],
        ),

      ],
    );
  }
}