import 'package:flutter/material.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:provider/provider.dart';

import '../../../controller/filter_product_controller.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/style_manager.dart';

class PriceDrawer extends StatefulWidget {
  const PriceDrawer({super.key});

  @override
  State<PriceDrawer> createState() => _PriceDrawerState();
}

class _PriceDrawerState extends State<PriceDrawer> {
  final minController = TextEditingController();
  final maxController = TextEditingController();
  String minPrice = '';
  String maxPrice = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    maxPrice = Provider.of<FilterProductController>(context, listen: false)
        .filterList["maxPrice"]!;
    minPrice = Provider.of<FilterProductController>(context, listen: false)
        .filterList["minPrice"]!;

    if (maxPrice != '') {
      maxController.text = maxPrice;
    }
    if (minPrice != '') {
      minController.text = minPrice;
    }
    super.initState();
  }

  minValidation(String val) {
    if (val.isEmpty && maxController.text.isNotEmpty) {
      minController.text = "0";
    }
    return null;
  }

  maxValidation(String val) {
    if (val.isNotEmpty && maxController.text.isNotEmpty) {
      if (double.parse(val) < double.parse(minController.text)) {
        return "maximum price should be greater than minimum price";
      }
    }

    return null;
  }

  _onSubmit() {
    final isValid = _formKey.currentState?.validate();
    if (isValid == false || isValid == null) {
      return;
    }
    minPrice = minController.text;
    maxPrice = maxController.text;

    Provider.of<FilterProductController>(context, listen: false)
        .addPriceFilter(minPrice, maxPrice);
    Navigator.pop(context);
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
              title: Text(
                "Price",
                style: getMediumStyle(
                    color: ColorManager.grey, fontSize: FontSize.s18),
              ),
              elevation: 0.2,
              actions: [
                TextButton(
                  onPressed: () async {
                    minController.text = "";
                    maxController.text = '';
                  },
                  child: Text(
                    "clear",
                    style: getMediumStyle(color: ColorManager.orange),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p20),
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PriceTextField(
                        "min", minController, (val) => minValidation(val)),
                    SizedBox(
                      width: 30,
                      child: Text(
                        "~",
                        style: getMediumStyle(
                            color: ColorManager.orange, fontSize: FontSize.s20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    PriceTextField(
                        "max", maxController, (val) => maxValidation(val)),
                  ],
                ),
              ),
            )
          ],
        ),
        InkWell(
          onTap: () {
            _onSubmit();
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

  Widget PriceTextField(String hintText, TextEditingController controller,
      Function(String val) validate) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: controller,
        style:
            getMediumStyle(color: ColorManager.orange, fontSize: FontSize.s16),
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          hintStyle: getLightStyle(
              color: ColorManager.lightGrey, fontSize: FontSize.s14),
          suffix: Text(
            "IQD",
            textAlign: TextAlign.end,
            style: getLightStyle(
              color: ColorManager.lightGrey,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.lightGrey, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.grey, width: 1),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          errorMaxLines: 5,
        ),
        cursorColor: ColorManager.cursorColor,
        cursorWidth: 1,
        keyboardType: TextInputType.number,
        validator: (val) => validate(val.toString()),
      ),
    );
  }
}
