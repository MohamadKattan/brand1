
import 'package:brand/models/product.dart';
import 'package:brand/provider/cartItemCounter.dart';
import 'package:brand/screens/users/cartScreen.dart';
import 'package:brand/screens/users/faickhome.dart';
import 'package:brand/screens/users/favortPage.dart';
import 'package:brand/screens/users/jackets.dart';
import 'package:brand/screens/users/pants.dart';
import 'package:brand/screens/users/profailUser.dart';
import 'package:brand/screens/users/skirt.dart';
import 'package:brand/screens/users/t_shirt.dart';
import 'package:brand/services/auth.dart';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/image_slider_carousel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class MyHomePage extends StatefulWidget {
  static String id = 'MyHomePage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = Auth();
  FirebaseUser _loggedUser;
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
    var isLoggedIn;
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
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
              centerTitle: false,
              title: (Text(
                'Discover',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )),
              elevation: 0,
              actions: [
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
            body: Stack(
              children: [
                Image_Carousel(),
                Padding(
                    padding: const EdgeInsets.only(top: 180.0),
                    child: ListView(
                      children: [
                        //jacket
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, left: 8.0, right: 8.0, bottom: 8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 180.0,
                                width: MediaQuery.of(context).size.width,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                        context, Jackets.id);
                                  },
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('images/cloths/4.jpg'),
                                        fit: BoxFit.fill)),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    child: Text(
                                      'Jackets',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.black,
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //tshirt
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 180.0,
                                width: MediaQuery.of(context).size.width,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                        context, T_shirt.id);
                                  },
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('images/cloths/2.webp'),
                                        fit: BoxFit.fill)),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    child: Text(
                                      'T_Shirts',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.black,
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //skirt
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 180.0,
                                width: MediaQuery.of(context).size.width,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                        context, Skirt.id);
                                  },
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('images/cloths/5.jpg'),
                                        fit: BoxFit.fill)),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    child: Text(
                                      'Skirts',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.black,
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //pant
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 180.0,
                                width: MediaQuery.of(context).size.width,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                        context, Pants.id);
                                  },
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('images/cloths/3.jpg'),
                                        fit: BoxFit.fill)),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    child: Text(
                                      'Pants',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    color: Colors.black,
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            drawer: Drawer(
              elevation: 10.0,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        decoration: (BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.deepOrangeAccent[700], Colors.white],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp))),
                        accountName: Text(
                            EcommercApp.sharedPreferences.getString(KName)),
                        accountEmail: Text(
                            EcommercApp.sharedPreferences.getString(KEmail)),
                        currentAccountPicture: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              EcommercApp.sharedPreferences.getString(KUrl)),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, ProfailUser.id);
                        },
                        leading: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.deepOrangeAccent[700],
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('My Profile'),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.deepOrangeAccent[700],
                          child: Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('Order History'),
                      ),
                      Divider(),
                      ListTile(
                          onTap: () {Navigator.pushNamed(context, FavoritePage.id);},
                        leading: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.deepOrangeAccent[700],
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('My Favorite'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, CartScreen.id);
                        },
                        leading: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: Colors.deepOrangeAccent[700],
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('My Cart'),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {},
                        trailing: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.deepOrangeAccent[700],
                          child: Icon(
                            Icons.help,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('About us'),
                      ),
                      ListTile(
                          trailing: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.deepOrangeAccent[700],
                            child: Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                            ),
                          ),
                          title: Text('SignOut'),
                          onTap: () {
                            EcommercApp.auth.signOut().then((c){
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context,FaickHome.id);

                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

// this method for auth
  getCurrentUser() async {
    _loggedUser = await _auth.getUser();
  }

// this method for notification include firebase messages
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

// this method for get devToken on firebase collection
  void getDeviceToken() async {
    String deviceToken = await firebaseMessagiesing.getToken();
    _store.getDevToken(deviceToken);
    print('deviceToken:$deviceToken');
  }

// this method for notification for connect with all devices
  void subToAdmin() {
    firebaseMessagiesing.subscribeToTopic('Admin');
  }

// this method for switch email by google or normal why drawer
  String emailUseremail(email, useremail) {
    if (Text != null) {
      return email;
    }
    if (Text != null) {
      return useremail;
    } else {
      // ignore: unnecessary_statements
      Text == null;
      return '';
    }
  }
}
