import 'package:brand/services/payment_services.dart';
import 'package:brand/widget/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCard extends StatefulWidget {
  static String id = 'ExistingCard';
  @override
  _ExistingCardState createState() => _ExistingCardState();
}

class _ExistingCardState extends State<ExistingCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/23',
      'cardHolderName': 'MOHAMADKATTAN',
      'cvvCode': '123',
      'showBackView': false,
    },
  ];
  payViaExistingCard(BuildContext context, card)async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please Wait...');
    dialog.show();
    var expiryArr = card['expiryDate'].split( '/');
    CreditCard  stripeCard = CreditCard(
     number: card['cardNumber'],
     expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response =await StripeServices.payViaExistingCard(
        amount: '2500',
        currency: 'USD',
        card: stripeCard);
    if (response.success = true) {
      await dialog.hide();
      Scaffold.of(context)
          .showSnackBar(SnackBar(
            content: Text(response.message),
            duration: new Duration(seconds: 3),
          ))
          .closed
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose existing card'),
        centerTitle: true,
        backgroundColor: KMainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int indax) {
                var card = cards[indax];
                return InkWell(
                  onTap: () {
                    payViaExistingCard(context, card);
                  },
                  child: CreditCardWidget(
                    cardNumber: card['cardNumber'],
                    expiryDate: card['expiryDate'],
                    cardHolderName: card['cardHolderName'],
                    cvvCode: card['cvvCode'],
                    showBackView: false,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
