
class ItemModel {
  int itemId;
  String itemName;
  String itemDescription;
  double itemPrice;
  String restuarantName;
  int restuarantId;
  String imageUrl;

  ItemModel({
    required this.itemId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.restuarantName,
    required this.restuarantId,
    required this.imageUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemId: json['itemID'],
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
      itemPrice: json['itemPrice'],
      restuarantName: json['restaurantName'],
      restuarantId: json['restaurantID'],
      imageUrl: json['imageUrl'],
    );
  }
}