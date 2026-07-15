import 'package:flutter/material.dart';
import '../../domain/entities/community_post.dart';
import '../../../../theme/app_theme.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<CommunityPost> _mockPosts = [
    CommunityPost(
      id: '1',
      authorName: 'Aïcha Hassan',
      authorId: 'u1',
      content: 'Je voulais partager ma joie! Après une grossesse difficile, j\'ai accouché d\'un beau garçon de 3,2kg hier. Merci à toute la communauté OUMI! 💙',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      group: CommunityGroup.moms,
      likesCount: 47,
      commentsCount: 23,
    ),
    CommunityPost(
      id: '2',
      authorName: 'Fatima Mahamat',
      authorId: 'u2',
      content: 'Le Dr. Idriss m\'a recommandé de faire plus d\'exercice léger. Est-ce que certaines d\'entre vous font du yoga prénatal à N\'Djamena?',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      group: CommunityGroup.futureMoms,
      likesCount: 12,
      commentsCount: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Communauté'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockPosts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildCategoryChips();
          final post = _mockPosts[index - 1];
          return _buildPostCard(post);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _buildHashtagChip('#premierTrimestre'),
          _buildHashtagChip('#nausees'),
          _buildHashtagChip('#accouchement'),
          _buildHashtagChip('#conseils'),
        ],
      ),
    );
  }

  Widget _buildHashtagChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Text(label, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade100)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: AppTheme.primaryColor, child: Text(post.authorName[0], style: const TextStyle(color: Colors.white))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text('Tchad • Il y a quelques heures', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              children: [
                _buildActionButton(Icons.favorite_border, '${post.likesCount}', Colors.red),
                const SizedBox(width: 24),
                _buildActionButton(Icons.chat_bubble_outline, '${post.commentsCount}', Colors.blue),
                const Spacer(),
                const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count, Color color) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 6),
          Text(count, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
