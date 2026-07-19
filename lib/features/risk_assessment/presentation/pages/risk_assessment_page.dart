import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/risk_provider.dart';
import '../../domain/entities/risk_assessment.dart';
import '../../domain/entities/vitals.dart';
import '../../domain/services/risk_engine.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class RiskAssessmentPage extends ConsumerStatefulWidget {
  const RiskAssessmentPage({super.key});

  @override
  ConsumerState<RiskAssessmentPage> createState() => _RiskAssessmentPageState();
}

class _RiskAssessmentPageState extends ConsumerState<RiskAssessmentPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final Map<String, bool> _symptoms = {
    'bleeding': false,
    'reduced_movement': false,
    'fever': false,
    'swelling': false,
    'severe_headache': false,
    'abdominal_pain': false,
  };

  final _bpController = TextEditingController(text: '120/80');
  final _weightController = TextEditingController(text: '70');
  final _glucoseController = TextEditingController(text: '90');

  @override
  void dispose() {
    _pageController.dispose();
    _bpController.dispose();
    _weightController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(duration: 400.ms, curve: Curves.easeInOut);
    } else {
      _processAssessment();
    }
  }

  void _processAssessment() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    setState(() => _currentStep = 2); // Processing

    final vitals = Vitals(
      bloodPressure: _bpController.text,
      weight: double.tryParse(_weightController.text) ?? 70.0,
      glucose: int.tryParse(_glucoseController.text) ?? 90,
    );

    final assessment = RiskEngine.calculate(user.id, _symptoms, vitals);
    
    await ref.read(riskNotifierProvider.notifier).submitAssessment(assessment);
    
    if (mounted) {
      _showResults(assessment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bilan de Santé OUMMI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
              _pageController.previousPage(duration: 400.ms, curve: Curves.easeInOut);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSymptomStep(),
                _buildVitalsStep(),
                _buildProcessingStep(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _currentStep < 2 ? _buildBottomBar() : null,
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(2, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSymptomStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comment vous sentez-vous ?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Cochez les symptômes que vous ressentez actuellement.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ..._symptoms.keys.map((key) {
            String title = '';
            switch (key) {
              case 'bleeding': title = 'Saignements vaginaux'; break;
              case 'reduced_movement': title = 'Réduction des mouvements du bébé'; break;
              case 'fever': title = 'Fièvre ou frissons'; break;
              case 'swelling': title = 'Gonflement (mains, visage, pieds)'; break;
              case 'severe_headache': title = 'Maux de tête sévères'; break;
              case 'abdominal_pain': title = 'Douleur abdominale intense'; break;
            }
            return _buildSymptomTile(title, key);
          }),
        ],
      ),
    );
  }

  Widget _buildSymptomTile(String title, String key) {
    final isSelected = _symptoms[key]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      child: CheckboxListTile(
        title: Text(title, style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textMain,
        )),
        value: isSelected,
        onChanged: (val) => setState(() => _symptoms[key] = val!),
        activeColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildVitalsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vos signes vitaux',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Entrez vos dernières mesures pour une analyse précise.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildVitalInput('Tension Artérielle', 'systolique/diastolique', _bpController, Icons.speed),
          const SizedBox(height: 24),
          _buildVitalInput('Poids (kg)', 'ex: 68', _weightController, Icons.monitor_weight_outlined),
          const SizedBox(height: 24),
          _buildVitalInput('Glycémie (mg/dL)', 'ex: 95', _glucoseController, Icons.bloodtype_outlined),
        ],
      ),
    );
  }

  Widget _buildVitalInput(String label, String hint, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.secondary),
          ),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildProcessingStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 32),
          Text(
            'Analyse OUMMI AI...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Nous croisons vos données avec les\nnormes de santé nationales.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ).animate().fadeIn(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _nextStep,
          child: Text(_currentStep == 0 ? 'Continuer' : 'Analyser mon état'),
        ),
      ),
    );
  }

  void _showResults(RiskAssessment result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildResultOverlay(result),
    ).then((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  Widget _buildResultOverlay(RiskAssessment result) {
    Color color;
    IconData icon;
    switch (result.level) {
      case RiskLevel.low: color = AppColors.success; icon = Icons.check_circle_outline; break;
      case RiskLevel.medium: color = AppColors.warning; icon = Icons.warning_amber_rounded; break;
      case RiskLevel.high: color = AppColors.error; icon = Icons.emergency_outlined; break;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 24),
          
          // Risk Gauge
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: result.score / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${result.score}%',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
                  ),
                  const Text('Risque', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ).animate().scale(delay: 200.ms),

          const SizedBox(height: 40),
          Text(
            result.level == RiskLevel.low ? 'Tout va bien !' : 
            result.level == RiskLevel.medium ? 'Attention requise' : 'Urgence Médicale',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              result.recommendations,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.6, fontSize: 15),
            ),
          ),
          
          const Spacer(),
          if (result.level != RiskLevel.low)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: Text(result.level == RiskLevel.high ? 'Appeler un Médecin' : 'Prendre Rendez-vous'),
            ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer le bilan'),
          ),
        ],
      ),
    );
  }
}
