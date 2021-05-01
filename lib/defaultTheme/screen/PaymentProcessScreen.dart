import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/main/utils/AppWidget.dart';

class PaymentProcessScreen extends StatefulWidget {
  final bool isSuccessFul;

  PaymentProcessScreen({this.isSuccessFul});

  @override
  _PaymentProcessScreenState createState() => _PaymentProcessScreenState();
}

class _PaymentProcessScreenState extends State<PaymentProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, ''),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.isSuccessFul ? 'images/defaultTheme/successfull.png' : 'images/defaultTheme/cancel.png',
                height: 100,
                width: 100,
              ),
              8.height,
              Text(
                widget.isSuccessFul ? 'Payment Successful' : 'Payment Failed',
                style: boldTextStyle(color: widget.isSuccessFul ? greenColor : redColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
