import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/language/language_cubit.dart';
import '../../../core/blocs/language/language_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../voice_intake/screens/voice_capture_screen.dart';
import '../../schemes/screens/scheme_list_screen.dart';
import '../../ai_chat/screens/ai_chat_screen.dart';
import '../../tracking/screens/application_history_screen.dart';
import '../../settings/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    VoiceCaptureScreen(),
    SchemeListScreen(),
    AiChatScreen(),
    ApplicationHistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final navItems = [
          _NavItem(icon: Icons.mic_rounded, label: l10n.discover),
          _NavItem(icon: Icons.list_alt_rounded, label: l10n.schemes),
          _NavItem(icon: Icons.auto_awesome_rounded, label: l10n.aiChat),
          _NavItem(icon: Icons.history_rounded, label: l10n.history),
          _NavItem(icon: Icons.settings_rounded, label: l10n.settings),
        ];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(navItems.length, (i) {
                  final item = navItems[i];
                  final isActive = _currentIndex == i;
                  final isAI = i == 2;

                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? (isAI
                                ? AppColors.secondary.withValues(alpha: 0.12)
                                : AppColors.primary.withValues(alpha: 0.1))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                item.icon,
                                color: isActive
                                    ? (isAI ? AppColors.secondary : AppColors.primary)
                                    : AppColors.textSecondary,
                                size: 24,
                              ),
                              if (isAI && !isActive)
                                Positioned(
                                  top: -3,
                                  right: -3,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                              color: isActive
                                  ? (isAI ? AppColors.secondary : AppColors.primary)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
