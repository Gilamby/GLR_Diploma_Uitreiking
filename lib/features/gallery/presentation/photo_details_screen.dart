import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/hover_press.dart';
import '../../../shared/widgets/mobile_bottom_nav.dart';
import '../../../shared/widgets/mobile_design_frame.dart';
import '../../../shared/widgets/mobile_top_logo.dart';

class PhotoDetailsScreen extends StatelessWidget {
  const PhotoDetailsScreen({required this.photoId, super.key});

  final String photoId;

  @override
  Widget build(BuildContext context) {
    // Loosely aligned with the other detail layouts.
    const content = Rect.fromLTWH(105, 299, 1124, 1735);
    const backButton = Rect.fromLTWH(108, 77, 167, 132);

    final photo = _photoById(photoId);

    return MobileDesignFrame(
      children: [
        (m) {
          final s = m.scale;
          final c = m.map(content);
          final back = m.map(backButton);

          return Stack(
            children: [
              Positioned.fromRect(
                rect: m.map(mobileTopLogoRect),
                child: MobileTopLogo(scale: s),
              ),
              Positioned.fromRect(
                rect: c,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19 * s),
                    border: Border.all(color: const Color(0xFF8FE508), width: 6 * s),
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(26 * s),
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 10 * s,
                      radius: Radius.circular(999 * s),
                      child: ListView(
                        children: [
                          Text(
                            'FOTO',
                            style: TextStyle(
                              color: const Color(0xFF8FE508),
                              fontSize: 64 * s,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 18 * s),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16 * s),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.30),
                              ),
                              child: SizedBox(
                                height: 760 * s,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        photo.photoUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, _, __) => Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 220 * s,
                                            color: Colors.black.withValues(alpha: 0.26),
                                          ),
                                        ),
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Center(
                                            child: SizedBox(
                                              width: 36 * s,
                                              height: 36 * s,
                                              child: const CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      height: 110 * s,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.45),
                                        ),
                                        child: Center(
                                          child: Text(
                                            photo.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 52 * s,
                                              fontWeight: FontWeight.w900,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 22 * s),
                          _detailRow(s, 'ID', photo.id),
                          SizedBox(height: 12 * s),
                          _detailRow(s, 'DATUM', DateFormat('dd-MM-yyyy HH:mm').format(photo.at)),
                          SizedBox(height: 12 * s),
                          _detailRow(s, 'DOOR', photo.by),
                          SizedBox(height: 22 * s),
                          Text(
                            'OMSCHRIJVING',
                            style: TextStyle(
                              color: const Color(0xFF8FE508),
                              fontSize: 46 * s,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 10 * s),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16 * s),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.30),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(18 * s),
                                child: Text(
                                  'Placeholder beschrijving voor de foto. Later kunnen we hier echte metadata tonen (locatie, tags, etc.).',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontSize: 32 * s,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: back,
                child: HoverPress(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/photos');
                    }
                  },
                  borderRadius: 36 * s,
                  hoverFillAlpha: 0.15,
                  hoverBorderAlpha: 0.85,
                  hoverGlowAlpha: 0.22,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8FE508).withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(36 * s),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF8FE508),
                        size: 72 * s,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned.fill(child: SizedBox.shrink()),
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

Widget _detailRow(double s, String label, String value) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16 * s),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.30),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 14 * s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 190 * s,
              child: Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF8FE508),
                  fontSize: 32 * s,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: 32 * s,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

_PhotoProfile _photoById(String id) {
  final now = DateTime.now();
  return _PhotoProfile(
    id: id,
    title: 'Foto ${id.replaceAll(RegExp(r"[^0-9]"), "")}',
    by: id.hashCode.isEven ? 'GLR' : 'Leerling',
    at: now.subtract(Duration(hours: (id.hashCode.abs() % 72))),
    photoUrl: 'https://picsum.photos/seed/$id/1200/1200',
  );
}

class _PhotoProfile {
  const _PhotoProfile({
    required this.id,
    required this.title,
    required this.by,
    required this.at,
    required this.photoUrl,
  });

  final String id;
  final String title;
  final String by;
  final DateTime at;
  final String photoUrl;
}

