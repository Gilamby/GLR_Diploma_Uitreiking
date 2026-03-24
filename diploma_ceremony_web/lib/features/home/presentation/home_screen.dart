import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/design_tokens.dart';
import '../../auth/data/auth_repository.dart';
import '../../../shared/widgets/main_shell_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = ref.watch(currentAppUserProvider);
    return MainShellScaffold(
      title: 'Home',
      child: userSnapshot.when(
        data: (user) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welkom bij de diploma-uitreiking',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: DesignTokens.neon,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Examenklas: ${user?.examClass ?? '-'}',
                style: const TextStyle(color: DesignTokens.white),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () => context.go('/livestream'),
                    child: const Text('Naar livestream'),
                  ),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: DesignTokens.gold,
                      side: const BorderSide(color: DesignTokens.gold),
                    ),
                    onPressed: () => context.go('/photos'),
                    child: const Text('Naar foto\'s'),
                  ),
                  if (user?.canUpload == true)
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: DesignTokens.gold,
                        side: const BorderSide(color: DesignTokens.gold),
                      ),
                      onPressed: () => context.go('/photos/upload'),
                      child: const Text('Foto uploaden'),
                    ),
                ],
              ),
            ],
          );
        },
        error: (_, __) => const Text('Profiel kon niet worden geladen'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
