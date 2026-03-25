import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Design-space rect for the bottom bar in all SVGs.
const mobileBottomNavRect = Rect.fromLTWH(0, 2295, 1333, 162);

class MobileBottomNavBar extends StatelessWidget {
  const MobileBottomNavBar({
    required this.scale,
    super.key,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 90 * scale),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavIconButton(
              scale: scale,
              icon: Icons.home_rounded,
              onTap: () => context.go('/home'),
            ),
            _NavIconButton(
              scale: scale,
              icon: Icons.play_arrow_rounded,
              onTap: () => context.go('/livestream'),
            ),
            _NavIconButton(
              scale: scale,
              icon: Icons.photo_library_rounded,
              onTap: () => context.go('/photos'),
            ),
            _NavIconButton(
              scale: scale,
              icon: Icons.menu_book_rounded,
              onTap: () => context.go('/jaarboek'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.scale,
    required this.icon,
    required this.onTap,
  });

  final double scale;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _HoverPressButton(
      scale: scale,
      onTap: onTap,
      child: Icon(
        icon,
        size: 88 * scale,
        color: const Color(0xFF8FE508).withValues(alpha: 0.92),
      ),
    );
  }
}

class _HoverPressButton extends StatefulWidget {
  const _HoverPressButton({
    required this.scale,
    required this.onTap,
    required this.child,
  });

  final double scale;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_HoverPressButton> createState() => _HoverPressButtonState();
}

class _HoverPressButtonState extends State<_HoverPressButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final scale = _down ? 0.96 : (_hover ? 1.07 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _down = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOutCubic,
          child: Padding(
            padding: EdgeInsets.all(24 * widget.scale),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

