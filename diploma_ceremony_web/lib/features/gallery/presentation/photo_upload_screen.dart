import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../../auth/data/auth_repository.dart';
import '../data/photo_repository.dart';
import '../../../shared/widgets/main_shell_scaffold.dart';

class PhotoUploadScreen extends ConsumerStatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  ConsumerState<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<PhotoUploadScreen> {
  String? _status;
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    final user = ref.read(currentAppUserProvider).asData?.value;
    if (user == null) return;
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final files = picked?.files;
    if (files == null || files.isEmpty) return;
    final file = files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    setState(() {
      _uploading = true;
      _status = null;
    });

    try {
      await ref.read(photoRepositoryProvider).uploadPhoto(
            uid: user.uid,
            examClass: user.examClass,
            fileBytes: Uint8List.fromList(bytes),
            fileName: file.name,
          );
      setState(() {
        _status = 'Upload voltooid';
      });
    } catch (_) {
      setState(() {
        _status = 'Upload mislukt';
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainShellScaffold(
      title: 'Foto upload',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload foto\'s voor jouw examenklas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: DesignTokens.neon,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: DesignTokens.neon,
              foregroundColor: DesignTokens.black,
            ),
            onPressed: _uploading ? null : _pickAndUpload,
            icon: const Icon(Icons.upload_file),
            label: Text(_uploading ? 'Uploaden...' : 'Kies foto'),
          ),
          if (_status != null) ...[
            const SizedBox(height: 12),
            Text(
              _status!,
              style: const TextStyle(color: DesignTokens.neon),
            ),
          ],
        ],
      ),
    );
  }
}
