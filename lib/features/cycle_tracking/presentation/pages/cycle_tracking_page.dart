import 'package:flutter/material.dart';

class CycleTrackingPage extends StatelessWidget {
  const CycleTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Mon Cycle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCycleStat(context, '28j', 'Cycle'),
                _buildCycleStat(context, '5j', 'Règles'),
                _buildCycleStat(context, 'J11-15', 'Fertilité'),
              ],
            ),
            const SizedBox(height: 32),

            // Calendar Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Juillet 2024', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Row(
                        children: [
                          Icon(Icons.chevron_left, color: Colors.grey.shade400),
                          const SizedBox(width: 16),
                          Icon(Icons.chevron_right, color: Colors.grey.shade400),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildCalendarGrid(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildCalendarLegend(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Ovulation Banner
            _buildOvulationBanner(),
            const SizedBox(height: 32),

            // Mood Selector
            const Text('Comment vous sentez-vous ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _buildMoodSelector(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildCycleStat(
      BuildContext context,
      String value,
      String label,
      ) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3.2,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFFD97D64),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCalendarGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((d) => Text(d, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))).toList(),
        ),
        const SizedBox(height: 16),
        _buildCalendarRow([1, 2, 3, 4, 5, 6, 7], redDays: [1, 2, 3, 4, 5]),
        _buildCalendarRow([8, 9, 10, 11, 12, 13, 14], greenDays: [12, 13], orangeDays: [14]),
        _buildCalendarRow([15, 16, 17, 18, 19, 20, 21], greenDays: [15, 16]),
        _buildCalendarRow([22, 23, 24, 25, 26, 27, 28], spmDays: [25, 26, 27]),
      ],
    );
  }

  Widget _buildCalendarRow(List<int> days, {List<int> redDays = const [], List<int> greenDays = const [], List<int> orangeDays = const [], List<int> spmDays = const []}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((d) {
          Color? bgColor;
          Color textColor = Colors.black87;

          if (redDays.contains(d)) {
            bgColor = Colors.red.shade400;
            textColor = Colors.white;
          } else if (greenDays.contains(d)) {
            bgColor = Colors.green.shade400;
            textColor = Colors.white;
          } else if (orangeDays.contains(d)) {
            bgColor = const Color(0xFF00695C); // Ovulation
            textColor = Colors.white;
          } else if (spmDays.contains(d)) {
            bgColor = Colors.orange.shade400;
            textColor = Colors.white;
          }

          return Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bgColor ?? Colors.transparent,
              shape: BoxShape.circle,
              border: d == 14 ? Border.all(color: Colors.black12, width: 1) : null,
            ),
            child: Center(
              child: Text('$d', style: TextStyle(color: textColor, fontWeight: bgColor != null ? FontWeight.bold : FontWeight.normal)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(Colors.red.shade400, 'Règles'),
        _legendItem(Colors.green.shade400, 'Fertile'),
        _legendItem(const Color(0xFF00695C), 'Ovulation'),
        _legendItem(Colors.orange.shade400, 'SPM'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildOvulationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD97D64).withValues(alpha: 0.8), // Peach from Figma
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AUJOURD\'HUI — JOUR 14', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1)),
          SizedBox(height: 12),
          Text('Pic d\'ovulation 🌿', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 12),
          Text(
            'Fertilité maximale. Enregistrez vos symptômes.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final List<String> emojis = ['😊', '😐', '😔', '😫', '😴', '🤢'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: emojis.map((e) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          shape: BoxShape.circle,
        ),
        child: Text(e, style: const TextStyle(fontSize: 24)),
      )).toList(),
    );
  }
}
