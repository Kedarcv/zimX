import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class MessagingScreen extends StatefulWidget {
  final String shopId;

  MessagingScreen({required this.shopId});

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String _userId;
  late encrypt.Encrypter _encrypter;
  late encrypt.IV _iv;

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
    final key = encrypt.Key.fromLength(32);
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  String _encryptMessage(String message) {
    final encrypted = _encrypter.encrypt(message, iv: _iv);
    return encrypted.base64;
  }

  String _decryptMessage(String encryptedMessage) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedMessage);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Shop'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('shopId', isEqualTo: widget.shopId)
                  .where('userId', isEqualTo: _userId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(_decryptMessage(message['text'])),
                      subtitle: Text(message['sender']),
                    );
                  },
                );
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final encryptedMessage =
                            _encryptMessage(_messageController.text);
                        await FirebaseFirestore.instance
                            .collection('messages')
                            .add({
                          'text': encryptedMessage,
                          'timestamp': Timestamp.now(),
                          'userId': _userId,
                          'shopId': widget.shopId,
                          'sender': 'Client',
                        });
                        _messageController.clear();
                      }
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
