import 'package:flutter/material.dart';

/*
 * MERICSTACK EXECUTION FLOW
 * * UI (LoginScreen)
 * ↓
 * LoginCommand
 * ↓
 * LoginRepository
 * ↓
 * Result<User, AppFailure>
 * ↓
 * UI handles Success / Failure deterministically
 */

// --- 1. PRESENTATION LAYER (UI) ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Dependency Injection will be added later.
  final _command = LoginCommand(MockLoginRepository());
  
  String _status = 'Ready';

  Future<void> _handleLogin() async {
    setState(() => _status = 'Signing in...');

    // Deterministic Execution: No try-catch blocks. UI only cares about the Result.
    final result = await _command.execute('admin@mericstack.com', '123456');

    result.fold(
      onSuccess: (user) => setState(() => _status = 'Welcome, ${user.name}!'),
      onFailure: (failure) => setState(() => _status = 'Error: ${failure.message}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. APPLICATION LAYER (Command) ---
class LoginCommand {
  final LoginRepository _repository;

  LoginCommand(this._repository);

  Future<Result<User, AppFailure>> execute(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return const Result.failure(AuthFailure('Credentials cannot be empty.'));
    }
    return await _repository.authenticate(email, password);
  }
}

// --- 3. DOMAIN & DATA LAYER ---
class User {
  final String id;
  final String name;
  const User({required this.id, required this.name});
}

abstract class LoginRepository {
  Future<Result<User, AppFailure>> authenticate(String email, String password);
}

class MockLoginRepository implements LoginRepository {
  @override
  Future<Result<User, AppFailure>> authenticate(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (email == 'admin@mericstack.com' && password == '123456') {
      return const Result.success(User(id: '1', name: 'Gokalp Ozer'));
    }
    return const Result.failure(AuthFailure('Invalid credentials.'));
  }
}

// --- 4. CORE INFRASTRUCTURE (Enforced Boundaries) ---
// Minimal mocked implementation purely to demonstrate signatures.

abstract class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

class Result<T, E extends AppFailure> {
  final T? _value;
  final E? _error;
  final bool isSuccess;

  const Result.success(this._value) : isSuccess = true, _error = null;
  const Result.failure(this._error) : isSuccess = false, _value = null;

  void fold({
    required void Function(T value) onSuccess,
    required void Function(E failure) onFailure,
  }) {
    if (isSuccess) {
      onSuccess(_value as T);
    } else {
      onFailure(_error as E);
    }
  }
}
