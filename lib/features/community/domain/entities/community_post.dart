enum CommunityGroup {
  moms,
  futureMoms,
  dads,
}

class CommunityPost {
  final String id;
  final String authorName;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final CommunityGroup group;
  final int likesCount;
  final int commentsCount;
  final String? authorImageUrl;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.group,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.authorImageUrl,
  });
}
