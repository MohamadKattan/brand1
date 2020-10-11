import 'package:brand/models/product.dart';
import 'package:brand/provider/cartItemCounter.dart';
import 'package:brand/provider/cartitem.dart';
import 'package:brand/provider/favorite.dart';
import 'package:brand/screens/homepage.dart';
import 'package:brand/screens/users/productInfo.dart';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/custom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  static String id = 'FavoritePage';
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  Store store = Store();
  Product _product = Product();
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    List<Product> products = Provider.of<Favorite>(context).products;
    String productID;

    return Scaffold(
        key: scaffoldState,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          flexibleSpace: Container(
            decoration: (BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrangeAccent[700], Colors.white],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(2.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp))),
          ),
          elevation: 0,
          title: Text('My Favorite'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, constrains) {
              if (products.isNotEmpty) {
                return Container(
                  decoration: (BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.deepOrangeAccent[700], Colors.white],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp))),
                  height: heightScreen -
                      (heightScreen * 0.09) -
                      appBarHeight -
                      statusBarHeight,
                  child: ListView.builder(
                    itemBuilder: (context, indax) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: GestureDetector(
                          onTapUp: (details) {
                            ShowCustomMenu(details, context, products[indax]);
                          },
                          child: Container(
                            height: heightScreen * 0.15,
                            width: widthScreen,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: heightScreen * 0.15 / 2,
                                  backgroundImage:
                                      (NetworkImage(products[indax].pimage[0])),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              products[indax].pName,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              '\$${products[indax].pPrice}',
                                              // '\$${ProductInfo().pPrice}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  products[indax].pCategory,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: products.length,
                  ),
                );
              } else {
                return Container(
                  decoration: (BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.deepOrangeAccent[700], Colors.white],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp))),
                  height: heightScreen -
                      (heightScreen * 0.09) -
                      appBarHeight -
                      statusBarHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 100,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          'Cart is Empty',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),

          ],
        ));
  }

  void ShowCustomMenu(details, context, product) async {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx1 = MediaQuery.of(context).size.width - dx;
    double dy1 = MediaQuery.of(context).size.width - dy;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx1, dy1),
        items: [
          MyPopupMenuItem(
            child: Text('Delete'),
            onClick: () {
              Provider.of<Favorite>(context, listen: false)
                  .deleteProduct(product);
            },
          ),
        ]);
  }

  void addToCart(context, product) {
    Cartitem cartitem = Provider.of<Cartitem>(context, listen: false);
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
