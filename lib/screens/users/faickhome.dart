import 'dart:ui';

import 'package:brand/models/product.dart';
import 'package:brand/screens/login_screen.dart';
import 'package:brand/screens/users/userlogin.dart';
import 'package:brand/screens/users/userlogin1.dart';
import 'package:brand/services/auth.dart';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/image_slider_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../functions.dart';

class FaickHome extends StatefulWidget {
  static String id = ' FaickHome';
  @override
  _FaickHomeState createState() => _FaickHomeState();
}

class _FaickHomeState extends State<FaickHome> {
  final _auth = Auth();
  FirebaseUser _loggedUser;
  int _tabBarIndex = 0;
  final _store = Store();
  List<Product> _products;
  final FirebaseMessaging firebaseMessagiesing = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    configureCallBack();
    getDeviceToken();
    subToAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: (BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ Colors.deepOrangeAccent[700],Colors.white],
                    begin: const FractionalOffset(0.0, 0.0),
                    end:  const FractionalOffset(1.0,0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp
                  )
                )),
              ),
              elevation: 0,
              centerTitle: false,
              // title: GestureDetector(
              //   onLongPress: () {
              //     Navigator.pushNamed(context, LoginScreen.id);
              //   },
              //   child: Text(
              //     'Welcome',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 25,
              //         fontFamily: 'Pacifico-Regular.ttf'),
              //   ),
              // ),
              // actions: [
              //   IconButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, LoginUser1.id);
              //     },
              //     color: Colors.deepOrangeAccent[400],
              //     icon: Icon(Icons.person_add),
              //   )
              // ],

            ),
            body: Stack(
              children: [
                Image_Carousel(),
                Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _store.loadProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Product> products = [];
                        for (var doc in snapshot.data.documents) {
                          var data = doc.data;
                          products.add(Product(
                              pID: doc.documentID,
                              pPrice: data[KProductPrice],
                              pName: data[KProductName],
                              pDescription: data[KProductDescription],
                              pimage: data[KProductImage],
                              pCategory: data[KProductCategory]));
                        }
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .8,
                          ),
                          itemBuilder: (context, index) => Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Before any order you should register with us'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ));
                              },
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image:
                                          NetworkImage(products[index].pimage[0]),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Opacity(
                                      opacity: .8,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 45,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Text(
                                                products[index].pName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text('\$ ${products[index].pPrice}')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          itemCount: products.length,
                        );
                      } else {
                        return Center(child: Text('Loading...'));
                      }
                    },
                  ),
                ),
              ],
            )),
        Material(
          child: Container(
            decoration: (BoxDecoration(
                gradient: LinearGradient(
                    colors: [ Colors.deepOrangeAccent[700],Colors.white],
                    begin: const FractionalOffset(0.0, 0.0),
                    end:  const FractionalOffset(1.0,0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp
                )
            )),
            height: MediaQuery.of(context).size.height * .1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 30.0),
                  child: GestureDetector(onLongPress: (){ Navigator.pushNamed(context, LoginScreen.id);},
                    child: Text(
                      'Welcome'.toUpperCase(),
                      style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:13.0,top: 30.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginUser1.id);

                      },
                      child: Icon(Icons.person_add,color: Colors.deepOrangeAccent[700],)),
                )
              ],
            ),
          ),
        ),

      ],
    );
  }

  getCurrentUser() async {
    _loggedUser = await _auth.getUser();
  }

  void configureCallBack() {
    firebaseMessagiesing.configure(
      onMessage: (message) async {
        print('message:$message');
      },
      onResume: (message) async {
        print('message:$message');
      },
      onLaunch: (message) async {
        Navigator.pushNamed(context, LoginScreen.id);
      },
    );
  }

  void getDeviceToken() async {
    String deviceToken = await firebaseMessagiesing.getToken();
    print('deviceToken:$deviceToken');
  }

  void subToAdmin() {
    firebaseMessagiesing.subscribeToTopic('Admin');
  }

  // Widget noDateFound() {
  //   return Container(
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Icon(
  //             Icons.find_in_page,
  //             color: Colors.black45,
  //             size: 80.0,
  //           ),
  //           Text(
  //             'Not product available yet',
  //             style: TextStyle(color: Colors.black45, fontSize: 20),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Text(
  //             'Please check back later',
  //             style: TextStyle(color: Colors.black45, fontSize: 20),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildProducts(
  //     BuildContext context, int index, DocumentSnapshot document) {
  //   List productImage = document[KProductImage] as List;
  //   return GestureDetector(
  //     onTap: () {
  //       Scaffold.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 5),
  //         content: Text('Register with us before any order'),
  //       ));
  //     },
  //     child: Card(
  //       child: Stack(
  //         alignment: FractionalOffset.bottomCenter,
  //         children: [
  //           Container(
  //             child: Image(
  //               fit: BoxFit.cover,
  //               image: NetworkImage(productImage[0]),
  //             ),
  //           ),
  //           Opacity(
  //             opacity: 1.0,
  //             child: Container(
  //               height: 30,
  //               width: MediaQuery.of(context).size.width,
  //               color: Colors.black12,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Text(
  //                       '${document[KProductName]}',
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 12),
  //                     ),
  //                     Text('\$ ${document[KProductPrice]}',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 12,
  //                             color: Colors.red))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
// child: StreamBuilder<QuerySnapshot>(
//   stream: _store.loadProducts(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return Center(
//           child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(
//                   Theme.of(context).primaryColor)));
//     } else {
//       final int dataCount = snapshot.data.documents.length;
//       print('data count $dataCount');
//       if (dataCount == 0) {
//         return noDateFound();
//       } else {
//         return GridView.builder(
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2),
//           itemCount: dataCount,
//           itemBuilder: (context, index) {
//             final DocumentSnapshot document =
//                 snapshot.data.documents[index];
//             return buildProducts(context, index, document);
//           },
//         );
//       }
//     }
//   },
// ),
}
