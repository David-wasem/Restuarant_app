import 'package:api_app/models/restuarant/user_rest_model.dart';

class MasterOrderModel {

  int orderID;
  UserRestModel user;
  String userID;
  String itemName;
  int quantity;
  int itemPrice;
  int totalPrice;
  int masterID;

  MasterOrderModel({
    required this.orderID,
    required this.user,
    required this.userID,
    required this.itemName,
    required this.quantity,
    required this.itemPrice,
    required this.totalPrice,
    required this.masterID,
  });

  factory MasterOrderModel.fromJson(Map<String, dynamic> json) {
    return MasterOrderModel(
      orderID: json['orderID'],
      user: UserRestModel.fromJson(json['user']),
      userID: json['userID'],
      itemName: json['itemName'],
      quantity: json['quantity'],
      itemPrice: json['itemPrice'],
      totalPrice: json['totalPrice'],
      masterID: json['masterID'],
    );
  }
}