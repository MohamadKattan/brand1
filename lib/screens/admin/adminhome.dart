import 'package:brand/screens/admin/addproduct.dart';
import 'package:brand/screens/admin/manegeProduct.dart';
import 'package:brand/screens/admin/ordersScreen.dart';
import 'package:brand/widget/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  static String id = ' AdminHome ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KMainColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
            ),
            RaisedButton(
              child: Text('AddProduct'),
              onPressed: () {
                Navigator.pushNamed(context, AddProduct.id);
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, ManegeProduct.id);
              },
              child: Text('  ManegeProduct '),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, OrderScreen.id);
              },
              child: Text('OrderScreen'),
            ),
          ],
        ));
  }
}
