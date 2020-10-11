import 'dart:convert';
import 'package:brand/services/store.dart';
import 'package:brand/widget/constants.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

//الرسالة وتصديق الأمر في عمليات تسجيل
class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

//الوصول الى الموقع سكربت
class StripeServices {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
  static String secret =
      'sk_test_51HAE7YIGQE2XCI9qUQX6oRdAuKWzQtWu0MxWspUAunLQgIQEZjClFH5V9LVKOtZ645iyB985uPUZBhThpB6PRvd900w9pCtTea';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeServices.secret}',
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  //مفتاح اي بي الى سكربت
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            'pk_test_51HAE7YIGQE2XCI9qldkHmK6Tb8CJTjeOvin4x4vByY6xttBtz73XtbBaSxTbxz0GWUCyzwwUPUJglbPnQEZUnhtC00fnu24yYv',
        merchantId: "Test",
        androidPayMode: 'test'));
  }

//هذه طريقة دفع عن طريق كرت مسجل من قبل
  static Future<StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      var paymentIntent =
          await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successfully',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } on PlatformException catch (err) {
      return StripeServices.getPlatformExceptionResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed:${err.toString()}',
        success: false,
      );
    }
  }

//هذه اطريقة دفع الأولى
  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successfully',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } on PlatformException catch (err) {
      return StripeServices.getPlatformExceptionResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed:${err.toString()}',
        success: false,
      );
    }
  }

  // static Future<StripeTransactionResponse> CreateTokenwithCard(
  //     CreditCard card, token, String amount, String currency) async {
  //   try {
  //     var paymentMethod = await StripePayment.createPaymentMethod(
  //         PaymentMethodRequest(card: card));
  //     var paymentToken =
  //         await StripePayment.createTokenWithCard(card).then((value) {
  //       Store().addpCard(token);
  //     });
  //     var paymentIntent =
  //     await StripeServices.createPaymentIntent(amount, currency);
  //     var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
  //         clientSecret: paymentIntent['client_secret'],
  //         paymentMethodId: paymentToken.id));
  //     if (response.status == 'succeeded') {
  //       return new StripeTransactionResponse(
  //         message: 'Transaction successfully',
  //         success: true,
  //       );
  //     } else {
  //       return new StripeTransactionResponse(
  //         message: 'Transaction failed',
  //         success: false,
  //       );
  //     }
  //   } catch (e) {
  //     e.toString();
  //
  //   }
  // }

  //هذه الوظيفة من اجل اعطاء رسالة للمستخدم عن الأخطاء
  static getPlatformExceptionResult(err) {
    String message = 'Some thing went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled ';
    }
    return new StripeTransactionResponse(
      message: message,
      success: false,
    );
  }

  //هذه الوظيفة تتابع الوظيفة الأولى تعطي القيمة لها وتجلب ال سكرت كي
  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'

      };
      var response = await http.post(StripeServices.paymentApiUrl,
          body: body, headers: StripeServices.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print(err.toString());
    }
    return null;
  }
}
