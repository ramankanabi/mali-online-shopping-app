class Cart {
  final String customerId;
  final String productName;
  final String productId;
  final List images;
  final int quantity;
  final String size;
  final double price;
  final double? subTotalPrice;
  final String objectId;

  Cart(
      {required this.customerId,
      required this.productId,
      required this.productName,
      required this.images,
      required this.quantity,
      required this.size,
      required this.price,
      this.subTotalPrice,
      required this.objectId});

  factory Cart.fromJson(Map<String, dynamic> extractedData, String customerId) {
    return Cart(
        customerId: customerId,
        productId: extractedData["productId"],
        productName: extractedData["productName"],
        images: extractedData["images"],
        quantity: extractedData["quantity"],
        size: extractedData["size"],
        price: extractedData["price"].toDouble(),
        objectId: extractedData["_id"],
        subTotalPrice: extractedData["subTotalPrice"].toDouble());
  }
}
