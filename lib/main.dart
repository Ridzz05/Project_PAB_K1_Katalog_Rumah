import 'package:flutter/material.dart';
import 'auth/auth.dart';
import 'screens/app_shell.dart';
import 'screens/landing_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = AuthController();
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _authController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeControllerScope(
      controller: _themeController,
      child: AuthScope(
        controller: _authController,
        child: AnimatedBuilder(
          animation: _themeController,
          builder: (context, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'UniFinder',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: _themeController.mode,
              home: const AuthGate(),
            );
          },
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<void> _openLogin(BuildContext context, AuthController auth) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnimatedBuilder(
          animation: auth,
          builder: (context, _) {
            final navigator = Navigator.of(context);
            if (auth.isAuthenticated && navigator.canPop()) {
              Future.microtask(() => navigator.maybePop());
            }
            return SignInScreen(
              key: const ValueKey('sign-in'),
              onSubmit: auth.login,
              isLoading: auth.isLoading,
              onRegister: auth.register,
              errorMessage: auth.errorMessage,
            );
          },
        ),
      ),
    );
  }

  Future<void> _openRegister(BuildContext context, AuthController auth) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RegisterScreen(onRegister: auth.register),
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun berhasil dibuat. Kamu sudah masuk.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: auth.isAuthenticated
          ? AppShell(key: const ValueKey('app-shell'), onLogout: auth.logout)
          : LandingScreen(
              key: const ValueKey('landing'),
              onStart: () => _openRegister(context, auth),
              onLogin: () => _openLogin(context, auth),
              onSignUp: () => _openRegister(context, auth),
            ),
    );
  }
}
