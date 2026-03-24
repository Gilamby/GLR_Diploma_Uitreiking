import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/design_tokens.dart';
import '../../auth/data/auth_repository.dart';
import '../data/photo_repository.dart';
import '../../../shared/widgets/main_shell_scaffold.dart';

class PhotoGalleryScreen extends ConsumerWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = ref.watch(currentAppUserProvider);
    return userSnapshot.when(
      data: (user) {
        final examClass = user?.examClass ?? '';
        final photosStream = ref.watch(
          StreamProvider<List<PhotoItem>>(
            (providerRef) =>
                providerRef.watch(photoRepositoryProvider).photosForClass(examClass),
          ),
        );
        return MainShellScaffold(
          title: 'Foto\'s',
          child: photosStream.when(
            data: (photos) {
              if (photos.isEmpty) return const Text('Nog geen foto\'s beschikbaar.');
              return GridView.builder(
                shrinkWrap: true,
                itemCount: photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            photo.url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            DateFormat('dd-MM-yyyy HH:mm').format(photo.createdAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: DesignTokens.neon,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            error: (_, __) => const Text('Foto\'s konden niet worden geladen.'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
      error: (_, __) => const Scaffold(body: Center(child: Text('Fout bij laden'))),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
