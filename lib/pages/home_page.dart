import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:stripe_app/data/tarjetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';
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
            onPressed: () async {
              // mostrarLoading(context);
              // await Future.delayed(Duration(seconds: 1));
              // Navigator.pop(context);
              mostrarAlerta(context, 'Hola', 'Mundo');
            },
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, navegarFadeIn(context, TarjetaPage()));
                    },
                    child: Hero(
                      tag: tarjeta.cardNumber,
                      child: CreditCardWidget(
                        cardNumber: tarjeta.cardNumberHidden,
                        expiryDate: tarjeta.expiracyDate,
                        cardHolderName: tarjeta.cardHolderName,
                        cvvCode: tarjeta.cvv,
                        showBackView: false,
                        onCreditCardWidgetChange: (_) {},
                      ),
                    ),
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
