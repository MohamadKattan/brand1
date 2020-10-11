import 'package:brand/screens/homepage.dart';
import 'package:brand/screens/users/faickhome.dart';
import 'package:brand/screens/users/singUP1.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/customtextfield.dart';
import 'package:brand/widget/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginUser1 extends StatefulWidget {
  static String id = 'LoginUser1';
  @override
  _LoginUser1State createState() => _LoginUser1State();
}

class _LoginUser1State extends State<LoginUser1> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _globalkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
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
        leading: FlatButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, FaickHome.id);
            },
            child: Icon(
              Icons.clear,
              color: Colors.white,
            )),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'LogIn',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Pacifico-Regular.ttf'),
        ),
      ),
      backgroundColor: Colors.deepOrangeAccent[700],
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                color: Colors.white,
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: AssetImage('images/logo/logo1.jpg'),
                  height: 200,
                  width: 300,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Login to your account',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Form(
                key: _globalkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    SIGNlOGINTextField(
                      textTitle: 'Email',
                      textHint: 'Enter enter your email ',
                      controller: _emailTextEditingController,
                      data: Icons.email,
                      isObsecure: false,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SIGNlOGINTextField(
                        textTitle: 'PassWord',
                        textHint: 'Enter your passWord',
                        controller: _passwordTextEditingController,
                        data: Icons.lock,
                        isObsecure: true),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      color: Colors.grey,
                      child: Text('Login '),
                      onPressed: () {
                        _emailTextEditingController.text.isNotEmpty &&
                                _passwordTextEditingController.text.isNotEmpty
                            ? loginUser()
                            : showDialog(
                                context: context,
                                builder: (c) {
                                  return ErroresAlterDailog(
                                    message:
                                        'Please check write your email & passWord',
                                  );
                                });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 4.0,
                      width: widthScreen * 0.8,
                      color: Colors.grey,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Don\'t have an accont?',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, SignUP1.id);
                            },
                            child: Text(
                              'SignUP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlterDailog(
            message: 'Please wait....',
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErroresAlterDailog(
              message: error.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => MyHomePage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection(KAuthCollection)
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommercApp.sharedPreferences
          .setString('uid', dataSnapshot.data[KUid]);
      await EcommercApp.sharedPreferences
          .setString('name', dataSnapshot.data[KName]);
      await EcommercApp.sharedPreferences
          .setString('email', dataSnapshot.data[KEmail]);
      await EcommercApp.sharedPreferences
          .setString('url', dataSnapshot.data[KUrl]);
      List<String> cartList = dataSnapshot.data[KuserCartList].cast<String>();
      await EcommercApp.sharedPreferences
          .setStringList(KuserCartList, cartList);
    });
  }
}
