import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../shared/widgets/design_background.dart';
import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _controller = TextEditingController();
  String? _errorText;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithAccessCode(_controller.text.trim());
      if (mounted) context.go('/home');
    } catch (_) {
      setState(() {
        _errorText = 'Login failed. Check your personal code.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 88,
                        child: SvgPicture.asset('assets/design/logo.svg'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Diploma Uitreiking',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: DesignTokens.neon,
                              fontWeight: FontWeight.w800,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controller,
                        style: const TextStyle(color: DesignTokens.neon),
                        decoration: InputDecoration(
                          labelText: 'Persoonlijke code',
                          errorText: _errorText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        onPressed: _loading ? null : _submit,
                        child: Text(_loading ? 'Inloggen...' : 'Inloggen'),
                      ),
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
}
