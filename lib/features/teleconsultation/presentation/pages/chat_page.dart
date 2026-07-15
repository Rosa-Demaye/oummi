import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';

class ChatPage extends StatefulWidget {
  final String doctorName;
  const ChatPage({super.key, required this.doctorName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Bonjour Docteur. J\'ai des nausées le matin et des douleurs légères au dos.',
      'isMe': true,
      'time': '10:02'
    },
    {
      'text': 'Ces symptômes sont normaux à 24 semaines. Prenez-vous vos vitamines prénatales régulièrement?',
      'isMe': false,
      'time': '10:05'
    },
    {
      'text': 'Oui, chaque matin avec un peu d\'eau. Mais je les oublie parfois.',
      'isMe': true,
      'time': '10:07'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: const Text('DH', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctorName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    const Text('En ligne', style: TextStyle(fontSize: 12, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: AppTheme.primaryColor),
            onPressed: () => context.push('/video-call', extra: widget.doctorName),
          ),
          IconButton(icon: const Icon(Icons.call_outlined, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessage(msg);
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    bool isMe = msg['isMe'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
              ),
              boxShadow: [
                if (!isMe) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))
              ],
            ),
            child: Text(
              msg['text'],
              style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 15, height: 1.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(msg['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.attach_file, color: Colors.grey), onPressed: () {}),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Écrivez un message...', border: InputBorder.none, filled: false),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.mic_none, color: Colors.grey), onPressed: () {}),
          Container(
            decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _messages.add({'text': _controller.text, 'isMe': true, 'time': '10:10'});
                    _controller.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
