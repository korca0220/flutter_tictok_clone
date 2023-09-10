class VideoModel {
  VideoModel({
    required this.title,
    required this.fileUrl,
    required this.description,
    required this.thumbnailUrl,
    required this.likes,
    required this.comments,
    required this.creatorUid,
    required this.createdAt,
  });
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final int likes;
  final int comments;
  final String creatorUid;
  final int createdAt;
}
