import 'package:flutter/cupertino.dart';

class Order {
  String documentId;
  int totalPrice;
  String address;
  String email;
  String name;
  Order({@required this.address, @required this.totalPrice,this.documentId,this.email,this.name});
}
