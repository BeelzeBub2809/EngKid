import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EzLish/utils/app_color.dart';
import 'package:EzLish/utils/font_size.dart';
import 'package:EzLish/utils/images.dart';
import 'package:EzLish/utils/lib_function.dart';
import 'package:EzLish/widgets/empty/empty_data.dart';
import 'package:EzLish/widgets/select_custom/select_custom.dart';

/// A custom multiple selection widget that allows users to select multiple items from a dropdown list.
/// This widget is useful for scenarios where users need to select multiple options from a predefined list.
class SelectMultipleCustom extends StatefulWidget {
  final String placeholder;
  final double? width;
  final double? height;
  final List<SelectItem>? options;
  final Function(List<SelectItem> value)? onSelectChange;
  final List<int>? defaultValues;
  final double? dropWidth;
  final double? dropHeight;
  final String? imgBgSelect;
  final String? imgBgDropdown;
  final double? offsetX;
  final double? offsetY;
  final TextStyle? itemStyle;
  final int spaceRight;
  final bool isLoading;
  final bool isShowScrollVertical;
  final bool isRequired;

  const SelectMultipleCustom({
    super.key,
    this.placeholder = "",
    this.width,
    this.height,
    this.options,
    this.onSelectChange,
    this.defaultValues,
    this.dropWidth,
    this.dropHeight,
    this.imgBgSelect,
    this.offsetX,
    this.offsetY,
    this.itemStyle,
    this.imgBgDropdown,
    this.spaceRight = 0,
    this.isLoading = false,
    this.isShowScrollVertical = true,
    this.isRequired = false,
  });

  @override
  State<SelectMultipleCustom> createState() => _SelectMultipleCustomState();
}

