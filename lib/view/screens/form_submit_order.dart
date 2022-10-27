import 'package:flutter/material.dart';
import 'package:online_shopping/controller/cart_controller.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_contoller.dart';
import '../../controller/order_controller.dart';
import '../../model/cart_model.dart';
import '../../resources/color_manager.dart';

class FormSubmitOrder extends StatefulWidget {
  const FormSubmitOrder({Key? key, required this.cart}) : super(key: key);

  final List<Cart> cart;

  @override
  State<FormSubmitOrder> createState() => _FormSubmitOrderState();
}

class _FormSubmitOrderState extends State<FormSubmitOrder> {
  final _informationKey = GlobalKey<FormState>();

  late String phoneValue;

  late String cityValue;

  late String locationValue;

  bool isLoading = false;

  _formSave(BuildContext context) async {
    final isValid = _informationKey.currentState?.validate();
    if (isValid == false || isValid == null) {
      return;
    }
    _informationKey.currentState?.save();
    placeOrder(widget.cart);
  }

  void placeOrder(List<Cart> cart) async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<OrderController>(context, listen: false)
          .prepareOrderList(cart);
      await Provider.of<OrderController>(context, listen: false)
          .addOrder(globalUserId, phoneValue, cityValue, locationValue);
      await Provider.of<CartController>(context, listen: false).resetItem();
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    } catch (er) {
      print(er);
    }
  }

  final _cityList = [
    "Hawler",
    "Slemani",
    "Duhok",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submit Order",
          style: getMediumStyle(
              color: ColorManager.primary, fontSize: FontSize.s18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Explore The World Of Mali Shopping ",
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s20,
                  ),
                ),
                Form(
                  key: _informationKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone Number",
                            style: getMediumStyle(
                              color: ColorManager.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            cursorColor: ColorManager.cursorColor,
                            style: getRegularStyle(
                                color: ColorManager.primaryOpacity70,
                                fontSize: FontSize.s16),
                            decoration: InputDecoration(
                              focusColor: ColorManager.cursorColor,
                              contentPadding:
                                  const EdgeInsets.all(AppPadding.p8),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorManager.primary),
                              ),
                            ),
                            onSaved: (val) {
                              phoneValue = val.toString();
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "please enter a Phone number";
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                return "please enter only nuumbers";
                              }
                              if (val.length > 11 || val.length < 10) {
                                return "sorry, The number is invalid ";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "City",
                            style: getMediumStyle(color: ColorManager.grey),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                            style: getRegularStyle(
                                color: ColorManager.primaryOpacity70,
                                fontSize: FontSize.s16),
                            decoration: const InputDecoration(
                                isDense: true, border: OutlineInputBorder()),
                            items: _cityList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (val) {
                              cityValue = val.toString();
                            },
                            validator: (val) {
                              if (val == null) {
                                return "Please enter a city";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location",
                            style: getMediumStyle(color: ColorManager.grey),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            cursorColor: ColorManager.cursorColor,
                            style: getRegularStyle(
                              color: ColorManager.primaryOpacity70,
                              fontSize: FontSize.s16,
                            ),
                            maxLines: 5,
                            decoration: InputDecoration(
                              focusColor: ColorManager.cursorColor,
                              contentPadding:
                                  const EdgeInsets.all(AppPadding.p8),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorManager.primary),
                              ),
                            ),
                            onSaved: (val) {
                              locationValue = val.toString();
                            },
                            validator: (val) {
                              if (val.toString().trim().isEmpty) {
                                return "please enter a Location";
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _formSave(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              ColorManager.orange,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: AppSize.s200,
                            height: 40,
                            child: Text(
                              "Place Order",
                              textAlign: TextAlign.center,
                              style: getMediumStyle(
                                color: ColorManager.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
