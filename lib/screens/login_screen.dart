import 'package:flutter/material.dart';
import '../widgets/buttons/app_button.dart';
import '../widgets/inputs/app_text_field.dart';
import '../widgets/inputs/app_password_field.dart';
import '../core/responsive.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simulate login process
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to main navigation screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: Responsive.getResponsivePadding(
              context,
              mobile: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              tablet: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              desktop: const EdgeInsets.symmetric(horizontal: 64, vertical: 64),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      _buildLogo(),
                      const SizedBox(height: 48),
                      _buildUsernameField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 8),
                      _buildForgotPasswordLink(),
                      const SizedBox(height: 32),
                      _buildLoginButton(),
                      const SizedBox(height: 24),
                      _buildRegistrationLink(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'lib/assets/image.png',
        height: 150,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported,
            size: 100,
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget _buildUsernameField() {
    return AppTextField(
      controller: _usernameController,
      labelText: 'اسم المستخدم',
      hintText: 'اسم المستخدم',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      fillColor: Theme.of(context).colorScheme.surface,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال اسم المستخدم';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return AppPasswordField(
      controller: _passwordController,
      labelText: 'كلمة المرور',
      hintText: 'كلمة المرور',
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _handleLogin(),
      fillColor: Theme.of(context).colorScheme.surface,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Navigate to forgot password screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('صفحة استعادة كلمة المرور'),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF00A86B), // Greenish-blue
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AppButton(
      text: 'تسجيل الدخول',
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
      isLoading: _isLoading,
      backgroundColor: const Color(0xFF00A86B), // Green
      textColor: Theme.of(context).colorScheme.surface,
      onPressed: _isLoading ? null : _handleLogin,
    );
  }

  Widget _buildRegistrationLink() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          children: [
            const TextSpan(text: 'ليس لديك حساب مسجل ؟ '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  // Navigate to registration screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('صفحة إنشاء حساب جديد'),
                    ),
                  );
                },
                child: const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF00A86B), // Greenish-blue
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

