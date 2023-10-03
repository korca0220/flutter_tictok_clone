class MessageModel {
  MessageModel({
    required this.text,
    required this.userId,
  });
  final String text;
  final String userId;

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'userId': userId,
    };
  }
}
