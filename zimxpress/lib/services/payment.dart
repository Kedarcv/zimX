import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentResult {
  String message;
  bool success;
  String? transactionId;

  PaymentResult({
    required this.message,
    required this.success,
    this.transactionId,
  });
}

class PayNowService {
  static const String apiBase = 'https://api.paynow.co.zw/v1';
  static String initiatePaymentUrl = '$apiBase/payments';
  static Uri initiatePaymentUri = Uri.parse(initiatePaymentUrl);

  static String get integrationKey {
    return dotenv.env['PAYNOW_INTEGRATION_KEY'] ?? '';
  }

  static String get integrationId {
    return dotenv.env['PAYNOW_INTEGRATION_ID'] ?? '';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>?> initiatePayment(
      String amount, String reference) async {
    try {
      Map<String, dynamic> body = {
        'id': integrationId,
        'amount': amount,
        'reference': reference,
        'additionalinfo': 'Payment for goods',
        'returnurl': '/OrderScreen',
        'resulturl': 'paymentResponse',
        'authemail': '',
      };

      String payloadToSign = json.encode(body) + integrationKey;
      String hash = generateHash(payloadToSign); // Implement this method

      body['hash'] = hash;

      var response = await http.post(
        initiatePaymentUri,
        headers: headers,
        body: json.encode(body),
      );

      return jsonDecode(response.body);
    } catch (error) {
      throw PayNowException('Failed to initiate payment: $error');
    }
  }

  static Future<PaymentResult> payWithPayNow({
    required String amount,
    required String reference,
    required BuildContext context,
    required String currency,
  }) async {
    try {
      var paymentResponse = await initiatePayment(amount, reference);

      if (paymentResponse == null || paymentResponse['status'] != 'Ok') {
        throw Exception('Failed to initiate payment');
      }

      String redirectUrl = paymentResponse['browserurl'];

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PayNowWebView(),
        ),
      );

      if (result == 'success') {
        return PaymentResult(
          message: 'Transaction successful',
          success: true,
          transactionId: paymentResponse['pollurl'].split('=').last,
        );
      } else {
        return PaymentResult(
          message: 'Transaction failed',
          success: false,
        );
      }
    } catch (error) {
      return PaymentResult(
        message: 'Transaction failed: $error',
        success: false,
      );
    }
  }

  static String generateHash(String payload) {
    // Implement hash generation here (e.g., SHA512)
    // Return the generated hash
    return '';
  }
}

class PayNowWebView extends StatefulWidget {
  // ...

  @override
  _PayNowWebViewState createState() => _PayNowWebViewState();
}

class _PayNowWebViewState extends State<PayNowWebView> {
  bool _isLoading = true;
  /// The `_webViewController` is a nullable `WebViewController` instance that is used to control the WebView
  /// widget in the `PayNowWebView` class. It is initialized when the WebView is created, and can be used
  /// to perform various operations on the WebView, such as navigating to a URL or executing JavaScript.
  WebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PayNow Payment'),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onPageFinished: (url) {
              setState(() {
                _isLoading = false;
              });
            },
            navigationDelegate: (NavigationRequest request) {
              // ... (return URL handling)
            },
            onWebResourceError: (error) {
              // Handle WebView errors
              print('WebView error: $error');
              // Show an error message to the user
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  WebView(
      {required initialUrl,
      required Null Function(dynamic controller) onWebViewCreated,
      required Null Function(dynamic url) onPageFinished,
      required Null Function(NavigationRequest request) navigationDelegate,
      required Null Function(dynamic error) onWebResourceError}) {}
}

class PayNowException implements Exception {
  final String message;
  PayNowException(this.message);

  @override
  String toString() {
    return 'PayNowException: $message';
  }
}
