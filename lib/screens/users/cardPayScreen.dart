import 'package:brand/models/product.dart';

import 'package:brand/screens/users/existingCardPayScreen.dart';
import 'package:brand/services/payment_services.dart';
import 'package:brand/widget/constants.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';


class CardPayScreen extends StatefulWidget {
  static String id = ' CardPayScreen';
  @override
  _CardPayScreenState createState() => _CardPayScreenState();
}

class _CardPayScreenState extends State<CardPayScreen> {
  onItemPress(BuildContext context, int indax) async {
    switch (indax) {
      case 0:
        //Pay by new card
        payvainewcard(context);
        break;
      case 1:
        Navigator.pushNamed(context, ExistingCard.id);
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeServices.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home  card'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: (BoxDecoration(
              gradient: LinearGradient(
                  colors: [ Colors.deepOrangeAccent[700],Colors.white],
                  begin: const FractionalOffset(0.0, 0.0),
                  end:  const FractionalOffset(1.0,0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp
              )
          )),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: (BoxDecoration(
            gradient: LinearGradient(
                colors: [ Colors.deepOrangeAccent[700],Colors.white],
                begin: const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0,0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp
            )
        )),
        child: ListView.separated(
            itemBuilder: (context, indax) {
              Icon icon;
              Text text;
              switch (indax) {
                case 0:
                  icon = Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  );
                  text = Text('Pay by new card');
                  break;
                case 1:
                  icon = Icon(
                    Icons.credit_card,
                    color: Colors.white,
                  );
                  text = Text('Pay by existing card');
                  break;
              }
              return InkWell(
                  onTap: () {
                    onItemPress(context, indax);
                  },
                  child: ListTile(
                    title: text,
                    leading: icon,
                  ));
            },
            separatorBuilder: (context, indax) => Divider(
                  color: KMainColor,
                ),
            itemCount: 2),
      ), 
    );
  }

  void payvainewcard(BuildContext context) async {
   int price = ModalRoute.of(context).settings.arguments;
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please Wait...');
    dialog.show();
    var response = await StripeServices.payWithNewCard(
      amount:'${price*100}'.toString(),

      currency: 'USD',
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: new Duration(seconds: 3),
    ));
  }

  // getTotallPrice(List<Product> products) {
  //  var price = 0;
  //   for (var product in products) {
  //     price += product.pquantity *int.parse (product.pPrice);
  //   }
  //   return price;
  // }
}
