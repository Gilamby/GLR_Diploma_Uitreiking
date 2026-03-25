import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_repository.dart';
import '../../../shared/widgets/mobile_design_frame.dart';

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
    // Label inside the green frame (above the input).
    const labelRect = Rect.fromLTWH(174, 1218, 992, 70);
    // Title + logo should be ABOVE the green card (see Image 1).
    // Give the title more vertical room so it never clips.
    const titleRect = Rect.fromLTWH(110, 740, 1113, 320);
    // Logo should be at the very top.
    const logoRect = Rect.fromLTWH(180, 180, 973, 520);

    return MobileDesignFrame(
      designSize: const Size(designW, designH),
      children: [
        (m) {
          final scale = m.scale;
          final input = m.map(inputRect);
          final button = m.map(buttonRect);
          final card = m.map(cardRect);
          final title = m.map(titleRect);
          final logo = m.map(logoRect);
          final label = m.map(labelRect);

          return Stack(
            children: [

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

              // Logo at the top.
              Positioned.fromRect(
                rect: logo,
                child: IgnorePointer(
                  child: SvgPicture.asset(
                    'assets/design/logo.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Title text (big neon) above the card.
              Positioned.fromRect(
                rect: title,
                child: IgnorePointer(
                  child: Center(
                    child: OverflowBox(
                      minHeight: 0,
                      maxHeight: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'DIPLOMA UITREIKING',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          color: const Color(0xFF8FE508),
                          fontSize: 130 * scale,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          letterSpacing: 1.0 * scale,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Label inside the login card above the input.
              Positioned.fromRect(
                rect: label,
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      'Voer de toegangscode in:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 44 * scale,
                        fontWeight: FontWeight.w700,
                        height: 1,
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
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 1,
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
                          isCollapsed: true,
                          // Keep text visually centered within the outlined box.
                          // Horizontal padding is zero (design centers text); vertical is tuned.
                          contentPadding: EdgeInsets.symmetric(vertical: input.height * 0.28),
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

              // Error message anchored at bottom of the screen (high visibility).
              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: IgnorePointer(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: (_errorText == null || _errorText!.trim().isEmpty)
                          ? const SizedBox.shrink()
                          : Container(
                              key: ValueKey(_errorText),
                              constraints: const BoxConstraints(maxWidth: 860),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18 * scale,
                                vertical: 12 * scale,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.62),
                                borderRadius: BorderRadius.circular(16 * scale),
                                border: Border.all(
                                  color: const Color(0xFF8FE508).withValues(alpha: 0.65),
                                  width: 2 * scale,
                                ),
                              ),
                              child: Text(
                                _errorText!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF8FE508),
                                  fontSize: 30 * scale,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
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
      ],
    );
  }
}
