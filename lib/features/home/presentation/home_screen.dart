import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/data/auth_repository.dart';
import '../../../shared/widgets/mobile_bottom_nav.dart';
import '../../../shared/widgets/mobile_design_frame.dart';
import '../../../shared/widgets/mobile_top_logo.dart';
import '../../../shared/widgets/hover_press.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MobileDesignFrame(
      children: [
        (m) {
          final s = m.scale;
          // Simple home layout in design-space, consistent with the other screens.
          const tile1 = Rect.fromLTWH(105, 299, 1124, 540);
          const tile2 = Rect.fromLTWH(105, 885, 1124, 540);
          const tile3 = Rect.fromLTWH(105, 1471, 1124, 540);

          final t1 = m.map(tile1);
          final t2 = m.map(tile2);
          final t3 = m.map(tile3);

          Widget tile(
            Rect r, {
            required String label,
            required String subtitle,
            required IconData icon,
            required String imageSeed,
            required VoidCallback onTap,
          }) {
            return Positioned.fromRect(
              rect: r,
              child: HoverPress(
                onTap: onTap,
                borderRadius: 19 * s,
                padding: EdgeInsets.zero,
                hoverFillAlpha: 0.08,
                hoverBorderAlpha: 0.85,
                hoverGlowAlpha: 0.22,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19 * s),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: 0.18,
                        child: Image.network(
                          'https://picsum.photos/seed/$imageSeed/1400/800',
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => const SizedBox.shrink(),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19 * s),
                          border: Border.all(
                            color: const Color(0xFF8FE508),
                            width: 6 * s,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.14),
                              Colors.black.withValues(alpha: 0.06),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40 * s, vertical: 34 * s),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 92 * s,
                                  height: 92 * s,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8FE508).withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(22 * s),
                                    border: Border.all(
                                      color: Colors.black.withValues(alpha: 0.35),
                                      width: 2 * s,
                                    ),
                                  ),
                                  child: Icon(
                                    icon,
                                    color: const Color(0xFF8FE508).withValues(alpha: 0.95),
                                    size: 56 * s,
                                  ),
                                ),
                                SizedBox(width: 20 * s),
                                Expanded(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: const Color(0xFF8FE508),
                                      fontSize: 66 * s,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: const Color(0xFF8FE508).withValues(alpha: 0.75),
                                  size: 58 * s,
                                ),
                              ],
                            ),
                            const Spacer(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16 * s),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.20),
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    width: 2 * s,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22 * s,
                                    vertical: 16 * s,
                                  ),
                                  child: Text(
                                    subtitle,
                                    style: TextStyle(
                                      color: const Color(0xFF8FE508)
                                          .withValues(alpha: 0.85),
                                      fontSize: 32 * s,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
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
          }

          return Stack(
            children: [
              Positioned.fromRect(
                rect: m.map(mobileTopLogoRect),
                child: MobileTopLogo(scale: s),
              ),

              tile(
                t1,
                label: 'LIVESTREAM',
                subtitle: 'Bekijk de ceremonie live + chat mee.',
                icon: Icons.play_arrow_rounded,
                imageSeed: 'home-livestream',
                onTap: () => context.go('/livestream'),
              ),
              tile(
                t2,
                label: "FOTO'S",
                subtitle: 'Blader door foto’s en open details.',
                icon: Icons.photo_library_rounded,
                imageSeed: 'home-photos',
                onTap: () => context.go('/photos'),
              ),
              tile(
                t3,
                label: 'JAARBOEK',
                subtitle: 'Zoek leerlingen en bekijk profielen.',
                icon: Icons.menu_book_rounded,
                imageSeed: 'home-yearbook',
                onTap: () => context.go('/jaarboek'),
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
