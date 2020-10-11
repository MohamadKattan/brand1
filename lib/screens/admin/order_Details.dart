import 'package:brand/models/product.dart';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OrderDetails extends StatelessWidget {
  static String id = 'OrderDetails';
  Store store = Store();
  @override
  Widget build(BuildContext context) {
    String documentId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: KMainColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: store.loadOrdersDetails(documentId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product>products=[];
            for(var doc in snapshot.data.documents){
              products.add(Product(
                pName: doc.data[KProductName],
                pCategory: doc.data[KProductCategory],
             pquantity: doc.data[KProductQuantity],
              ));

            }
            return  Column(

              children: <Widget>[

                Expanded(
                  child: ListView.builder(
                    itemBuilder:(context,indax)=> Padding(
                      padding: const EdgeInsets.all(20),
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
                                'ProductName ${products[indax].pName}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'ProductCategory ${products[indax].pCategory}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'ProductQuantity ${products[indax].pquantity}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: products.length,
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10),
                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
                    Expanded(child: ButtonTheme(buttonColor: Colors.white,child: RaisedButton(child: Text('Confirm'), onPressed: () {  },))),
                    SizedBox(width: 10,),
                    Expanded(child: ButtonTheme(buttonColor: Colors.white,child: RaisedButton(child: Text('Delete'), onPressed: () {  },)))
                  ],),
                )
              ],
            );
          } else {
            return Container(child: Center(child: Text('Order is loading...')));
          }
        },
      ),
    );
  }
}
