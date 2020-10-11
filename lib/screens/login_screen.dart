import 'package:brand/provider/adminmode.dart';
import 'package:brand/provider/modelhud.dart';
import 'package:brand/screens/admin/adminhome.dart';
import 'package:brand/screens/homepage.dart';
import 'package:brand/screens/singup_screen.dart';
import 'package:brand/screens/users/singUP1.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/custom_widget_image.dart';
import 'package:brand/widget/customtextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brand/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String _email, password;

  final _auth = Auth();

  bool isAdmin = false;

  final adminPassword = 'admin1234';

  bool keepmeloggedIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: KMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: height * 0.1,
              ),
              CustomWidgetImage(
                image: 'images/icons/buy.png',
                titel: 'Brand way',
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomTextField(
                onClick: (value) {
                  _email = value;
                },
                hint: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              CustomTextField(
                onClick: (value) {
                  password = value;
                },
                hint: 'Enter your password',
                icon: Icons.lock,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: KMainColor,
                        value: keepmeloggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepmeloggedIn = value;
                          });
                        },
                      ),
                    ),
                    Text('RememberMe',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      if(keepmeloggedIn==true){
                        keepUserloggedIn();
                      }
                      _validate(context);
                    },
                    color: Colors.black,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async{
                      // if(keepmeloggedIn==true){
                      //   keepUserloggedIn();
                      // }
                      final modelhud =
                      Provider.of<ModelHud>(context, listen: false);
                      modelhud.changeisloading(true);

                      try {
                        final _googleSignIn = await Auth().singInWithGoogle(context);


                        modelhud.changeisloading(false);
                        Navigator.pushNamed(context, MyHomePage.id);
                      } catch (e) {
                        modelhud.changeisloading(false);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.message),
                        ));
                      }

                      modelhud.changeisloading(false);

                    },
                    color: Colors.red,
                    child: Text(
                      'Login with google',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Don\'t you have an account ?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUP1.id);
                    },
                    child: Text('SingUp',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeisadmin(true);
                        },
                        child: Text(
                          'I\'m an Admin',
                          style: TextStyle(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? KMainColor
                                  : Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeisadmin(false);
                        },
                        child: Text(
                          'I\'m an  User',
                          style: TextStyle(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? Colors.white
                                  : KMainColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
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

  void _validate(BuildContext context) async {
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeisloading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (password == adminPassword) {
          try {
            await _auth.singIn(_email.trim(), password.trim());
            modelhud.changeisloading(false);
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelhud.changeisloading(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          modelhud.changeisloading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Some Thing is wrong'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        try {
          modelhud.changeisloading(false);
          await _auth.singIn(_email, password);
          modelhud.changeisloading(false);
          Navigator.pushNamed(context, MyHomePage.id);
        } catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
    modelhud.changeisloading(false);
  }

  void keepUserloggedIn() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setBool(KKeepMeloggedIN, keepmeloggedIn);
  }
}
