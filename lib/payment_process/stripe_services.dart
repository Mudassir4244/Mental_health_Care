import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mental_healthcare/payment_process/stripe_const.dart';

class StripServices {
  Future<void> makepayments(double amount, String currency) async {
    print('makepayments started with amount: $amount, currency: $currency');
    try {
      String? paymentIntentClientSecret = await createpayment(amount, currency);
      print('paymentIntentClientSecret: $paymentIntentClientSecret');
      if (paymentIntentClientSecret == null) {
        throw Exception("Failed to create payment intent");
      }
      print('Initializing payment sheet');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Mudassir Ajmal',
          // Restricted to Stripe card payments only
        ),
      );
      print('Presenting payment sheet');
      await Stripe.instance
          .presentPaymentSheet(); // Handles card payment confirmation
      print('Payment processed successfully');
    } catch (e) {
      print('Error in makepayments: $e');
      throw Exception("Payment error: $e"); // Propagate to caller
    }
  }

  Future<String?> createpayment(double amount, String currency) async {
    print('createpayment started with amount: $amount, currency: $currency');
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateamount(amount), // Amount in cents
        "currency": currency,
        "payment_method_types[]": [
          'card',
        ], // Explicitly restricted to card payments
      };
      print('Sending request to Stripe API');
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripe_secretkey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );
      print('Stripe API response: ${response.data}');
      if (response.data != null && response.data['client_secret'] != null) {
        return response.data['client_secret'] as String;
      }
      print('No client_secret in response');
      return null;
    } catch (e) {
      print('Error in createpayment: $e');
      throw Exception("Create payment error: $e");
    }
  }

  String _calculateamount(double amount) {
    final calculatedAmount = (amount * 100).toInt(); // Convert to cents
    return calculatedAmount.toString();
  }
}
