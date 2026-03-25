import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/mobile_bottom_nav.dart';
import '../../../shared/widgets/mobile_design_frame.dart';
import '../../../shared/widgets/mobile_top_logo.dart';
import '../../../shared/widgets/hover_press.dart';
import '../presentation/vimeo_player.dart';
import '../data/vimeo_repository.dart';

final latestVimeoVideoProvider = FutureProvider<VimeoVideo?>((ref) {
  return ref.watch(vimeoRepositoryProvider).fetchLatestShowcaseVideo();
});

class LivestreamScreen extends ConsumerStatefulWidget {
  const LivestreamScreen({super.key});

  @override
  ConsumerState<LivestreamScreen> createState() => _LivestreamScreenState();
}

class _LivestreamScreenState extends ConsumerState<LivestreamScreen> {
  final _chatController = TextEditingController();
  final _chatScroll = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(author: 'Host', text: 'Welkom bij de livestream chat!', isMe: false),
    const _ChatMessage(author: 'Jij', text: 'Hoi!', isMe: true),
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _chatScroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_chatScroll.hasClients) return;
    _chatScroll.animateTo(
      _chatScroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  void _send() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(author: 'Jij', text: text, isMe: true));
      _chatController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final videoSnapshot = ref.watch(latestVimeoVideoProvider);
    // Recreate `assets/design/Mobile - Live.svg` layout (key blocks).
    // Content card: x=120, y=303, w=1094, h=693, r=68, fill #96EF09, stroke black 9
    // Video frame:  x=105, y=299, w=1124, h=820, stroke #8FE508 width 6
    // Overlay panel: x=108, y=1193, w=1118, h=787, r=16, fill #8FE508@0.4, stroke black 5
    // Top bar:      x=127, y=985, w=1083, h=108, r=16, fill black@0.4
    const contentCard = Rect.fromLTWH(120, 303, 1094, 693);
    const videoFrame = Rect.fromLTWH(105, 299, 1124, 820);
    const overlayPanel = Rect.fromLTWH(108, 1193, 1118, 787);
    const topBar = Rect.fromLTWH(127, 985, 1083, 108);

    return MobileDesignFrame(
      children: [
        (m) {
          final s = m.scale;
          final card = m.map(contentCard);
          final frame = m.map(videoFrame);
          final panel = m.map(overlayPanel);
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
                      borderRadius: BorderRadius.circular(22 * s),
                      border: Border.all(color: const Color(0xFF8FE508), width: 6 * s),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: card,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF96EF09),
                      borderRadius: BorderRadius.circular(68 * s),
                    ),
                  ),
                ),
              ),
              // Vimeo player area inside the green card (matches Image 1 red box).
              Positioned.fromRect(
                rect: card.deflate(28 * s),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(48 * s),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Color(0xFF96EF09)),
                    child: videoSnapshot.when(
                      data: (video) {
                        if (video == null) {
                          return Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 140 * s,
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                          );
                        }
                        return VimeoPlayer(url: video.playerEmbedUrl);
                      },
                      error: (_, __) => Center(
                        child: Text(
                          'Kon Vimeo video niet laden.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.85),
                            fontSize: 40 * s,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
              // Subtle inner edge for the livestream area (cleaner than heavy black strokes).
              Positioned.fromRect(
                rect: card.deflate(28 * s),
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48 * s),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.18),
                        width: 2 * s,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: bar,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16 * s),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: bar,
                child: Center(
                  child: Text(
                    'LIVESTREAM',
                    style: TextStyle(
                      color: const Color(0xFF8FE508),
                      fontSize: 54 * s,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
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
                    padding: EdgeInsets.all(24 * s),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CHAT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 44 * s,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 14 * s),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12 * s),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.22),
                              ),
                              child: ListView.builder(
                                controller: _chatScroll,
                                padding: EdgeInsets.all(14 * s),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  final msg = _messages[index];
                                  return Align(
                                    alignment: msg.isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: panel.width * 0.85),
                                      margin: EdgeInsets.only(bottom: 10 * s),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14 * s,
                                        vertical: 10 * s,
                                      ),
                                      decoration: BoxDecoration(
                                        color: msg.isMe
                                            ? Colors.black.withValues(alpha: 0.55)
                                            : Colors.black.withValues(alpha: 0.32),
                                        borderRadius: BorderRadius.circular(14 * s),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            msg.author,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.70),
                                              fontSize: 20 * s,
                                              fontWeight: FontWeight.w900,
                                              height: 1,
                                            ),
                                          ),
                                          SizedBox(height: 6 * s),
                                          Text(
                                            msg.text,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.92),
                                              fontSize: 28 * s,
                                              fontWeight: FontWeight.w800,
                                              height: 1.15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12 * s),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16 * s),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.28),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 14 * s),
                                    child: TextField(
                                      controller: _chatController,
                                      onSubmitted: (_) => _send(),
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.92),
                                        fontSize: 30 * s,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Typ een bericht...',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.55),
                                          fontSize: 30 * s,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6 * s),
                                  child: HoverPress(
                                    onTap: _send,
                                    borderRadius: 14 * s,
                                    hoverFillAlpha: 0.08,
                                    hoverBorderAlpha: 0.0,
                                    hoverGlowAlpha: 0.0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14 * s,
                                      vertical: 10 * s,
                                    ),
                                    child: Icon(
                                      Icons.send_rounded,
                                      size: 44 * s,
                                      color: Colors.white.withValues(alpha: 0.92),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

class _ChatMessage {
  const _ChatMessage({required this.author, required this.text, required this.isMe});
  final String author;
  final String text;
  final bool isMe;
}
