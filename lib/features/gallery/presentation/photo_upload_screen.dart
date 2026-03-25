import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../data/photo_repository.dart';
import '../../../shared/widgets/mobile_bottom_nav.dart';
import '../../../shared/widgets/mobile_design_frame.dart';
import '../../../shared/widgets/mobile_top_logo.dart';

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
    // Recreate `assets/design/Mobile - Foto Uploading.svg` (UI only; uploads disabled in backend).
    // Image frame:  x=85, y=363, w=1186, h=865, stroke #8FE508 width 6
    // Green card:   x=158, y=413, w=1094, h=693, r=68, fill #96EF09, stroke black 9
    // Bar 1:        x=78, y=1251, w=1177, h=124, r=16, fill black@0.4
    // Bar 2:        x=73, y=1394, w=1179, h=108, r=16, fill black@0.4
    // Back button:  x=74, y=63, w=167, h=132, r=36, fill #8FE508@0.13
    const imageFrame = Rect.fromLTWH(85, 363, 1186, 865);
    const greenCard = Rect.fromLTWH(158, 413, 1094, 693);
    const bar1 = Rect.fromLTWH(78, 1251, 1177, 124);
    const bar2 = Rect.fromLTWH(73, 1394, 1179, 108);
    const backButton = Rect.fromLTWH(74, 63, 167, 132);

    return MobileDesignFrame(
      children: [
        (m) {
          final s = m.scale;
          final frame = m.map(imageFrame);
          final card = m.map(greenCard);
          final b1 = m.map(bar1);
          final b2 = m.map(bar2);
          final back = m.map(backButton);

          return Stack(
            children: [
              Positioned.fromRect(
                rect: m.map(mobileTopLogoRect),
                child: MobileTopLogo(scale: s),
              ),
              Positioned.fromRect(
                rect: frame,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19 * s),
                      border: Border.all(color: const Color(0xFF8FE508), width: 6 * s),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: card,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF96EF09),
                      borderRadius: BorderRadius.circular(68 * s),
                      border: Border.all(color: Colors.black, width: 9 * s),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: back,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).maybePop(),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8FE508).withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(36 * s),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF8FE508),
                        size: 64 * s,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: b1,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16 * s),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: b1,
                child: Center(
                  child: Text(
                      'FOTO UPLOAD',
                    style: TextStyle(
                      color: const Color(0xFF8FE508),
                      fontSize: 52 * s,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: b2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16 * s),
                  ),
                  child: Center(
                    child: Text(
                      'Uploads zijn uitgeschakeld (geen Firebase Storage).',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF8FE508),
                        fontSize: 30 * s,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: b2.left,
                right: b2.right,
                top: b2.bottom + (18 * s),
                child: Center(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: const Color(0xFF8FE508),
                      side: BorderSide(color: Colors.black, width: 5 * s),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16 * s),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 34 * s, vertical: 18 * s),
                    ),
                    onPressed: _uploading ? null : _pickAndUpload,
                    child: Text(_uploading ? 'Uploaden...' : 'Kies foto'),
                  ),
                ),
              ),
              if (_status != null && _status!.trim().isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 18,
                  child: Center(
                    child: Text(
                      _status!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF8FE508),
                        fontSize: 28 * s,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              Positioned.fromRect(
                rect: m.map(mobileBottomNavRect),
                child: MobileBottomNavBar(scale: s),
              ),
            ],
          );
        },
      ],
    );
  }
}
