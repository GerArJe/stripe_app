import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  StripeService._privateContructor();
  static final StripeService _intance = StripeService._privateContructor();
  factory StripeService() => _intance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  String _secretKey =
      'sk_test_51Jrq6mHFy8QSxt6QyWYpymZM40obnfwY8u8vf06EqkpAY03PhWz8RlgI3ElaQ7IVGuIQB92flZXdjxWxAvxjnHlB00puOzmtQC';

  void init() {}

  Future pagarConTarjetaEciste({
    required String amount,
    required String currency,
    required CreditCard card,
  }) async {}
  Future pagarConNuevaTarjeta({
    required String amount,
    required String currency,
  }) async {}
  Future pagarApplePayGooglePay({
    required String amount,
    required String currency,
  }) async {}
  Future _crearPaymentIntent({
    required String amount,
    required String currency,
  }) async {}
  Future _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {}
}
