import 'package:flutter/material.dart';

/// Shared mobile design frame used by all recreated screens.
///
/// - Keeps a fixed **design artboard** (default 1333x2457) centered on screen.
/// - Draws the shared background (gradient + neon squares) in design-space.
/// - Provides a `map()` helper to place widgets using SVG coordinates.
class MobileDesignFrame extends StatelessWidget {
  const MobileDesignFrame({
    required this.children,
    this.designSize = const Size(1333, 2457),
    super.key,
  });

  final Size designSize;
  final List<Widget Function(DesignMapping m)> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapping = _DesignMapping.fromConstraints(
            constraints: constraints,
            designSize: designSize,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _NeonSquaresBackgroundPainter(mapping: mapping),
                ),
              ),
              ...children.map((b) => b(DesignMapping._(mapping))),
            ],
          );
        },
      ),
    );
  }
}

class DesignMapping {
  const DesignMapping._(this._m);

  final _DesignMapping _m;

  double get scale => _m.scale;
  double get dx => _m.dx;
  double get dy => _m.dy;
  Size get designSize => _m.designSize;
  Rect get designRect => _m.designRect;
  Rect map(Rect r) => _m.map(r);
}

class _DesignMapping {
  _DesignMapping({
    required this.scale,
    required this.dx,
    required this.dy,
    required this.designSize,
  });

  final double scale;
  final double dx;
  final double dy;
  final Size designSize;

  Rect map(Rect r) => Rect.fromLTWH(
        dx + r.left * scale,
        dy + r.top * scale,
        r.width * scale,
        r.height * scale,
      );

  Rect get designRect => Rect.fromLTWH(
        dx,
        dy,
        designSize.width * scale,
        designSize.height * scale,
      );

  static _DesignMapping fromConstraints({
    required BoxConstraints constraints,
    required Size designSize,
  }) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final scale = (w / designSize.width < h / designSize.height)
        ? (w / designSize.width)
        : (h / designSize.height);
    final renderW = designSize.width * scale;
    final renderH = designSize.height * scale;
    final dx = (w - renderW) / 2;
    final dy = (h - renderH) / 2;
    return _DesignMapping(scale: scale, dx: dx, dy: dy, designSize: designSize);
  }
}

class _NeonSquaresBackgroundPainter extends CustomPainter {
  _NeonSquaresBackgroundPainter({required this.mapping});

  final _DesignMapping mapping;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint in centered design-space (dx/dy).
    canvas.save();
    canvas.translate(mapping.dx, mapping.dy);

    final rect = Rect.fromLTWH(0, 0, mapping.designSize.width * mapping.scale,
        mapping.designSize.height * mapping.scale);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Color(0xFF263E00)],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    final scale = mapping.scale;

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
  bool shouldRepaint(covariant _NeonSquaresBackgroundPainter oldDelegate) {
    return oldDelegate.mapping.scale != mapping.scale ||
        oldDelegate.mapping.dx != mapping.dx ||
        oldDelegate.mapping.dy != mapping.dy;
  }

  // Shared squares (from `Mobile - Main.svg`). We reuse this background across screens.
  List<Rect> _designSquares() {
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

    Rect flipX(double x, double y, double w, double h, double tx, double ty) =>
        Rect.fromLTWH(tx - (x + w), ty + y, w, h);
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