class _SelectMultipleCustomState extends State<SelectMultipleCustom>
    with TickerProviderStateMixin {
  // late final AnimationController _controllerRotate = AnimationController(
  //   duration: const Duration(milliseconds: 500),
  //   vsync: this,
  // );
  late AnimationController _controllerRotate;
  late Animation<double> _turnsTweenRotate;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<SelectItem> selectedItems = [];
  List<SelectItem> oldOptions = [];

  void onSelectChange(List<SelectItem>? value) {
    if (value == null) return;
    setState(() {
      selectedItems = value;
    });

    if (widget.onSelectChange != null) {
      widget.onSelectChange!(selectedItems);
    }
  }

  bool compareOptions(List<SelectItem> newOptions) {
    if (oldOptions.isNotEmpty &&
        newOptions.isEmpty &&
        (selectedItems).isNotEmpty) {
      selectedItems = [];
    }
    late bool check = false;
    for (var element in newOptions) {
      final item =
          oldOptions.firstWhereOrNull((el) => el.value == element.value);
      if (item == null && !check) {
        check = true;
      }
    }
    oldOptions = newOptions;
    if (check) {
      if (widget.defaultValues != null) {
        final tmp = (newOptions)
            .where(
              (element) => (widget.defaultValues ?? [])
                  .map((el) => el.toString())
                  .contains(element.value),
            )
            .toList();
        selectedItems = tmp;
      }
      if (_overlayEntry != null) {
        // _rotateIcon();
        _hideTooltip();
        Future.delayed(const Duration(seconds: 0), () {
          _showTooltip();
        });
      }
    }

    return check;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    compareOptions((widget.options ?? []));
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          _rotateIcon();
          if (_overlayEntry == null) {
            _showTooltip();
          } else {
            _hideTooltip();
          }
        },
        child: Stack(children: [
          Container(
            width: widget.width ?? 0.7 * size.width,
            height: widget.height ?? 0.06 * size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imgBgSelect ?? LocalImage.selectBox),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.02 * size.width),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                      text: ((selectedItems).isEmpty
                          ? widget.placeholder.tr
                          : (selectedItems.map((el) => el.label).join(", "))),
                      style: TextStyle(
                        color: AppColor.gray,
                        fontWeight: FontWeight.w500,
                        fontSize: Fontsize.normal,
                      ),
                      children: [
                        TextSpan(
                          text: widget.isRequired ? " *" : "",
                          style: const TextStyle(
                            color: AppColor.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: List.generate(widget.spaceRight, (index) => " ")
                              .join(""),
                        ),
                      ]),
                ),
              ),
            ),
          ),
          Positioned.fill(
            right: 0.05 * size.width,
            child: Align(
              alignment: Alignment.centerRight,
              child: widget.isLoading
                  ? SizedBox.square(
                      dimension: 0.03 * size.width,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : RotationTransition(
                      turns: _turnsTweenRotate,
                      child: Image.asset(
                        LocalImage.swiperNext,
                        width: 0.04 * size.width,
                      ),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    oldOptions = (widget.options ?? []);
    // Tạo AnimationController với thời gian thực hiện là 2 giây
    _controllerRotate = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    // Tạo một Tween để quay 1 góc -90 độ (từ 0 đến -π/2)
    _turnsTweenRotate =
        Tween<double>(begin: 0.0, end: 0.25).animate(_controllerRotate);

    if (widget.defaultValues != null) {
      final tmp = (widget.options ?? [])
          .where(
            (element) => (widget.defaultValues ?? [])
                .map((el) => el.toString())
                .contains(element.value),
          )
          .toList();
      selectedItems = tmp;
    }
  }

  void handleHideSingle() {
    if (_controllerRotate.isCompleted) {
      _controllerRotate.reverse();
      _hideTooltip();
    }
  }

  void _showTooltip() {
    final overlay = Overlay.of(context);
    final Size size = MediaQuery.of(context).size;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              handleHideSingle();
            },
            child: Container(
              color: Colors.white.withOpacity(0),
              width: size.width,
              child: Center(
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: Offset(
                    widget.offsetX ?? 0,
                    widget.offsetY ?? widget.height ?? 0.048 * size.height,
                  ),
                  showWhenUnlinked: false,
                  child: SizedBox(
                    width: widget.dropWidth ?? widget.width ?? 0.7 * size.width,
                    child: DropList(
                        options: widget.options,
                        selectedItems: selectedItems,
                        dropHeight: widget.dropHeight,
                        itemStyle: widget.itemStyle,
                        imgBgDropdown: widget.imgBgDropdown,
                        onSelectChange: onSelectChange,
                        handleHideSingle: handleHideSingle,
                        isShowScrollVertical: widget.isShowScrollVertical),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _rotateIcon() {
    if (_controllerRotate.isCompleted) {
      _controllerRotate.reverse();
    } else {
      _controllerRotate.forward();
    }
  }

  @override
  void dispose() {
    _hideTooltip();
    _controllerRotate.dispose();
    super.dispose();
  }
}

class DropList extends StatefulWidget {
  const DropList(
      {super.key,
      this.options,
      this.onSelectChange,
      this.selectedItems,
      this.dropHeight,
      this.handleHideSingle,
      this.itemStyle,
      this.imgBgDropdown,
      this.isShowScrollVertical});

  final List<SelectItem>? options;
  final Function(List<SelectItem> value)? onSelectChange;
  final List<SelectItem>? selectedItems;
  final double? dropHeight;
  final Function? handleHideSingle;
  final TextStyle? itemStyle;
  final String? imgBgDropdown;
  final bool? isShowScrollVertical;

  @override
  State<DropList> createState() => _DropListState();
}

class _DropListState extends State<DropList> {
  late List<SelectItem> selectedItems = [];
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    setState(() {
      selectedItems = widget.selectedItems ?? [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 0.02 * size.height,
      ),
      height: widget.dropHeight ?? 0.205 * size.height,
      decoration: BoxDecoration(
        // color: Colors.amber,
        image: DecorationImage(
          image: AssetImage(widget.imgBgDropdown ?? LocalImage.dropdownBg),
          fit: BoxFit.fill,
        ),
      ),
      child: (widget.options ?? []).isEmpty
          ? Center(
              child: EmptyData(
                width: 30,
                height: 30,
                des: "data_empty",
                desStyle: TextStyle(
                  fontSize: Fontsize.smallest,
                ),
              ),
            )
          : RawScrollbar(
              thumbColor: widget.isShowScrollVertical == true
                  ? const Color(0xffFD9F01)
                  : Colors.transparent,
              trackColor: Colors.transparent,
              radius: Radius.circular(0.008 * 2 * size.width),
              thumbVisibility: true,
              thickness: 0.02 * size.width,
              interactive: true,
              padding: EdgeInsets.only(
                top: 0.03 * size.height,
                bottom: 0.01 * size.height,
                right: 0.03 * size.width,
              ),
              controller: scrollController,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  children: [
                    ...(widget.options ?? [])
                        .map((el) => GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // late bool allowHidden = true;

                                // setState(() {
                                //   if (selectedItem != null &&
                                //       el.value == selectedItem!.value) {
                                //     allowHidden = false;
                                //     selectedItem = null;
                                //   } else {
                                //     selectedItem = el;
                                //   }
                                // });
                                setState(() {
                                  if (selectedItems.contains(el)) {
                                    selectedItems.remove(el);
                                  } else {
                                    selectedItems.add(el);
                                  }
                                });
                                if (widget.onSelectChange != null) {
                                  widget.onSelectChange!(selectedItems);
                                }
                                // if (widget.handleHideSingle != null &&
                                //     allowHidden) {
                                //   widget.handleHideSingle!();
                                // }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: LibFunction.scaleForCurrentValue(
                                    size,
                                    2,
                                    desire: 1,
                                  ),
                                  bottom: LibFunction.scaleForCurrentValue(
                                    size,
                                    2,
                                    desire: 1,
                                  ),
                                  left: LibFunction.scaleForCurrentValue(
                                    size,
                                    108,
                                  ),
                                  right: LibFunction.scaleForCurrentValue(
                                    size,
                                    156,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        el.label,
                                        style: TextStyle(
                                          color: const Color(0xff606060),
                                          fontWeight: FontWeight.w600,
                                          fontSize: Fontsize.normal,
                                          decoration: TextDecoration.none,
                                          fontFamily: "Lato",
                                        ).merge(widget.itemStyle),
                                      ),
                                    ),
                                    Image.asset(
                                      (selectedItems
                                              .map((x) => x.value)
                                              .contains(el.value))
                                          ? LocalImage.radioLangChecked2
                                          : LocalImage.radioLangUnchecked2,
                                      width: 0.06 * size.width,
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
    );
  }
}

class CustomPanGestureRecognizer extends OneSequenceGestureRecognizer {
  final Function onPanDown;
  final Function onPanUpdate;
  final Function onPanEnd;

  CustomPanGestureRecognizer({
    required this.onPanDown,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  void addPointer(PointerEvent event) {
    if (onPanDown(event.position) != null && onPanDown(event.position)) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      onPanUpdate(event.position);
    }
    if (event is PointerUpEvent) {
      onPanEnd(event.position);
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
