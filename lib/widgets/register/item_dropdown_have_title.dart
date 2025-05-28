import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EngKid/utils/font_size.dart';

import '../../utils/app_color.dart';

/// A custom dropdown widget with a title and validation message.
///  This widget allows users to select an item from a dropdown list and displays a title above the dropdown.
class ItemDropdownHaveTitle extends StatelessWidget {
  final List<dynamic> items;
  final Map<String, dynamic>? selectedItem;
  final Function(Map<String, dynamic>?) onChanged;
  final double width;
  final String title;
  final bool isEdit;
  final bool? isRegister;
  final String? validateValue;

  const ItemDropdownHaveTitle({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.width,
    required this.title,
    this.isEdit = false,
    this.isRegister = false,
    this.validateValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tìm item được chọn trong danh sách items
    final selectedIndex =
        items.indexWhere((item) => item['id'] == selectedItem?['id']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: Get.height * 0.02),
          child: Text(
            title.tr,
            style: TextStyle(
                fontSize: isRegister == true ? Fontsize.normal : 15,
                fontStyle:
                    isRegister == true ? FontStyle.normal : FontStyle.italic,
                fontWeight:
                    isRegister == true ? FontWeight.w500 : FontWeight.w400),
          ),
        ),
        Container(
          width: width,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(top: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: selectedIndex >= 0 ? selectedIndex : null,
              onChanged: isEdit
                  ? (int? index) {
                      if (index != null && index >= 0 && index < items.length) {
                        onChanged(items[index]);
                      }
                    }
                  : null,
              icon: isEdit
                  ? const Icon(Icons.arrow_drop_down_circle, color: Colors.red)
                  : const Icon(Icons.arrow_drop_down_circle,
                      color: Colors.grey),
              dropdownColor: Colors.white,
              hint: Text(
                title.toUpperCase(),
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
                  ),
                );
              }),
            ),
          ),
        ),
        if (validateValue != null && validateValue!.isNotEmpty)
          Text(validateValue!.tr,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColor.red))
      ],
    );
  }
}
