class RestaurantModel {
  int restaurantID;
  String restaurantName;
  String address;
  String type;
  bool parkingLot;

  RestaurantModel({
    required this.restaurantID,
    required this.restaurantName,
    required this.address,
    required this.type,
    required this.parkingLot,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      restaurantID: json['restaurantID'],
      restaurantName: json['restaurantName'],
      address: json['address'],
      type: json['type'],
      parkingLot: json['parkingLot'],
    );
  }
}
