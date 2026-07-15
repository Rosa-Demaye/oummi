import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  int _currentStep = 0;
  UserRole? _selectedRole;
  DoctorSpecialty _selectedSpecialty = DoctorSpecialty.none;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _quartierController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _quartierController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedRole != null) {
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (_formKey.currentState!.validate()) {
        if (_selectedRole == UserRole.doctor) {
          setState(() => _currentStep = 2);
        } else {
          _handleRegister();
        }
      }
    }
  }

  void _handleRegister() async {
    await ref.read(authNotifierProvider.notifier).signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text,
      role: _selectedRole!,
      phoneNumber: _phoneController.text,
      quartier: _quartierController.text,
      specialty: _selectedSpecialty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AsyncValue>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_currentStep == 0 ? 'Rejoindre OUMI' : 'Inscription'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentStep == 0 
            ? _buildRoleSelection() 
            : _currentStep == 1 ? _buildBasicInfo() : _buildRoleSpecificInfo(),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(authState),
    );
  }

  Widget _buildRoleSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comment souhaitez-vous utiliser OUMI ?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Choisissez le profil qui vous correspond le mieux.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _RoleCard(
            role: UserRole.pregnant,
            title: 'Femme Enceinte',
            subtitle: 'Suivi de grossesse & Maternité',
            icon: Icons.pregnant_woman,
            color: AppColors.primary,
            isSelected: _selectedRole == UserRole.pregnant,
            onTap: () => setState(() => _selectedRole = UserRole.pregnant),
          ),
          _RoleCard(
            role: UserRole.girl,
            title: 'Jeune Fille',
            subtitle: 'Santé reproductive & Cycle',
            icon: Icons.female,
            color: Colors.pink.shade300,
            isSelected: _selectedRole == UserRole.girl,
            onTap: () => setState(() => _selectedRole = UserRole.girl),
          ),
          _RoleCard(
            role: UserRole.father,
            title: 'Père / Mari',
            subtitle: 'Accompagnement & Soutien',
            icon: Icons.male,
            color: AppColors.secondary,
            isSelected: _selectedRole == UserRole.father,
            onTap: () => setState(() => _selectedRole = UserRole.father),
          ),
          _RoleCard(
            role: UserRole.doctor,
            title: 'Médecin / Sage-femme',
            subtitle: 'Gestion des patientes',
            icon: Icons.medical_services_outlined,
            color: Colors.indigo,
            isSelected: _selectedRole == UserRole.doctor,
            onTap: () => setState(() => _selectedRole = UserRole.doctor),
          ),
          _RoleCard(
            role: UserRole.hospital,
            title: 'Hôpital / Clinique',
            subtitle: 'Opérations & Urgences',
            icon: Icons.local_hospital_outlined,
            color: AppColors.error,
            isSelected: _selectedRole == UserRole.hospital,
            onTap: () => setState(() => _selectedRole = UserRole.hospital),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vos informations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nom complet',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) => v!.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: (v) => v!.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Téléphone',
                prefixIcon: Icon(Icons.phone_android_outlined),
              ),
              validator: (v) => v!.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quartierController,
              decoration: const InputDecoration(
                hintText: 'Quartier / Ville',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (v) => v!.length < 6 ? 'Min 6 caractères' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSpecificInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails professionnels',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          DropdownButtonFormField<DoctorSpecialty>(
            initialValue: _selectedSpecialty,
            decoration: const InputDecoration(
              labelText: 'Votre spécialité',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            items: DoctorSpecialty.values.map((s) => DropdownMenuItem(
              value: s,
              child: Text(s.name),
            )).toList(),
            onChanged: (val) => setState(() => _selectedSpecialty = val!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Numéro de licence / RPPS',
              prefixIcon: Icon(Icons.verified_user_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AsyncValue authState) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: authState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator()),
        orElse: () => ElevatedButton(
          onPressed: _selectedRole == null ? null : _nextStep,
          child: Text(_currentStep == 0 
            ? 'Continuer' 
            : (_currentStep == 1 && _selectedRole != UserRole.doctor) || _currentStep == 2 
              ? 'Créer mon compte' 
              : 'Suivant'),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade100,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}
