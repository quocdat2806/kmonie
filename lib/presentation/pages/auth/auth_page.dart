import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/enum/exports.dart';
import '../../../../core/text_style/exports.dart';
import '../../../presentation/exports.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.mode});

  final AuthMode mode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;

  bool get isSignIn => widget.mode == AuthMode.signIn;

  @override
  void dispose() {
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: ColorConstants.white, body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 28),
              _buildInputInformation(),
              const SizedBox(height: 8),
              _buildActionsAuth(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(TextConstants.userName, style: AppTextStyle.blackS12Black),
        const SizedBox(height: 8),
        AppTextField(controller: _userName, hintText: 'Username'),
        const SizedBox(height: 16),
        // Text(TextConstants.password, style: AppTextStyle.blackS12Black),
        const SizedBox(height: 8),
        AppTextField(
          controller: _password,
          hintText: 'Password',
          obscureText: _obscure,
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ],
    );
  }

  void _handleSwitchModeAuth() {
    if (isSignIn) {
      context.go('/auth/signup');
      return;
    }
    context.go('/auth/signin');
  }

  Widget _buildActionsAuth() {
    final String submitLabel = isSignIn ? 'Sign In' : 'Sign Up';
    final String switchPrompt = isSignIn ? 'No have account?' : 'Have account?';
    final String switchAction = isSignIn ? 'Sign Up' : 'Sign In';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (isSignIn)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forget Password'),
            ),
          ),
        if (isSignIn) const SizedBox(height: 4),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.black,
              foregroundColor: ColorConstants.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: _handleSubmit,
            child: Text(submitLabel, style: AppTextStyle.blackS16Medium),
          ),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(switchPrompt),
            TextButton(
              onPressed: _handleSwitchModeAuth,
              child: Text(switchAction),
            ),
          ],
        ),
      ],
    );
  }

  void _handleSubmit() {}
}
