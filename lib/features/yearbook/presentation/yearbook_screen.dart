import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/mobile_bottom_nav.dart';
import '../../../shared/widgets/mobile_design_frame.dart';
import '../../../shared/widgets/mobile_top_logo.dart';
import '../../../shared/widgets/hover_press.dart';

class YearbookScreen extends StatefulWidget {
  const YearbookScreen({super.key});

  @override
  State<YearbookScreen> createState() => _YearbookScreenState();
}

class _YearbookScreenState extends State<YearbookScreen> {
  final _controller = TextEditingController();

  final List<_Student> _students = const [
    _Student(
      id: 'S001',
      name: 'Amina El Farah',
      examClass: '6A',
      photoUrl: 'https://picsum.photos/seed/S001/800/800',
    ),
    _Student(
      id: 'S002',
      name: 'Bram de Vries',
      examClass: '6A',
      photoUrl: 'https://picsum.photos/seed/S002/800/800',
    ),
    _Student(
      id: 'S003',
      name: 'Chloë Janssen',
      examClass: '6B',
      photoUrl: 'https://picsum.photos/seed/S003/800/800',
    ),
    _Student(
      id: 'S004',
      name: 'Daan Verbeek',
      examClass: '6B',
      photoUrl: 'https://picsum.photos/seed/S004/800/800',
    ),
    _Student(
      id: 'S005',
      name: 'Eva van Dijk',
      examClass: '6C',
      photoUrl: 'https://picsum.photos/seed/S005/800/800',
    ),
    _Student(
      id: 'S006',
      name: 'Finn Smit',
      examClass: '6C',
      photoUrl: 'https://picsum.photos/seed/S006/800/800',
    ),
    _Student(
      id: 'S007',
      name: 'Hajar Benali',
      examClass: '6D',
      photoUrl: 'https://picsum.photos/seed/S007/800/800',
    ),
    _Student(
      id: 'S008',
      name: 'Ibrahim Hassan',
      examClass: '6D',
      photoUrl: 'https://picsum.photos/seed/S008/800/800',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `assets/design/Mobile - Jaarboek.svg` key blocks.
    // Top search:    matrix rect at y≈405 (design-space), we use a simple bar rect.
    // Card 1:        x=101, y=473,  w=1124, h=820, r=19, stroke #8FE508 w6
    // Divider bar 1: x=123, y=1159, w=1083, h=108, r=16, fill black@0.4
    // Card 2:        x=109, y=1371, w=1124, h=820, r=19, stroke #8FE508 w6
    // Divider bar 2: x=131, y=2057, w=1083, h=108, r=16, fill black@0.4
    const topBar = Rect.fromLTWH(100, 311, 1114, 87);
    // One big list panel replacing both cards + headers.
    // (473..2191) => height 1718
    const listCard = Rect.fromLTWH(101, 473, 1124, 1718);

    return MobileDesignFrame(
      children: [
        (m) {
          final s = m.scale;
          final t = m.map(topBar);
          final list = m.map(listCard);

          final query = _controller.text.trim().toLowerCase();
          final filtered = _students.where((st) {
            if (query.isEmpty) return true;
            return st.name.toLowerCase().contains(query) ||
                st.examClass.toLowerCase().contains(query) ||
                st.id.toLowerCase().contains(query);
          }).toList();

          Widget strokeFrame(Rect r, {VoidCallback? onTap}) {
            return Positioned.fromRect(
              rect: r,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19 * s),
                    border: Border.all(color: const Color(0xFF8FE508), width: 6 * s),
                    color: Colors.black.withValues(alpha: 0.05),
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
          // Search bar (real input) - transparent, like login
              Positioned.fromRect(
                rect: t,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16 * s),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                  color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16 * s),
                      border: Border.all(color: const Color(0xFF8FE508), width: 7 * s),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22 * s),
                        child: TextField(
                          controller: _controller,
                          onChanged: (_) => setState(() {}),
                          style: TextStyle(
                            color: const Color(0xFF8FE508),
                            fontSize: 40 * s,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                          cursorColor: const Color(0xFF8FE508),
                          decoration: InputDecoration(
                            hintText: 'Zoeken',
                            hintStyle: TextStyle(
                              color: const Color(0xFF8FE508).withValues(alpha: 0.55),
                              fontSize: 40 * s,
                              fontWeight: FontWeight.w900,
                            ),
                        suffixIcon: Icon(
                          Icons.search_rounded,
                          color: const Color(0xFF8FE508).withValues(alpha: 0.85),
                        ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 18 * s),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // One big list card (no JAARBOEK header, no second panel)
              strokeFrame(list),

              // Student list inside the big card
              Positioned.fromRect(
                rect: list.deflate(24 * s),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16 * s),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.10),
                      border: Border.all(color: Colors.black, width: 3 * s),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 10 * s,
                      radius: Radius.circular(999 * s),
                      child: ListView.separated(
                        padding: EdgeInsets.all(14 * s),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => SizedBox(height: 18 * s),
                        itemBuilder: (context, index) {
                          final st = filtered[index];
                          return HoverPress(
                            onTap: () => context.go('/jaarboek/details/${st.id}'),
                            borderRadius: 16 * s,
                            hoverFillAlpha: 0.10,
                            hoverBorderAlpha: 0.75,
                            hoverGlowAlpha: 0.22,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16 * s),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16 * s),
                                  border: Border.all(color: Colors.black, width: 3 * s),
                                  color: Colors.black.withValues(alpha: 0.18),
                                ),
                                child: SizedBox(
                                  height: 330 * s,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.network(
                                          st.photoUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, _, __) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.black.withValues(alpha: 0.10),
                                                    Colors.black.withValues(alpha: 0.32),
                                                  ],
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  size: 140 * s,
                                                  color: Colors.black.withValues(alpha: 0.28),
                                                ),
                                              ),
                                            );
                                          },
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) return child;
                                            return Center(
                                              child: SizedBox(
                                                width: 34 * s,
                                                height: 34 * s,
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
                                        height: 78 * s,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.22),
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.black.withValues(alpha: 0.55),
                                                width: 2 * s,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              st.name,
                                              style: TextStyle(
                                                color: const Color(0xFF8FE508),
                                                fontSize: 44 * s,
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
                          );
                        },
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

class _Student {
  const _Student({
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

