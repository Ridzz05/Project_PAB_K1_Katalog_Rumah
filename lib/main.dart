import 'package:flutter/material.dart';

import 'auth/auth.dart';
import 'screens/app_shell.dart';
import 'screens/landing_screen.dart';

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

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _authController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UniFinder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF7643),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1F1F1F),
            centerTitle: false,
            titleSpacing: 20,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<void> _openLogin(
    BuildContext context,
    AuthController auth,
  ) async {
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

  Future<void> _openRegister(
    BuildContext context,
    AuthController auth,
  ) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RegisterScreen(
          onRegister: auth.register,
        ),
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
