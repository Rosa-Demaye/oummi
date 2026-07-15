import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VideoCallPage extends StatefulWidget {
  final String doctorName;
  const VideoCallPage({super.key, required this.doctorName});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background: Doctor's Video (Simulated with a placeholder image)
          Positioned.fill(
            child: Opacity(
              opacity: 0.8,
              child: Image.network(
                'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=1000',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Top Overlay: Doctor Name & Status
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      const Text('EN DIRECT', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // User's Small Camera Preview
          Positioned(
            top: 120,
            right: 24,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?u=fatima'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  widget.doctorName,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '12:45',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCallAction(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? Colors.white : Colors.white24,
                      iconColor: _isMuted ? Colors.black : Colors.white,
                      onTap: () => setState(() => _isMuted = !_isMuted),
                    ),
                    const SizedBox(width: 20),
                    _buildCallAction(
                      icon: Icons.call_end,
                      color: Colors.red,
                      iconSize: 32,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 20),
                    _buildCallAction(
                      icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
                      color: _isVideoOff ? Colors.white : Colors.white24,
                      iconColor: _isVideoOff ? Colors.black : Colors.white,
                      onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallAction({
    required IconData icon,
    required Color color,
    Color iconColor = Colors.white,
    double iconSize = 24,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
