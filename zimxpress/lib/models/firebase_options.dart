import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    final apiKey = dotenv.env['API_KEY'] ?? '';
    final appId = dotenv.env['APP_ID'] ?? '';
    final messagingSenderId = dotenv.env['MESSAGING_SENDER_ID'] ?? '';
    final projectId = dotenv.env['PROJECT_ID'] ?? '';

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
    );
  }
}
