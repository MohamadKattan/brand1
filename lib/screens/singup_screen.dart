// import 'package:brand/provider/modelhud.dart';
// import 'package:brand/screens/homepage.dart';
// import 'package:brand/screens/login_screen.dart';
// import 'package:brand/widget/custom_widget_image.dart';
// import 'package:brand/widget/customtextfield.dart';
// import 'package:flutter/material.dart';
// import 'package:brand/services/auth.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:provider/provider.dart';
// import '../widget/constants.dart';
//
// class SingUpScrren extends StatelessWidget {
//   static String id = 'SingUpScrren';
//   GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
//   String _email;
//   String _password;
//   final _auth = Auth();
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: KMainColor,
//       body: ModalProgressHUD(
//         inAsyncCall: Provider.of<ModelHud>(context).isLoading,
//         child: Form(
//           key: _globalKey,
//           child: ListView(
//             children: <Widget>[
//               SizedBox(
//                 height: height * 0.1,
//               ),
//               CustomWidgetImage(
//                 image: 'images/icons/buy.png',
//                 titel: 'Brand way',
//               ),
//               SizedBox(
//                 height: height * 0.03,
//               ),
//               CustomTextField(
//                 hint: 'Enter your name',
//                 icon: Icons.person,
//
//               ),
//               SizedBox(
//                 height: height * 0.01,
//               ),
//               CustomTextField(
//                 hint: 'Enter your email',
//                 icon: Icons.email,
//                 onClick: (value) {
//                   _email = value;
//                 },
//               ),
//               SizedBox(
//                 height: height * 0.01,
//               ),
//               CustomTextField(
//                 hint: 'Enter your password',
//                 icon: Icons.lock,
//                 onClick: (value) {
//                   _password = value;
//                 },
//               ),
//               SizedBox(
//                 height: height * 0.03,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 80),
//                 child: Builder(
//                   builder: (context) => FlatButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     onPressed: () async {
//                       final modelhud =
//                           Provider.of<ModelHud>(context, listen: false);
//                       modelhud.changeisloading(true);
//                       if (_globalKey.currentState.validate()) {
//                         _globalKey.currentState.save();
//
//                         try {
//                           final authResult = await _auth.singUp(
//                               _email.trim(), _password.trim());
//                           print(authResult.user.uid);
//                           modelhud.changeisloading(false);
//                           Navigator.pushNamed(context, MyHomePage.id);
//                         } catch (e) {
//                           modelhud.changeisloading(false);
//                           Scaffold.of(context).showSnackBar(SnackBar(
//                             backgroundColor: Colors.red,
//                             content: Text(e.message),
//                           ));
//                         }
//                       }
//                       modelhud.changeisloading(false);
//                     },
//                     color: Colors.black,
//                     child: Text(
//                       'SingUp',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 80),
//                 child: Builder(
//                   builder: (context) => FlatButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     onPressed: () async {
//                       final modelhud =
//                           Provider.of<ModelHud>(context, listen: false);
//                       modelhud.changeisloading(true);
//
//                       try {
//                         final _googleSignIn = await Auth().singInWithGoogle(context);
//
//
//                         modelhud.changeisloading(false);
//                         // Navigator.pushNamed(context, MyHomePage.id);
//                       } catch (e) {
//                         modelhud.changeisloading(false);
//                         Scaffold.of(context).showSnackBar(SnackBar(
//                           backgroundColor: Colors.red,
//                           content: Text(e.message),
//                         ));
//                       }
//
//                       modelhud.changeisloading(false);
//                     },
//                     color: Colors.red,
//                     child: Text(
//                       'SingUp with google',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: height * 0.03,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text('Do you  have an account ?',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       )),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, LoginScreen.id);
//                     },
//                     child: Text('LoginUp',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         )),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
