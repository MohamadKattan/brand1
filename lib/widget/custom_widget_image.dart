import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWidgetImage extends StatelessWidget {
  String image; String titel;

  CustomWidgetImage({
    @required  this.image ,@required this.titel

  }) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(image),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                titel,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontFamily: 'Pacifico'),
              ),
            )
          ],
        ),
      ),
    );
  }
}