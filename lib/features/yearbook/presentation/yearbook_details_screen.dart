import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/mobile_bottom_nav.dart';
import '../../../shared/widgets/mobile_design_frame.dart';
import '../../../shared/widgets/mobile_top_logo.dart';
import '../../../shared/widgets/hover_press.dart';

class YearbookDetailsScreen extends StatelessWidget {
  const YearbookDetailsScreen({required this.studentId, super.key});

  final String studentId;

  @override
  Widget build(BuildContext context) {
    // `assets/design/Mobile - JaarboekDetails.svg` key blocks.
    // Main content: x=105, y=299, w=1124, h=1735, r=19, stroke #8FE508 w6
    // Back button:  x=108, y=77,  w=167,  h=132, r=36, fill #8FE508@0.13
    const content = Rect.fromLTWH(105, 299, 1124, 1735);
    const backButton = Rect.fromLTWH(108, 77, 167, 132);

    final profile = _profileById(studentId);

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
                            'LEERLING',
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
                                height: 720 * s,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        profile.photoUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, _, __) {
                                          return DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.black.withValues(alpha: 0.08),
                                                  Colors.black.withValues(alpha: 0.35),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.person_rounded,
                                                size: 220 * s,
                                                color: Colors.black.withValues(alpha: 0.26),
                                              ),
                                            ),
                                          );
                                        },
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
                                      height: 98 * s,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.45),
                                        ),
                                        child: Center(
                                          child: Text(
                                            profile.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 54 * s,
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
                          _detailRow(s, 'ID', studentId),
                          SizedBox(height: 12 * s),
                          _detailRow(s, 'KLAS', profile.examClass),
                          SizedBox(height: 12 * s),
                          _detailRow(s, 'QUOTE', '“Een mooie afsluiting van een mooie tijd.”'),
                          SizedBox(height: 22 * s),
                          Text(
                            'TEKST',
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
                                  'Placeholder tekst voor het jaarboek. Dit kan later uit een database komen, maar blijft nu lokaal zodat de UI precies klopt.',
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
                      context.go('/jaarboek');
                    }
                  },
                  borderRadius: 36 * s,
                  hoverFillAlpha: 0.15,
                  hoverBorderAlpha: 0.85,
                  hoverGlowAlpha: 0.22,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8FE508).withValues(alpha: 0.13),
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
              width: 160 * s,
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

_YearbookProfile _profileById(String id) {
  const items = <_YearbookProfile>[
    _YearbookProfile(
      id: 'S001',
      name: 'Amina El Farah',
      examClass: '6A',
      photoUrl: 'https://picsum.photos/seed/S001/900/900',
    ),
    _YearbookProfile(
      id: 'S002',
      name: 'Bram de Vries',
      examClass: '6A',
      photoUrl: 'https://picsum.photos/seed/S002/900/900',
    ),
    _YearbookProfile(
      id: 'S003',
      name: 'Chloë Janssen',
      examClass: '6B',
      photoUrl: 'https://picsum.photos/seed/S003/900/900',
    ),
    _YearbookProfile(
      id: 'S004',
      name: 'Daan Verbeek',
      examClass: '6B',
      photoUrl: 'https://picsum.photos/seed/S004/900/900',
    ),
    _YearbookProfile(
      id: 'S005',
      name: 'Eva van Dijk',
      examClass: '6C',
      photoUrl: 'https://picsum.photos/seed/S005/900/900',
    ),
    _YearbookProfile(
      id: 'S006',
      name: 'Finn Smit',
      examClass: '6C',
      photoUrl: 'https://picsum.photos/seed/S006/900/900',
    ),
    _YearbookProfile(
      id: 'S007',
      name: 'Hajar Benali',
      examClass: '6D',
      photoUrl: 'https://picsum.photos/seed/S007/900/900',
    ),
    _YearbookProfile(
      id: 'S008',
      name: 'Ibrahim Hassan',
      examClass: '6D',
      photoUrl: 'https://picsum.photos/seed/S008/900/900',
    ),
  ];

  return items.firstWhere(
    (e) => e.id == id,
    orElse: () => _YearbookProfile(
      id: id,
      name: 'Leerling',
      examClass: '-',
      photoUrl: 'https://picsum.photos/seed/$id/900/900',
    ),
  );
}

class _YearbookProfile {
  const _YearbookProfile({
    required this.id,
    required this.name,
    required this.examClass,
    required this.photoUrl,
  });

  final String id;
  final String name;
  final String examClass;
  final String photoUrl;
}

