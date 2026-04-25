import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/router.dart';
import '../../../core/blocs/language/language_cubit.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/supported_languages.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box _settings;
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _settings = Hive.box(HiveBoxes.kSettingsBox);
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _appVersion = info.version);
    } catch (_) {}
  }

  bool _getBool(String key, {bool defaultValue = true}) {
    return _settings.get(key, defaultValue: defaultValue) as bool;
  }

  Future<void> _setBool(String key, bool value) async {
    await _settings.put(key, value);
    setState(() {});
  }

  double _getSpeechRate() {
    return (_settings.get(HiveBoxes.kSpeechRate, defaultValue: 0.45) as num)
        .toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LanguageCubit>();
    final langCode = cubit.currentLanguageCode;
    final langName = SupportedLanguages.languages[langCode] ?? 'English';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // ─── Language ───
          _SectionHeader(title: '🌐  Language'),
          _SettingsTile(
            leading: const Icon(Icons.language),
            title: 'Change Language',
            subtitle: 'Current: $langName',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRouter.language,
                  arguments: {'isChanging': true});
            },
          ),

          const Divider(height: 1),

          // ─── Voice & Sound ───
          _SectionHeader(title: '🔊  Voice & Sound'),
          _SettingsTile(
            leading: const Icon(Icons.record_voice_over),
            title: 'Enable TTS Narration',
            trailing: Switch(
              value: _getBool(HiveBoxes.kTtsEnabled),
              onChanged: (v) => _setBool(HiveBoxes.kTtsEnabled, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.play_circle),
            title: 'Auto-play Results',
            trailing: Switch(
              value: _getBool(HiveBoxes.kAutoPlayResults),
              onChanged: (v) => _setBool(HiveBoxes.kAutoPlayResults, v),
              activeColor: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Speech Speed',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Slow',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    Expanded(
                      child: Slider(
                        value: _getSpeechRate(),
                        min: 0.25,
                        max: 0.75,
                        divisions: 4,
                        activeColor: AppColors.primary,
                        onChanged: (v) async {
                          await _settings.put(HiveBoxes.kSpeechRate, v);
                          setState(() {});
                        },
                      ),
                    ),
                    const Text('Fast',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ─── Notifications ───
          _SectionHeader(title: '🔔  Notifications'),
          _SettingsTile(
            leading: const Icon(Icons.notifications_active),
            title: 'Application Status Alerts',
            trailing: Switch(
              value: _getBool(HiveBoxes.kStatusAlerts),
              onChanged: (v) => _setBool(HiveBoxes.kStatusAlerts, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.description),
            title: 'Document Reminders',
            trailing: Switch(
              value: _getBool(HiveBoxes.kDocumentReminders),
              onChanged: (v) => _setBool(HiveBoxes.kDocumentReminders, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.new_releases),
            title: 'New Scheme Alerts',
            trailing: Switch(
              value: _getBool(HiveBoxes.kNewSchemeAlerts, defaultValue: false),
              onChanged: (v) => _setBool(HiveBoxes.kNewSchemeAlerts, v),
              activeColor: AppColors.primary,
            ),
          ),

          const Divider(height: 1),

          // ─── Accessibility ───
          _SectionHeader(title: '♿  Accessibility'),
          _SettingsTile(
            leading: const Icon(Icons.text_fields),
            title: 'Large Text Mode',
            subtitle: 'Increases font scale to 1.3x',
            trailing: Switch(
              value: _getBool(HiveBoxes.kLargeTextMode, defaultValue: false),
              onChanged: (v) => _setBool(HiveBoxes.kLargeTextMode, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.contrast),
            title: 'High Contrast Mode',
            trailing: Switch(
              value: _getBool(HiveBoxes.kHighContrastMode, defaultValue: false),
              onChanged: (v) => _setBool(HiveBoxes.kHighContrastMode, v),
              activeColor: AppColors.primary,
            ),
          ),

          const Divider(height: 1),

          // ─── Data & Privacy ───
          _SectionHeader(title: '🔒  Data & Privacy'),
          _SettingsTile(
            leading: const Icon(Icons.download),
            title: 'Export My Data',
            trailing: const Icon(Icons.chevron_right),
            onTap: _exportData,
          ),
          _SettingsTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: 'Delete My Account',
            titleColor: AppColors.error,
            trailing: const Icon(Icons.chevron_right, color: AppColors.error),
            onTap: _confirmDeleteAccount,
          ),

          const Divider(height: 1),

          // ─── About ───
          _SectionHeader(title: 'ℹ️  About'),
          _SettingsTile(
            leading: const Icon(Icons.info_outline),
            title: 'App Version',
            subtitle: _appVersion,
          ),
          _SettingsTile(
            leading: const Icon(Icons.favorite, color: AppColors.accentGreen),
            title: 'Built for Bharat 🇮🇳',
            subtitle: 'Making government accessible to all',
          ),
          _SettingsTile(
            leading: const Icon(Icons.email),
            title: 'Contact Support',
            subtitle: 'support@adhikar.gov.in',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export coming soon')),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
            'This will permanently delete all your data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary))
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
