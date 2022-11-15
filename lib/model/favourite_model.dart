class Favourite {
  final String name;
  final String prodId;
  final int price;
  final int? priceDiscount;
  final List<dynamic> images;
  final List size;
  final int quantity;

  Favourite({
    required this.name,
    required this.prodId,
    required this.price,
    required this.priceDiscount,
    required this.images,
    required this.quantity,
    required this.size,
  });

  factory Favourite.fromJson(Map<String, dynamic> extractedData) {
    return Favourite(
      name: extractedData["product"][0]["productName"],
      prodId: extractedData["productId"],
      price: extractedData["product"][0]["customerPrice"],
      images: extractedData["product"][0]["images"],
      size: extractedData["product"][0]["size"],
      quantity: extractedData["product"][0]["quantity"],
      priceDiscount: extractedData["product"][0]["priceDiscount"],
    );
  }
}
