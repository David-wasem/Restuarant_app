class IndividOrderModel {
  int masterId;
  int userId;
  int userCode;
  int restaurantId;
  int grandTotal;

  IndividOrderModel({
    required this.masterId,
    required this.userId,
    required this.userCode,
    required this.restaurantId,
    required this.grandTotal,
  });

  factory IndividOrderModel.fromJson(Map<String, dynamic> json) {
    return IndividOrderModel(
      masterId: json['masterId'],
      userId: json['userId'],
      userCode: json['userCode'],
      restaurantId: json['restaurantId'],
      grandTotal: json['grandTotal'],
    );
  }
}