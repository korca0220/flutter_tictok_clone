import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message_model.dart';

final messagesRepo = Provider((ref) => MessagesRepo());

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _db
        .collection('chat_rooms')
        .doc('9fjegk3QyMadsoNpBeCM')
        .collection('texts')
        .add(
          message.toJson(),
        );
  }
}
