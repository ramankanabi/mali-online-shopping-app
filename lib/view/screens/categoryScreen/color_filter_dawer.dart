import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/filter_product_controller.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/style_manager.dart';

class ColorDrawer extends StatefulWidget {
  const ColorDrawer({super.key});

  @override
  State<ColorDrawer> createState() => _ColorDrawerState();
}

class _ColorDrawerState extends State<ColorDrawer> {
  String filterColor = "";

  final Map<String, Color> colorList = {
    "black": Colors.black,
    "blue": Colors.blue,
    "brown": Colors.brown,
    "red": Colors.red,
    "orange": Colors.orange,
    "yellow": Colors.yellow,
    "green": Colors.green,
    "pink": Colors.pink,
    "purple": Colors.purple,
    "grey": Colors.grey,
    "white": Colors.white,
  };
  List isSelectedList = [];
  @override
  void initState() {
    final colorFilterList =
        Provider.of<FilterProductController>(context, listen: false)
            .filterList["color"];

    filterColor = colorFilterList!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                "Color",
                style: getMediumStyle(
                    color: ColorManager.grey, fontSize: FontSize.s18),
              ),
              elevation: 0.2,
            ),
            Wrap(
              children: [
                for (int i = 0; i < colorList.length; i++) ...{
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        if (filterColor != colorList.keys.toList()[i]) {
                          filterColor = colorList.keys.toList()[i];
                        } else {
                          filterColor = "";
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorList.values.toList()[i],
                          border: Border.all(width: 0.2),
                        ),
                        child: filterColor == colorList.keys.toList()[i]
                            ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.3),
                                  border: Border.all(width: 0.2),
                                ),
                                child: Icon(
                                  Icons.done,
                                  color: ColorManager.white,
                                  size: 15,
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  )
                }
              ],
            )
          ],
        ),
        InkWell(
          onTap: () {
            Provider.of<FilterProductController>(context, listen: false)
                .addColorFilter(filterColor);

            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            color: ColorManager.orange,
            child: Text(
              "Apply",
              style: getBoldStyle(
                color: ColorManager.white,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
