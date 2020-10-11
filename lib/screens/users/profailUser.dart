import 'dart:io';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProfailUser extends StatefulWidget {
  static String id = 'ProfailUser';
  @override
  _ProfailUserState createState() => _ProfailUserState();
}

class _ProfailUserState extends State<ProfailUser> {
  Store _store = Store();
  File _imageFile;
  String userImageUrl = '';

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    final double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent[700],
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.deepOrangeAccent[700],
        centerTitle: false,
      ),
      body: ListView(
        children: [
          SizedBox(height: 15.0),
          Container(
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        EcommercApp.sharedPreferences.getString(KUrl)),
                    radius: widthScreen * 0.25,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'My Name:',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(EcommercApp.sharedPreferences.getString(KName)),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'My Email Account:',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      Text(EcommercApp.sharedPreferences.getString(KEmail)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
