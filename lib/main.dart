import 'package:brand/provider/adminmode.dart';
import 'package:brand/provider/cartItemCounter.dart';
import 'package:brand/provider/cartitem.dart';
import 'package:brand/provider/favorite.dart';
import 'package:brand/provider/modelhud.dart';
import 'package:brand/screens/admin/addproduct.dart';
import 'package:brand/screens/admin/adminhome.dart';
import 'package:brand/screens/admin/editProduct.dart';
import 'package:brand/screens/admin/manegeProduct.dart';
import 'package:brand/screens/admin/order_Details.dart';
import 'package:brand/screens/admin/ordersScreen.dart';
import 'package:brand/screens/homepage.dart';
import 'package:brand/screens/login_screen.dart';
import 'package:brand/screens/singup_screen.dart';
import 'package:brand/screens/users/cardPayScreen.dart';
import 'package:brand/screens/users/cartScreen.dart';
import 'package:brand/screens/users/existingCardPayScreen.dart';
import 'package:brand/screens/users/faickhome.dart';
import 'package:brand/screens/users/favortPage.dart';
import 'package:brand/screens/users/jackets.dart';
import 'package:brand/screens/users/pants.dart';
import 'package:brand/screens/users/productInfo.dart';
import 'package:brand/screens/users/profailUser.dart';
import 'package:brand/screens/users/singUP1.dart';
import 'package:brand/screens/users/skirt.dart';
import 'package:brand/screens/users/t_shirt.dart';
import 'package:brand/screens/users/userlogin.dart';
import 'package:brand/screens/users/userlogin1.dart';
import 'package:brand/widget/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  //this method for stop rotation
  WidgetsFlutterBinding.ensureInitialized();
  EcommercApp.auth=FirebaseAuth.instance;
  EcommercApp.firestore=Firestore.instance;
  EcommercApp.sharedPreferences=await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserloggedIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(body: Center(child: Text('Loading.....'))),
          );
        } else {
          isUserloggedIn = snapshot.data.getBool(KKeepMeloggedIN) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHud>(create: (context) => ModelHud()),
              ChangeNotifierProvider<AdminMode>(
                  create: (context) => AdminMode()),
              ChangeNotifierProvider<Cartitem>(create: (context) => Cartitem()),
              ChangeNotifierProvider<CartItemCounter>(create: (context) => CartItemCounter()),
              ChangeNotifierProvider<Favorite>(create: (context) => Favorite()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: isUserloggedIn ? MyHomePage.id : FaickHome.id,
              routes: {
                FaickHome.id: (context) => FaickHome(),
                LoginUser1.id: (context) => LoginUser1(),
                LoginScreen.id: (context) => LoginScreen(),
                SignUP1.id: (context) => SignUP1(),
                MyHomePage.id: (context) => MyHomePage(),
                FavoritePage.id:(context)=>FavoritePage(),
                AdminHome.id: (context) => AdminHome(),
                AddProduct.id: (context) => AddProduct(),
                ManegeProduct.id: (context) => ManegeProduct(),
                EditProduct.id: (context) => EditProduct(),
                ProductInfo.id: (context) => ProductInfo(),
                CartScreen.id: (context) => CartScreen(),
                OrderScreen.id: (context) => OrderScreen(),
                OrderDetails.id: (context) => OrderDetails(),
                CardPayScreen.id: (context) => CardPayScreen(),
                ExistingCard.id: (context) => ExistingCard(),
                Jackets.id: (context) => Jackets(),
                T_shirt.id: (context) => T_shirt(),
                Pants.id: (context) => Pants(),
                Skirt.id: (context) => Skirt(),
                ProfailUser.id:(context)=>ProfailUser(),

              },
            ),
          );
        }
      },
    );
  }
}
