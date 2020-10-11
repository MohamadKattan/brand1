
import 'package:brand/widget/constants.dart';
import 'package:flutter/material.dart';
//text faild
class CustomTextField extends StatelessWidget {
 final String hint;
 final IconData icon;
 final Function onClick;

  String _erroemessage(String str){
    switch(hint){
      case 'Enter your name': return'Name is empty';
      case'Enter your password': return ' PassWord is empty';
      case  'Enter your email': return'Email is empty';
    }
  }
  CustomTextField({  @required this.onClick ,@required this.icon, @required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty) {
            return _erroemessage(hint);
          }
        },
        onSaved: onClick,
        obscureText: hint=='Enter your password'?true:false ,
        decoration: InputDecoration(
          filled: true,
          fillColor: KScondaryColor,
          prefixIcon: Icon(
            icon,
            color: KMainColor,
          ),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}



//من أجل صفحة أدمن
// ignore: non_constant_identifier_names
Widget ProductTextField({
  String textTitle,
  String textHint,
  TextEditingController controller,
  double height,
  TextInputType textType,
   int maxLines,
  IconData data,

}) {
  // ignore: unnecessary_statements
  textHint == null ? textHint = 'Enter hint' : textHint;
  // ignore: unnecessary_statements
  height == null ? height = 50.0 : height;
  // ignore: unnecessary_statements
  textTitle == null ? textTitle = 'Enter title' : textTitle;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          textTitle,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          padding: EdgeInsets.only(right: 8.0, left: 8.0),
          child: TextField(

            controller: controller,
            keyboardType: textType == null ? TextInputType.text : textType,
             maxLines: maxLines==null?null:maxLines ,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: textHint,
              prefixIcon: Icon(data)
            ),
          ),
        ),
      ),
    ],
  );
}

Widget SIGNlOGINTextField({
  String textTitle,
  String textHint,
  TextEditingController controller,
  double height,
  TextInputType textType,

  IconData data,
  bool isObsecure = true,
}) {
  // ignore: unnecessary_statements
  textHint == null ? textHint = 'Enter hint' : textHint;
  // ignore: unnecessary_statements
  height == null ? height = 50.0 : height;
  // ignore: unnecessary_statements
  textTitle == null ? textTitle = 'Enter title' : textTitle;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          textTitle,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          padding: EdgeInsets.only(right: 8.0, left: 8.0),
          child: TextField(
            obscureText: isObsecure,
            controller: controller,
            keyboardType: textType == null ? TextInputType.text : textType,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: textHint,
                prefixIcon: Icon(data,color: Colors.deepOrangeAccent[700],)
            ),
          ),
        ),
      ),
    ],
  );
}