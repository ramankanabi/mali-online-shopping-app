import 'package:online_shopping/controller/auth_contoller.dart';

class Order {
  final String customerId;
  final String productName;
  final String productId;
  final List images;
  final int quantity;
  final String size;
  final double price;
  final double? subTotalPrice;
  final String objectId;
  final String city;
  final String location;
  final String orderDate;
  final String phone;
  final String orderId;
  final String arriveDate;
  final bool isArrived;

  Order({
    required this.orderId,
    required this.customerId,
    required this.productId,
    required this.productName,
    required this.images,
    required this.quantity,
    required this.size,
    required this.price,
    this.subTotalPrice,
    required this.objectId,
    required this.city,
    required this.location,
    required this.orderDate,
    required this.phone,
    required this.arriveDate,
    required this.isArrived,
  });

  factory Order.fromJson(
      Map<String, dynamic> extractedData, Map<String, dynamic> generalData) {
    return Order(
      orderId: generalData["_id"],
      customerId: generalData["customerId"],
      productId: extractedData["productId"],
      productName: extractedData["productName"],
      images: extractedData["images"],
      quantity: extractedData["quantity"],
      size: extractedData["size"],
      price: extractedData["price"].toDouble(),
      objectId: extractedData["_id"],
      subTotalPrice: extractedData["subTotalPrice"].toDouble(),
      city: generalData["city"],
      location: generalData["location"],
      orderDate: generalData["orderDate"],
      phone: generalData["phoneNumber"],
      arriveDate: generalData["arriveDate"],
      isArrived: generalData["isArrived"],
    );
  }
}
