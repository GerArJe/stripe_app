import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';

import 'package:stripe_app/widgets/total_pay_button.dart';

class TarjetaPage extends StatelessWidget {
  const TarjetaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pagarBloc = BlocProvider.of<PagarBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            pagarBloc.add(OnDesactivarTarjeta());
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(),
          Hero(
            tag: pagarBloc.state.tarjeta!.cardNumber,
            child: CreditCardWidget(
              cardNumber: pagarBloc.state.tarjeta!.cardNumberHidden,
              expiryDate: pagarBloc.state.tarjeta!.expiracyDate,
              cardHolderName: pagarBloc.state.tarjeta!.cardHolderName,
              cvvCode: pagarBloc.state.tarjeta!.cvv,
              showBackView: false,
              onCreditCardWidgetChange: (_) {},
            ),
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
