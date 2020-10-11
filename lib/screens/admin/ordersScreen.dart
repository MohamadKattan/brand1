import 'package:brand/models/order.dart';
import 'package:brand/screens/admin/order_Details.dart';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//هذا الكلاس من اجل عرض طلبات الزبائن من اجل ادمن
class OrderScreen extends StatelessWidget {
  static String id = 'OrderScreen';
  final Store _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMainColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No found any order'));
          } else {
            List<Order> orders = [];
            for (var doc in snapshot.data.documents) {
              orders.add(Order(
                  documentId: doc.documentID,
                  address: doc.data[KAddress],
                  totalPrice: doc.data[KTotalPrice]));
            }
            return ListView.builder(
              itemBuilder: (context, indax) => Padding(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetails.id,
                        arguments: orders[indax].documentId);
                  },
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${orders[indax].address}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '\$${orders[indax].totalPrice}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }
}
