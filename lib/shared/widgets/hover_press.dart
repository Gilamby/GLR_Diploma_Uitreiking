import 'package:flutter/material.dart';

class HoverPress extends StatefulWidget {
  const HoverPress({
    required this.child,
    required this.onTap,
    this.borderRadius = 16,
    this.hoverFillAlpha = 0.25,
    this.hoverBorderAlpha = 0.55,
    this.hoverGlowAlpha = 0.18,
    this.padding,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final double hoverFillAlpha;
  final double hoverBorderAlpha;
  final double hoverGlowAlpha;
  final EdgeInsets? padding;

  @override
  State<HoverPress> createState() => _HoverPressState();
}

class _HoverPressState extends State<HoverPress> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final baseBorderRadius = BorderRadius.circular(widget.borderRadius);
    final scale = _down ? 0.975 : (_hover ? 1.02 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _down = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: baseBorderRadius,
              color: Colors.black.withValues(alpha: _hover ? widget.hoverFillAlpha : 0.0),
              border: Border.all(
                color: const Color(0xFF8FE508)
                    .withValues(alpha: _hover ? widget.hoverBorderAlpha : 0.0),
                width: 2,
              ),
              boxShadow: [
                if (_hover)
                  BoxShadow(
                    color:
                        const Color(0xFF8FE508).withValues(alpha: widget.hoverGlowAlpha),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

