import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//this widget incloding image picker+removeImage using in addproduct page
Widget MultiImagePickterLis(
    {List<File> imageList, VoidCallback removeNewImage(int position)}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    child: imageList == null || imageList.length == 0
        ? Container()
        : SizedBox(
      height: 150,
      child: ListView.builder(
          itemCount: imageList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 3.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(100),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(imageList[index])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: IconButton(
                        onPressed:(){removeNewImage(index);} ,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    ),
  );
}