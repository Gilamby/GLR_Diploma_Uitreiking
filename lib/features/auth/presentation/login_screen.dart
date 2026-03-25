import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _controller = TextEditingController();
  String? _errorText;
  bool _loading = false;
  bool _buttonPressed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _loginErrorMessage(Object e) {
    if (e is StateError) {
      final m = e.message;
      if (m.contains('Invalid access code')) {
        return 'Onjuiste streamcode.';
      }
      if (m.contains('STREAM_ACCESS_CODE is not set')) {
        return 'STREAM_ACCESS_CODE ontbreekt in .env.';
      }
      if (m.contains('EVENT_VIEWER')) {
        return 'Vul EVENT_VIEWER_EMAIL en EVENT_VIEWER_PASSWORD in .env.';
      }
      return m;
    }
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Firebase weigert inloggen: gebruiker of wachtwoord klopt niet, '
              'of bestaat niet in dit project (Authentication).';
        case 'invalid-email':
          return 'EVENT_VIEWER_EMAIL in .env is ongeldig.';
        case 'user-disabled':
          return 'Dit Firebase-account is uitgeschakeld.';
        default:
          return 'Firebase-fout (${e.code}). Controleer Authentication en .env.';
      }
    }
    return 'Toegang mislukt: $e';
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithAccessCode(_controller.text.trim());
      if (mounted) context.go('/home');
    } catch (e) {
      if (!mounted) return;
      final message = _loginErrorMessage(e);
      setState(() {
        _errorText = message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recreated UI (no SVG background): `Mobile - Main.svg` replicated with Flutter widgets.
    //
    // Design artboard: 1333 x 2457
    // Card rect:       x=123, y=1126, w=1094, h=650, r=68, fill #96EF09, stroke black 9
    // Input rect:      x=174, y=1310, w=992, h=216, r=16, fill black @ 0.2, stroke black 5
    // Button rect:     x=174, y=1568, w=992, h=150, r=16, fill black, stroke black 5
    // Dots:            x≈642/664/685, y≈1440..1452 (centered `...`)
    const designW = 1333.0;
    const designH = 2457.0;
    const cardRect = Rect.fromLTWH(123, 1126, 1094, 650);
    // Slightly taller than the design per request.
    const inputRect = Rect.fromLTWH(174, 1300, 992, 240);
    const buttonRect = Rect.fromLTWH(174, 1568, 992, 150);
    // Error text should appear inside the card, between input and button.
    const errorRect = Rect.fromLTWH(174, 1548, 992, 42);
    // Move title higher so it never overlaps the input (fixes screenshot issue).
    const titleRect = Rect.fromLTWH(174, 1140, 992, 86);
    // Place the real logo above the input (UI recreation, not SVG pattern).
    const logoRect = Rect.fromLTWH(244, 1178, 846, 250);

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          final scale = (w / designW < h / designH) ? (w / designW) : (h / designH);
          final renderW = designW * scale;
          final renderH = designH * scale;
          final dx = (w - renderW) / 2;
          final dy = (h - renderH) / 2;

          Rect map(Rect r) => Rect.fromLTWH(
                dx + r.left * scale,
                dy + r.top * scale,
                r.width * scale,
                r.height * scale,
              );

          final input = map(inputRect);
          final button = map(buttonRect);
          final error = map(errorRect);
          final card = map(cardRect);
          final title = map(titleRect);
          final logo = map(logoRect);

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MobileMainBackgroundPainter(
                    scale: scale,
                    dx: dx,
                    dy: dy,
                    designW: designW,
                    designH: designH,
                  ),
                ),
              ),

              // Card (green panel with black stroke).
              Positioned.fromRect(
                rect: card,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF96EF09),
                    borderRadius: BorderRadius.circular(68 * scale),
                    border: Border.all(
                      color: Colors.black,
                      width: 9 * scale,
                    ),
                  ),
                ),
              ),

              // Logo (real `logo.svg`) positioned like the design and clipped to the card.
              Positioned.fromRect(
                rect: card,
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(68 * scale),
                    child: Stack(
                      children: [
                        Positioned(
                          left: logo.left - card.left,
                          top: logo.top - card.top,
                          width: logo.width,
                          height: logo.height,
                          child: SvgPicture.asset(
                            'assets/design/logo.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Title text (missing before): centered, black, inside the card.
              Positioned.fromRect(
                rect: title,
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      'DIPLOMA UITREIKING',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 72 * scale,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        letterSpacing: 1.2 * scale,
                      ),
                    ),
                  ),
                ),
              ),

              // Real input field aligned to the SVG input box.
              Positioned.fromRect(
                rect: input,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    // Per request: transparent background (keep border).
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16 * scale),
                    border: Border.all(color: Colors.black, width: 5 * scale),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: input.width,
                      height: input.height,
                      child: TextField(
                        controller: _controller,
                        enabled: !_loading,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 64 * scale,
                          fontWeight: FontWeight.w600,
                          height: 1.05,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          filled: false,
                          fillColor: Colors.transparent,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: '...',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 86 * scale,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Error message (fits the design card; does not reflow layout).
              Positioned.fromRect(
                rect: error,
                child: IgnorePointer(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: (_errorText == null || _errorText!.trim().isEmpty)
                          ? const SizedBox.shrink()
                          : Container(
                              key: ValueKey(_errorText),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18 * scale,
                                vertical: 8 * scale,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(14 * scale),
                              ),
                              child: Text(
                                _errorText!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26 * scale,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              // Tappable button area aligned to the SVG button.
              Positioned.fromRect(
                rect: button,
                child: MouseRegion(
                  cursor: _loading ? SystemMouseCursors.basic : SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _loading ? null : _submit,
                    onTapDown: _loading ? null : (_) => setState(() => _buttonPressed = true),
                    onTapCancel: () => setState(() => _buttonPressed = false),
                    onTapUp: _loading ? null : (_) => setState(() => _buttonPressed = false),
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      scale: _buttonPressed ? 0.985 : 1.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16 * scale),
                          border: Border.all(color: Colors.black, width: 5 * scale),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                _loading ? 'Inloggen...' : 'Inloggen',
                                style: TextStyle(
                                  color: const Color(0xFF8FE508),
                                  fontSize: 54 * scale,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 120),
                              opacity: _buttonPressed ? 0.12 : 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16 * scale),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MobileMainBackgroundPainter extends CustomPainter {
  _MobileMainBackgroundPainter({
    required this.scale,
    required this.dx,
    required this.dy,
    required this.designW,
    required this.designH,
  });

  final double scale;
  final double dx;
  final double dy;
  final double designW;
  final double designH;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint in design-space coordinates centered on the screen (dx/dy).
    canvas.save();
    canvas.translate(dx, dy);

    final rect = Rect.fromLTWH(0, 0, designW * scale, designH * scale);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black,
          Color(0xFF263E00),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Decorative neon squares (from the SVG).
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF8FE508).withValues(alpha: 0.4)
      ..strokeWidth = 3 * scale;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF8FE508).withValues(alpha: 0.22)
      ..strokeWidth = 14 * scale
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 * scale);

    final softGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF8FE508).withValues(alpha: 0.10)
      ..strokeWidth = 28 * scale
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 30 * scale);

    for (final r in _designSquares()) {
      final scaled = Rect.fromLTWH(
        r.left * scale,
        r.top * scale,
        r.width * scale,
        r.height * scale,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(scaled, const Radius.circular(0)), softGlowPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(scaled, const Radius.circular(0)), glowPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(scaled, const Radius.circular(0)), strokePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MobileMainBackgroundPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }

  // Extracted from `assets/design/Mobile - Main.svg` (stroke #8FE508 @ 0.4).
  // Coordinates are in the design artboard space (1333x2457).
  List<Rect> _designSquares() {
    // Base (non-transformed) rects:
    const base = <Rect>[
      Rect.fromLTWH(47.5, 2307.5, 120, 139),
      Rect.fromLTWH(123.5, 2258.5, 120, 139),
      Rect.fromLTWH(199.5, 2209.5, 120, 139),
      Rect.fromLTWH(138.5, 2154.5, 120, 139),
      Rect.fromLTWH(661.5, 2067.5, 120, 139),
      Rect.fromLTWH(765.5, 2091.5, 120, 139),
      Rect.fromLTWH(820.5, 2133.5, 120, 139),
      Rect.fromLTWH(679.5, 2182.5, 120, 139),
      Rect.fromLTWH(488.5, 2248.5, 120, 139),
      Rect.fromLTWH(1120.5, 2337.5, 120, 139),
      Rect.fromLTWH(1151.5, 2248.5, 120, 139),
      Rect.fromLTWH(1050.5, 2215.5, 120, 139),
      Rect.fromLTWH(1130.5, 1910.5, 120, 139),
      Rect.fromLTWH(1050.5, 1849.5, 120, 139),
      Rect.fromLTWH(1181.5, 1786.5, 120, 139),
      Rect.fromLTWH(1151.5, 1669.5, 120, 139),
      Rect.fromLTWH(395.5, 1873.5, 120, 139),
      Rect.fromLTWH(322.5, 1920.5, 120, 139),
      Rect.fromLTWH(365.5, 2040.5, 120, 139),
      Rect.fromLTWH(97.5, 1939.5, 120, 139),
      Rect.fromLTWH(975.5, 2032.5, 120, 139),
    ];

    // Transformed rects from SVG matrices.
    // matrix(-1 0 0 1 tx ty): x = tx - (x + w), y = ty + y
    Rect flipX(double x, double y, double w, double h, double tx, double ty) =>
        Rect.fromLTWH(tx - (x + w), ty + y, w, h);
    // matrix(1 0 0 -1 tx ty): x = tx + x, y = ty - (y + h)
    Rect flipY(double x, double y, double w, double h, double tx, double ty) =>
        Rect.fromLTWH(tx + x, ty - (y + h), w, h);

    const x = -1.5, y = 1.5, w = 120.0, h = 139.0;
    const x2 = 1.5, y2 = -1.5;

    final transformed = <Rect>[
      flipX(x, y, w, h, 1318, 1426),
      flipX(x, y, w, h, 1242, 1377),
      flipX(x, y, w, h, 1166, 1328),
      flipX(x, y, w, h, 1227, 1273),
      flipX(x, y, w, h, 704, 1186),
      flipX(x, y, w, h, 600, 1210),
      flipX(x, y, w, h, 545, 1252),
      flipX(x, y, w, h, 686, 1301),
      flipX(x, y, w, h, 877, 1367),
      flipX(x, y, w, h, 245, 1456),
      flipX(x, y, w, h, 214, 1367),
      flipX(x, y, w, h, 315, 1334),
      flipX(x, y, w, h, 235, 1029),
      flipX(x, y, w, h, 315, 968),
      flipX(x, y, w, h, 184, 905),
      flipX(x, y, w, h, 214, 788),
      flipX(x, y, w, h, 970, 992),
      flipX(x, y, w, h, 1043, 1039),
      flipX(x, y, w, h, 1000, 1159),
      flipX(x, y, w, h, 1268, 1058),
      flipX(x, y, w, h, 390, 1151),

      // flipY group (top decorative squares)
      flipY(x2, y2, w, h, 61, 147),
      flipY(x2, y2, w, h, 137, 196),
      flipY(x2, y2, w, h, 213, 245),
      flipY(x2, y2, w, h, 152, 300),
      flipY(x2, y2, w, h, 675, 387),
      flipY(x2, y2, w, h, 779, 363),
      flipY(x2, y2, w, h, 834, 321),
      flipY(x2, y2, w, h, 693, 272),
      flipY(x2, y2, w, h, 502, 206),
      flipY(x2, y2, w, h, 1134, 117),
      flipY(x2, y2, w, h, 1165, 206),
      flipY(x2, y2, w, h, 1064, 239),
      flipY(x2, y2, w, h, 1144, 544),
      flipY(x2, y2, w, h, 1064, 605),
      flipY(x2, y2, w, h, 1195, 668),
      flipY(x2, y2, w, h, 1165, 785),
      flipY(x2, y2, w, h, 409, 581),
      flipY(x2, y2, w, h, 336, 534),
      flipY(x2, y2, w, h, 379, 414),
      flipY(x2, y2, w, h, 111, 515),
      flipY(x2, y2, w, h, 989, 422),
    ];

    return [...base, ...transformed];
  }
}
