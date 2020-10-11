// for circle wait enter
import 'package:brand/widget/progressDailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

displayProgressDailog(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
        opaque: false,
        // ignore: missing_return
        pageBuilder: (BuildContext context, _, __) {
          return ProgressDailog();
        }),
  );
}

// for circle wait back
closeProgressDailog(BuildContext context) {
  Navigator.of(context).pop();
}



class ErroresAlterDailog extends StatelessWidget {
  final message;

  const ErroresAlterDailog({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        RaisedButton(
          color: Colors.deepOrangeAccent[700],
          child: Center(child: Text('ok')),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}


class LoadingAlterDailog extends StatelessWidget {
  final message;

  const LoadingAlterDailog({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),

    );
  }
}
