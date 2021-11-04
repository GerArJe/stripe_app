import 'package:dio/dio.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_app/models/payment_intent_response.dart';

class StripeService {
  StripeService._privateContructor();
  static final StripeService _intance = StripeService._privateContructor();
  factory StripeService() => _intance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String _secretKey =
      'sk_test_51Jrq6mHFy8QSxt6QyWYpymZM40obnfwY8u8vf06EqkpAY03PhWz8RlgI3ElaQ7IVGuIQB92flZXdjxWxAvxjnHlB00puOzmtQC';
  String _apiKey =
      'pk_test_51Jrq6mHFy8QSxt6Q6yCxbh7cbXrZyszilqdwThK8XAmbUjyndQvd8f3uwAMCyhdeJlhdtY9GG2xvIDe1qXQ06JTN009z5isbSD';
  final headerOptions =
      Options(contentType: Headers.formUrlEncodedContentType, headers: {
    'Authorization': 'Bearer ${StripeService._secretKey}',
  });

  void init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: _apiKey,
      androidPayMode: 'test',
      merchantId: 'test',
    ));
  }

  Future pagarConTarjetaEciste({
    required String amount,
    required String currency,
    required CreditCard card,
  }) async {}

  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    required String amount,
    required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      final resp =
          await _crearPaymentIntent(amount: amount, currency: currency);
      return StripeCustomResponse(ok: true);
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future pagarApplePayGooglePay({
    required String amount,
    required String currency,
  }) async {}

  Future<PaymentInentReponse> _crearPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      final dio = Dio();
      final data = {
        'amount': amount,
        'currency': currency,
      };
      final resp = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions,
      );
      return PaymentInentReponse.fromJson(resp.data);
    } catch (e) {
      print('Error en intento: ${e.toString()}');
      return PaymentInentReponse(status: '400');
    }
  }

  Future _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {}
}
