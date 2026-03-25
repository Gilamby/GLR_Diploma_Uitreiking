import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../data/vimeo_repository.dart';
import '../../../shared/widgets/main_shell_scaffold.dart';

final latestVimeoVideoProvider = FutureProvider<VimeoVideo?>((ref) {
  return ref.watch(vimeoRepositoryProvider).fetchLatestShowcaseVideo();
});

class LivestreamScreen extends ConsumerWidget {
  const LivestreamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoSnapshot = ref.watch(latestVimeoVideoProvider);
    return MainShellScaffold(
      title: 'Livestream',
      child: videoSnapshot.when(
        data: (video) {
          if (video == null) {
            return const Text('Nog geen livestream of replay beschikbaar.');
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: DesignTokens.neon,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(
                  child: Center(
                    child: SelectableText(
                      video.playerEmbedUrl,
                      style: const TextStyle(color: DesignTokens.neon),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        error: (_, __) => const Text('Kon Vimeo video niet laden.'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
