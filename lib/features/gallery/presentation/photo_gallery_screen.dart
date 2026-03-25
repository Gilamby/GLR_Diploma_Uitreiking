import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/mobile_bottom_nav.dart';
import '../../../shared/widgets/mobile_design_frame.dart';
import '../../../shared/widgets/mobile_top_logo.dart';
import '../../../shared/widgets/hover_press.dart';

class PhotoGalleryScreen extends StatelessWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local placeholder photos (no database yet).
    final now = DateTime.now();
    final items = List.generate(
      12,
      (i) => _LocalPhoto(
        id: 'P${(i + 1).toString().padLeft(3, '0')}',
        createdAt: now.subtract(Duration(hours: i * 6)),
        label: 'Foto ${i + 1}',
        by: i.isEven ? 'GLR' : 'Leerling',
      ),
    );

    // Recreate `assets/design/Mobile - Foto's Overzicht.svg` (key blocks).
    // Image frame:    x=105, y=299, w=1124, h=820, stroke #8FE508 width 6
    // Grid panel:     x=108, y=1193, w=1118, h=787, r=16, fill #8FE508@0.4, stroke black 5
    // Top bar:        x=127, y=985, w=1083, h=108, r=16, fill black@0.4
    const imageFrame = Rect.fromLTWH(105, 299, 1124, 820);
    const gridPanel = Rect.fromLTWH(108, 1193, 1118, 787);
    const topBar = Rect.fromLTWH(127, 985, 1083, 108);

    return MobileDesignFrame(
      children: [
        (m) {
          final s = m.scale;
          final frame = m.map(imageFrame);
          final panel = m.map(gridPanel);
          final bar = m.map(topBar);

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
                rect: bar,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16 * s),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: bar,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16 * s),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: 0.35,
                        child: Image.network(
                          'https://picsum.photos/seed/photos-header/1200/300',
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => const SizedBox.shrink(),
                        ),
                      ),
                      Center(
                        child: Text(
                          "FOTO'S",
                          style: TextStyle(
                            color: const Color(0xFF8FE508),
                            fontSize: 54 * s,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: panel,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8FE508).withValues(alpha: 0.40),
                    borderRadius: BorderRadius.circular(16 * s),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(18 * s),
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 10 * s,
                      radius: Radius.circular(999 * s),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14 * s,
                          mainAxisSpacing: 14 * s,
                        ),
                        itemBuilder: (context, index) {
                          final photo = items[index];
                          return HoverPress(
                            onTap: () => context.go('/photos/details/${photo.id}'),
                            borderRadius: 12 * s,
                            hoverFillAlpha: 0.10,
                            hoverBorderAlpha: 0.80,
                            hoverGlowAlpha: 0.22,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12 * s),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10 * s),
                                          ),
                                          child: Image.network(
                                            'https://picsum.photos/seed/${photo.id}/800/800',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, _, __) => Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 58 * s,
                                                color: const Color(0xFF8FE508)
                                                    .withValues(alpha: 0.55),
                                              ),
                                            ),
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Center(
                                                child: SizedBox(
                                                  width: 30 * s,
                                                  height: 30 * s,
                                                  child: const CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10 * s),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            photo.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.92),
                                              fontSize: 24 * s,
                                              fontWeight: FontWeight.w900,
                                              height: 1.05,
                                            ),
                                          ),
                                          SizedBox(height: 4 * s),
                                          Text(
                                            DateFormat('dd-MM-yyyy HH:mm')
                                                .format(photo.createdAt),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.78),
                                              fontSize: 20 * s,
                                              fontWeight: FontWeight.w800,
                                              height: 1.05,
                                            ),
                                          ),
                                          SizedBox(height: 2 * s),
                                          Text(
                                            'Door: ${photo.by}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.72),
                                              fontSize: 18 * s,
                                              fontWeight: FontWeight.w800,
                                              height: 1.05,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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

class _LocalPhoto {
  const _LocalPhoto({
    required this.id,
    required this.createdAt,
    required this.label,
    required this.by,
  });
  final String id;
  final DateTime createdAt;
  final String label;
  final String by;
}
