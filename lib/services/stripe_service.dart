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

  Future<StripeCustomResponse> pagarConTarjetaExiste({
    required String amount,
    required String currency,
    required CreditCard card,
  }) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      final resp = await _realizarPago(
          amount: amount, currency: currency, paymentMethod: paymentMethod);
      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    required String amount,
    required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      final resp = await _realizarPago(
          amount: amount, currency: currency, paymentMethod: paymentMethod);
      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> pagarApplePayGooglePay({
    required String amount,
    required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;
      final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions: AndroidPayPaymentRequest(
              currencyCode: currency, totalPrice: amount),
          applePayOptions: ApplePayPaymentOptions(
            countryCode: 'US',
            currencyCode: currency,
            items: [
              ApplePayItem(
                label: 'Super prodcuto',
                amount: amount,
              ),
            ],
          ));
      final paymentMethod =
          await StripePayment.createPaymentMethod(PaymentMethodRequest(
        card: CreditCard(token: token.tokenId),
      ));
      final resp = await _realizarPago(
          amount: amount, currency: currency, paymentMethod: paymentMethod);
      await StripePayment.completeNativePayRequest();
      return resp;
    } catch (e) {
      print('Error en intento: ${e.toString()}');
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

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

  Future<StripeCustomResponse> _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      // Crear intento
      final paymentIntent =
          await _crearPaymentIntent(amount: amount, currency: currency);
      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymentMethod.id,
        ),
      );
      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
            ok: false, msg: 'Fallo: ${paymentResult.status}');
      }
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
