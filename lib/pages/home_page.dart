import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:stripe_app/data/tarjetas.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            top: 150,
            child: PageView.builder(
                controller: PageController(
                  viewportFraction: 0.9,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: tarjetas.length,
                itemBuilder: (_, i) {
                  final tarjeta = tarjetas[i];
                  return CreditCardWidget(
                    cardNumber: tarjeta.cardNumberHidden,
                    expiryDate: tarjeta.expiracyDate,
                    cardHolderName: tarjeta.cardHolderName,
                    cvvCode: tarjeta.cvv,
                    showBackView: false,
                    onCreditCardWidgetChange: (_) {},
                  );
                }),
          ),
          Positioned(
            bottom: 0,
            child: TotalPayButton(),
          ),
        ],
      ),
    );
  }
}
