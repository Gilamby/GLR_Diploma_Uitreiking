import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/design_tokens.dart';
import 'design_background.dart';

class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: DesignTokens.neon,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: DesignTokens.black.withValues(alpha: 0.9),
          indicatorColor: DesignTokens.neon.withValues(alpha: 0.18),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: DesignTokens.neon),
          ),
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: DesignTokens.neon),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex(context),
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/photos');
                break;
              case 2:
                context.go('/livestream');
                break;
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              label: 'Photos',
            ),
            NavigationDestination(
              icon: Icon(Icons.live_tv_outlined),
              label: 'Live',
            ),
          ],
        ),
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/photos')) return 1;
    if (location == '/livestream') return 2;
    return 0;
  }
}
