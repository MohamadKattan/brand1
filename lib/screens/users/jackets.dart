import 'package:brand/functions.dart';
import 'package:brand/models/product.dart';
import 'package:brand/provider/favorite.dart';
import 'package:brand/screens/homepage.dart';
import 'package:brand/screens/users/cartScreen.dart';
import 'package:brand/screens/users/productInfo.dart';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jackets extends StatefulWidget {
  static String id = 'Jackets';
  @override
  _JacketsState createState() => _JacketsState();
}

class _JacketsState extends State<Jackets> {
  final _store = Store();
  List<Product> _products;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: (BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepOrangeAccent[700], Colors.white],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp))),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
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
                _products = [...products];
                products.clear();
                products = getProductByCategory(KJackets, _products);
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .8,
                  ),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProductInfo.id,
                            arguments: products[index]);
                      },
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(products[index].pimage[0]),
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
                                      Text(products[index].pPrice.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Builder(
                                builder: (context) => IconButton(
                                      onPressed: () {
                                        addToFavoret(context, products[index]);
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        // ignore: unrelated_type_equality_checks
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    )),
                          ),
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
        Material(
          child: Container(
            decoration: (BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrangeAccent[700], Colors.white],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp))),
            height: MediaQuery.of(context).size.height * .1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 30.0),
                  child: Text(
                    'Jackets'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 13.0, top: 30.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MyHomePage.id);
                        // Navigator.pop(context);
                        // Route route = MaterialPageRoute(builder: (c)=>MyHomePage());
                        // Navigator.pushReplacement(context, route);
                      },
                      child: Icon(Icons.arrow_back_ios)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void addToFavoret(context, product) {
    Favorite favorite = Provider.of<Favorite>(context, listen: false);
    bool exist = false;
    var productsInCart = favorite.products;
    for (var productInCart in productsInCart) {
      if (productInCart == product) {
        exist = true;
      }
    }
    if (exist) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'You did add this product before',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.red,
      ));
    } else {
      favorite.addProduct(product);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Added to favorite',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
      ));
    }
  }

  void deleteFromFavoret(context, product) {
    Favorite favorite = Provider.of<Favorite>(context, listen: false);
    bool exist = false;
    var productsInCart = favorite.products;
    for (var productInCart in productsInCart) {
      if (productInCart == product) {
        exist = true;
      }
    }
    if (exist) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'You did add this product before',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.red,
      ));
    } else {
      favorite.deleteProduct(product);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Delete is don',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
      ));
    }
  }
}
