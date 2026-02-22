// import 'package:dio/dio.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class StripServices {
//   Future<void> makepayments(double amount, String currency) async {
//     print('makepayments started with amount: $amount, currency: $currency');
//     try {
//       final paymentIntentClientSecret = await createpayment(amount, currency);
//       print('paymentIntentClientSecret: $paymentIntentClientSecret');

//       if (paymentIntentClientSecret == null) {
//         throw Exception("❌ Failed to create payment intent");
//       }

//       print('Initializing payment sheet');
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentClientSecret,
//           merchantDisplayName: 'Mudassir Ajmal',
//         ),
//       );

//       print('Presenting payment sheet');
//       await Stripe.instance.presentPaymentSheet();

//       print('✅ Payment processed successfully');
//     } on StripeException catch (e) {
//       // Stripe-specific errors (cancel, failed auth, etc.)
//       print('⚠️ Stripe error: ${e.error.localizedMessage}');
//       rethrow;
//     } catch (e, stackTrace) {
//       // Catch ALL other errors (e.g. Dio, logic, etc.)
//       print('❌ Error in makepayments: $e');
//       print('StackTrace: $stackTrace');
//       throw Exception("Payment failed due to unexpected error. Details: $e");
//     }
//   }

//   Future<String?> createpayment(double amount, String currency) async {
//     print('createpayment started with amount: $amount, currency: $currency');
//     try {
//       final dio = Dio();

//       final data = {
//         "amount": _calculateamount(amount),
//         "currency": currency,
//         "payment_method_types[]": "card",
//       };

//       print('Sending request to Stripe API');
//       final response = await dio.post(
//         'https://api.stripe.com/v1/payment_intents',
//         data: data,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           headers: {
//             "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET_KEY']}",
//             "Content-Type": 'application/x-www-form-urlencoded',
//           },
//         ),
//       );

//       print('Stripe API response: ${response.data}');
//       if (response.data != null && response.data['client_secret'] != null) {
//         return response.data['client_secret'] as String;
//       }

//       print('⚠️ No client_secret found in response');
//       return null;
//     } on DioException catch (dioError) {
//       print('❌ Dio error in createpayment: ${dioError.message}');
//       throw Exception("Network/Stripe API error: ${dioError.message}");
//     } catch (e, stackTrace) {
//       print('❌ Error in createpayment: $e');
//       print('StackTrace: $stackTrace');
//       throw Exception("Create payment error: $e");
//     }
//   }

//   String _calculateamount(double amount) {
//     final calculatedAmount = (amount * 100).toInt(); // convert to cents
//     return calculatedAmount.toString();
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeServices {
  static final StripeServices _instance = StripeServices._internal();
  factory StripeServices() => _instance;
  StripeServices._internal();

  bool _isInitialized = false;

  /// 🔹 Initialize Stripe (MUST be called once)
  Future<void> init() async {
    if (_isInitialized) return;

    final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (publishableKey == null || publishableKey.isEmpty) {
      throw Exception('Stripe Publishable Key is missing');
    }

    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();

    _isInitialized = true;
  }

  /// 🔹 Main payment function
  Future<void> makePayment(double amount, String currency) async {
    await init(); // ✅ Ensure Stripe is initialized

    try {
      final clientSecret = await _createPaymentIntent(amount, currency);

      if (clientSecret == null) {
        throw Exception('Failed to create payment intent');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Mudassir Ajmal',
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      throw Exception(e.error.localizedMessage ?? 'Stripe payment cancelled');
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }

  /// 🔹 Create PaymentIntent (⚠️ DEMO ONLY)
  /// ❗ MOVE THIS TO BACKEND FOR PRODUCTION
  Future<String?> _createPaymentIntent(
      double amount, String currency) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': (amount * 100).toInt().toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization':
                'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}', // ⚠️ DEMO ONLY
          },
        ),
      );

      return response.data['client_secret'];
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
