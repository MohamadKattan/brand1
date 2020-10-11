
import 'dart:io';
import 'package:brand/screens/homepage.dart';
import 'package:brand/widget/constants.dart';
import 'package:brand/widget/customtextfield.dart';
import 'package:brand/widget/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUP1 extends StatefulWidget {
  static String id = 'SignUP1';
  @override
  _SignUP1State createState() => _SignUP1State();
}

class _SignUP1State extends State<SignUP1> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _globalkey = GlobalKey<FormState>();
  String userImageUrl = '';
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent[700],
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 40.0,
              ),
              InkWell(
                onTap: _selecteImageAndPickup,
                child: CircleAvatar(
                  radius: widthScreen * 0.10,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _imageFile == null ? null : FileImage(_imageFile),
                  child: _imageFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: widthScreen * 0.10,
                          color: Colors.deepOrangeAccent[700],
                        )
                      : null,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Form(
                key: _globalkey,
                child: Column(
                  children: [
                    SIGNlOGINTextField(
                        textTitle: 'Name',
                        textHint: 'Enter yourname ',
                        controller: _nameTextEditingController,
                        data: Icons.person,
                        isObsecure: false),
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
                    SIGNlOGINTextField(
                        textTitle: 'Confirm PassWORD',
                        textHint: 'Enter Confirm PassWORD',
                        controller: _cpasswordTextEditingController,
                        isObsecure: true,
                        data: Icons.lock),
                    SizedBox(
                      height: 15.0,
                    ),
                    Builder(
                      builder: (context) => RaisedButton(
                        color: Colors.grey,
                        child: Text('Sign UP '),
                        onPressed: () {
                          SignUploadImageUser(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: 4.0,
                      width: widthScreen * 0.8,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 15,
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

  Future<void> _selecteImageAndPickup() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> SignUploadImageUser(BuildContext context) async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErroresAlterDailog(
              message: 'please select an image ',
            );
          });
    }
    if (_passwordTextEditingController.text !=
        _cpasswordTextEditingController.text) {
      return displayDailog('Check your PassWord');
    }
    if (_passwordTextEditingController.text ==
        _cpasswordTextEditingController.text) {
      _emailTextEditingController.text.isNotEmpty &&
              _passwordTextEditingController.text.isNotEmpty &&
              _cpasswordTextEditingController.text.isNotEmpty &&
              _nameTextEditingController.text.isNotEmpty
          ? uploadToStorage()
          : displayDailog('Check your Info');

      return;
    }
  }

  Future<void> displayDailog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlterDailog(message: msg);
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlterDailog(
            message: 'loding....',
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  final _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
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
      saveUSERInfToFirestor(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c)=>MyHomePage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUSERInfToFirestor(FirebaseUser fUser) async {
    Firestore.instance.collection(KAuthCollection).document(fUser.uid).setData({
      KUid: fUser.uid,
      KName: _nameTextEditingController.text.trim(),
      KEmail: fUser.email,
      KUrl: userImageUrl,
      KuserCartList:["garbageValue"],
    });
    await EcommercApp.sharedPreferences.setString(KUid, fUser.uid);
    await EcommercApp.sharedPreferences.setString(KEmail, fUser.email);
    await EcommercApp.sharedPreferences.setString(KUrl, userImageUrl);
    await EcommercApp.sharedPreferences.setString(
      KName,
      _nameTextEditingController.text.trim(),
    );
    await EcommercApp.sharedPreferences.setStringList(KuserCartList, ["garbageValue"]);

  }
}
