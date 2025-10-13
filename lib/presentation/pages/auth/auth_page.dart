import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/lib.dart';
import 'package:kmonie/core/navigation/router_path.dart';
import 'package:kmonie/core/di/di.dart' as di;
import 'package:kmonie/repository/auth_repository.dart';

class AuthPage extends StatelessWidget {
  final AuthMode mode;
  const AuthPage({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(di.sl<AuthRepository>()),
      child: AuthPageChild(mode: mode),
    );
  }
}

class AuthPageChild extends StatefulWidget {
  const AuthPageChild({super.key, required this.mode});

  final AuthMode mode;

  @override
  State<AuthPageChild> createState() => _AuthPageChildState();
}

class _AuthPageChildState extends State<AuthPageChild> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool get isSignIn => widget.mode == AuthMode.signIn;

  @override
  void dispose() {
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ColoredBox(
      color: AppColorConstants.primary,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppUIConstants.defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.defaultSpacing,
              children: <Widget>[_buildInputInformation(), _buildActionsAuth()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputInformation() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppUIConstants.defaultSpacing,
          children: <Widget>[
            AppTextField(
              controller: _userName,
              filledColor: AppColorConstants.white,
              hintText: 'Tên đăng nhập',
              onChanged: (value) {},
            ),
            AppTextField(
              controller: _password,
              hintText: 'Mật khẩu',
              filledColor: AppColorConstants.white,
              obscureText: state.isPasswordObscured,
              onChanged: (value) {
                context.read<AuthBloc>().add(AuthEvent.passwordChanged(value));
              },
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEvent.togglePasswordVisibility(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSwitchModeAuth() {
    if (isSignIn) {
      context.go(RouterPath.signUp);
      return;
    }
    context.go(RouterPath.signIn);
  }

  Widget _buildActionsAuth() {
    final String submitLabel = isSignIn ? 'Đăng nhập' : 'Đăng ký';
    final String switchPrompt = isSignIn
        ? 'Chưa có tài khoản?'
        : 'Đã có tài khoản?';
    final String switchAction = isSignIn ? 'Đăng ký' : 'Đăng nhập';

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isLoading = state.loadStatus == LoadStatus.loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isSignIn)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Quên mật khẩu'),
                ),
              ),
            AppButton(
              onPressed: isLoading ? () {} : _handleSubmit,
              text: isLoading ? 'Đang xử lý...' : submitLabel,
              backgroundColor: AppColorConstants.black,
              textColor: AppColorConstants.white,
            ),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(switchPrompt),
                TextButton(
                  onPressed: isLoading ? null : _handleSwitchModeAuth,
                  child: Text(switchAction),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() {
    context.read<AuthBloc>().add(const AuthEvent.handleSubmit());
  }
}
