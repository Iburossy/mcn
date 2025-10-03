import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _emailController = TextEditingController();

  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      Helpers.showError(context, 'Veuillez accepter les conditions d\'utilisation');
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.register(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      pin: _pinController.text,
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Helpers.showError(context, authProvider.error ?? 'Erreur d\'inscription');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Inscription'),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                // Titre
                const Text(
                  'Créer un compte',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Rejoignez-nous pour une expérience complète',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Nom complet
                CustomTextField(
                  controller: _nameController,
                  label: 'Nom complet',
                  hint: 'Jean Dupont',
                  prefixIcon: Icons.person_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    if (value.length < 3) {
                      return 'Le nom doit contenir au moins 3 caractères';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Téléphone
                CustomTextField(
                  controller: _phoneController,
                  label: 'Numéro de téléphone',
                  hint: '77 123 45 67',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) => Validators.phone(value),
                ),

                const SizedBox(height: 16),

                // Email (optionnel)
                CustomTextField(
                  controller: _emailController,
                  label: 'Email (optionnel)',
                  hint: 'votre@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Code PIN
                CustomTextField(
                  controller: _pinController,
                  label: 'Code PIN',
                  hint: '••••',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.pin(value),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePin = !_obscurePin);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Confirmer code PIN
                CustomTextField(
                  controller: _confirmPinController,
                  label: 'Confirmer le code PIN',
                  hint: '••••',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscureConfirmPin,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.confirmPin(value, _pinController.text),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPin = !_obscureConfirmPin);
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Conditions d'utilisation
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() => _acceptTerms = value ?? false);
                      },
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _acceptTerms = !_acceptTerms);
                        },
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.body2,
                            children: [
                              const TextSpan(text: 'J\'accepte les '),
                              TextSpan(
                                text: 'conditions d\'utilisation',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: ' et la '),
                              TextSpan(
                                text: 'politique de confidentialité',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Bouton inscription
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: CustomButton(
                    text: 'S\'inscrire',
                    onPressed: _register,
                    isLoading: authProvider.isLoading,
                    icon: Icons.person_add,
                  ),
                ),

                const SizedBox(height: 24),

                // Déjà un compte
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous avez déjà un compte ? ',
                      style: AppTextStyles.body2,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
