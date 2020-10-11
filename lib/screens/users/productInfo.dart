import 'package:brand/models/product.dart';
import 'package:brand/provider/cartItemCounter.dart';
import 'package:brand/provider/cartitem.dart';
import 'package:brand/screens/users/cartScreen.dart';
import 'package:brand/widget/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static String id = ' ProductInfo';

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  Product _product = Product();
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image(
                fit: BoxFit.fill,
                image: NetworkImage(product.pimage[0]),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios,color: Colors.deepOrangeAccent[400],)),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, CartScreen.id);
                        },
                        color: Colors.deepOrangeAccent[400],
                        icon: Icon(Icons.shopping_cart),
                      ),
                      Positioned(
                          child: Stack(children: [
                            Icon(Icons.brightness_1,
                                size: 20, color: Colors.deepOrangeAccent[400]),
                            Positioned(
                              top: 3.0,
                              bottom: 3.0,
                              left: 6.0,
                              child: Consumer<CartItemCounter>(
                                builder: (context, counter, _) {
                                  return Text(
                                    (EcommercApp.sharedPreferences.getStringList(KuserCartList).length-1).toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  );
                                },
                              ),
                            )
                          ])),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: <Widget>[
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(product.pName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                               Text('\$${product.pPrice}',


                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(product.pDescription,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                  child: Material(
                                      color: Colors.white,
                                      child: GestureDetector(
                                          onTap: add,
                                          child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Icon(Icons.add))))),
                              SizedBox(height: 2),
                              Text(
                                _quantity.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 60),
                              ),
                              SizedBox(height: 2),
                              ClipOval(
                                  child: Material(
                                      color: Colors.white,
                                      child: GestureDetector(
                                          onTap: subtrct,
                                          child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Icon(Icons.remove))))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
                  decoration: (
                      BoxDecoration(
                      gradient: LinearGradient(
                          colors: [ Colors.deepOrangeAccent[700],Colors.white],
                          begin: const FractionalOffset(0.0, 0.0),
                          end:  const FractionalOffset(1.0,0.0),
                          stops: [0.0,1.0],
                          tileMode: TileMode.clamp
                      )
                  )),
                  child: Builder(
                    builder: (context) => FlatButton(
                      onPressed: () {
                        addToCart(context, product);

                      },
                      child: Text(
                        'Add To Cart',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'fonts/Pacifico-Regular.ttf'),
                      ),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//من اجل تنقسص عدد المنتج
  void subtrct() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

//من اجل زيادة عدد منتج
  void add() {
    setState(() {
      _quantity++;
    });
  }

//هذه الوظيفة من اجل اضافة المنج الى الكارت this method for add prodect to cart
  void addToCart(context, product) {
    Cartitem cartitem = Provider.of<Cartitem>(context, listen: false);
   product. pquantity = _quantity;
    bool exist = false;
    var productsInCart = cartitem.products;
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
      chackiteminBasket(_product.pName, context);
      cartitem.addProduct(product);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Added is don',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
      ));
    }

  }

 // *************** this method for add number to basket***********
  void chackiteminBasket(String productID, BuildContext context) {
    EcommercApp.sharedPreferences
        .getStringList(KuserCartList)
        .contains(productID)
        ? Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text('Ordered Successfully'),
    ))
        : addItemTObasket(productID, context);
  }

  addItemTObasket(String productID, BuildContext context) {
    List tempCarList =
    EcommercApp.sharedPreferences.getStringList(KuserCartList);
    tempCarList.add(productID);
    EcommercApp.firestore
        .collection(KAuthCollection)
        .document(EcommercApp.sharedPreferences.getString(KUid))
        .updateData({KuserCartList: tempCarList}).then((value) {
      EcommercApp.sharedPreferences.setStringList(KuserCartList, tempCarList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }
  //****************************************************************
}
