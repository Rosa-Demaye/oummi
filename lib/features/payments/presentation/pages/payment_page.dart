import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String description;

  const PaymentPage({
    super.key,
    required this.amount,
    required this.description,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'Airtel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Paiement Sécurisé'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipOval(child: Image.asset('assets/images/logo.png', width: 32, height: 32)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountCard(),
            const SizedBox(height: 32),
            const Text('Mode de paiement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPaymentMethodTile('Airtel Money', Icons.phone_android, Colors.red, 'Airtel'),
            _buildPaymentMethodTile('Moov Money', Icons.phone_android, Colors.blue, 'Moov'),
            _buildPaymentMethodTile('Carte Visa / Master', Icons.credit_card, Colors.indigo, 'Visa'),
            const SizedBox(height: 48),
            _buildSecurityNotice(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _processPayment,
              child: Text('Payer avec $_selectedMethod'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total à régler', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                '${widget.amount.toStringAsFixed(0)} FCFA',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
              ),
            ],
          ),
          const Icon(Icons.verified_user, color: AppTheme.primaryColor, size: 40),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String name, IconData icon, Color color, String value) {
    bool isSelected = _selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey.shade100, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: Colors.amber, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text('Vos fonds sont protégés et libérés uniquement après confirmation de la consultation.', style: TextStyle(fontSize: 12, color: Colors.brown))),
        ],
      ),
    );
  }

  void _processPayment() {
    showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      _showSuccessOverlay();
    });
  }

  void _showSuccessOverlay() {
    showDialog(context: context, barrierDismissible: false, builder: (c) => _SuccessDialog(amount: widget.amount));
  }
}

class _SuccessDialog extends StatefulWidget {
  final double amount;
  const _SuccessDialog({required this.amount});
  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              const Text('Succès !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Paiement de ${widget.amount.toStringAsFixed(0)} FCFA confirmé.', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Terminer')),
            ],
          ),
        ),
      ),
    );
  }
}
