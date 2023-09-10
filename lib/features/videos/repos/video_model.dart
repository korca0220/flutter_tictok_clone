class VideoModel {
  VideoModel({
    required this.title,
    required this.fileUrl,
    required this.description,
    required this.thumbnailUrl,
    required this.likes,
    required this.comments,
    required this.creatorUid,
    required this.creator,
    required this.createdAt,
  });
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final int likes;
  final int comments;
  final String creatorUid;
  final String creator;
  final int createdAt;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fileUrl': fileUrl,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'likes': likes,
      'comments': comments,
      'creatorUid': creatorUid,
      'creator': creator,
      'createdAt': createdAt
    };
  }
}
