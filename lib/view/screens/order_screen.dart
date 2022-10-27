import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/order_controller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../model/oder_model.dart';
import '../../resources/values_manager.dart';
import '../../widgets/slide_dots.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _future;

  @override
  void initState() {
    _future = Provider.of<OrderController>(context, listen: false)
        .getUserAllOrder(globalUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            final orderList = Provider.of<OrderController>(context).order;
            final height = MediaQuery.of(context).size.height;
            final width = MediaQuery.of(context).size.width;
            return snapshot.data == null
                ? const Loader()
                : orderList.isEmpty
                    ? Center(
                        child: Text(
                          "Order list is empty :(",
                          style: getMediumStyle(
                              color: ColorManager.lightGrey,
                              fontSize: FontSize.s20),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: orderList.length,
                            itemBuilder: (context, index) => Card(
                                  child: SizedBox(
                                    height: (height * 0.6) < 500 ? 430 : 500,
                                    width: width,
                                    child: LayoutBuilder(
                                      builder: (context, bxct) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ProductsPreViewImage(
                                                orderList[index], bxct),
                                            Expanded(
                                              child: SizedBox(
                                                height: bxct.maxHeight * 0.75,
                                                width: bxct.maxWidth,
                                                child:
                                                    GeneralInformationOfOrderWidget(
                                                        orderList[index]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      );
          }),
    );
  }

  Widget ProductsPreViewImage(List<Order> orderData, BoxConstraints bxct) {
    return Flexible(
      fit: FlexFit.loose,
      flex: 0,
      child: SizedBox(
        height: bxct.maxHeight * 0.25,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Products",
              style: getMediumStyle(color: ColorManager.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < orderData.length; i++) ...{
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              ProductViewDialog(context, orderData[i]),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: 70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                orderData[i].images[0],
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  }
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ListTileItem(
    String title,
    String subTitle,
    IconData icon,
  ) {
    return Expanded(
      child: ListTile(
        dense: true,
        title: Text(
          title,
          style: getMediumStyle(
            color: ColorManager.orange,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: getMediumStyle(
            color: ColorManager.grey1,
          ),
        ),
        trailing: Icon(icon),
        // subtitle: Text("hawler"),
        shape: const Border(bottom: BorderSide(width: 0.2)),
      ),
    );
  }

  Widget GeneralInformationOfOrderWidget(List<Order> orderData) {
    return Column(
      children: [
        ListTileItem(
          orderData[0].city,
          "city",
          CupertinoIcons.home,
        ),
        ListTileItem(
          orderData[0].phone,
          "phone",
          CupertinoIcons.phone,
        ),
        ListTileItem(
          DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(orderData[0].orderDate))
              .toString(),
          "order date",
          CupertinoIcons.calendar_today,
        ),
        ListTileItem(
          DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(orderData[0].arriveDate))
              .toString(),
          "arrive time",
          CupertinoIcons.time,
        ),
        ListTileItem(
          orderData[0].isArrived ? "arrived" : "in transit",
          "status",
          CupertinoIcons.cube_box,
        ),
        ListTileItem(
          "#${orderData[0].orderId}",
          "order id",
          CupertinoIcons.number,
        ),
      ],
    );
  }

  Widget ProductViewDialog(BuildContext context, Order orderData) {
    return Dialog(
      elevation: 20,
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < orderData.images.length; i++) ...{
                      Container(
                        width: AppSize.s80,
                        height: AppSize.s100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(orderData.images[i]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    }
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                orderData.productName,
                style: getMediumStyle(
                  color: ColorManager.orange,
                  fontSize: FontSize.s20,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ListTileItem(orderData.size, "size", Icons.space_bar),
              ListTileItem(orderData.quantity.toString(), "quantity",
                  CupertinoIcons.cart),
              ListTileItem(orderData.price.toString(), "price",
                  Icons.attach_money_sharp),
              ListTileItem(
                orderData.subTotalPrice.toString(),
                "subTotal",
                Icons.money,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
