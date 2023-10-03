import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message_model.dart';

final messagesRepo = Provider((ref) => MessagesRepo());

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(
    MessageModel message, {
    String chatId =
        'esvOK0onpVevXpcXeRmfLt9ZEHy2@@@0z89sqcEbgg1OiBeZSGlEKU9wlx2',
  }) async {
    final personList = chatId.split('@@@');
    final query = _db.collection('chat_rooms').doc(chatId);
    final chat = await query.get();

    if (!chat.exists) {
      await query.set({
        'personA': personList[0],
        'personB': personList[1],
      });
    }

    await query.collection('texts').add(
          message.toJson(),
        );
  }
}
