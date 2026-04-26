import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../app/router.dart';
import '../../../core/blocs/language/language_cubit.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/supported_languages.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // ─── Language ───
          _SectionHeader(title: '🌐  ${l10n.language}'),
          _SettingsTile(
            leading: const Icon(Icons.language),
            title: l10n.changeLanguage,
            subtitle: '${l10n.currentLanguage}: $langName',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, AppRouter.language,
                  arguments: {'isChanging': true});
            },
          ),

          const Divider(height: 1),

          // ─── Voice & Sound ───
          _SectionHeader(title: '🔊  ${l10n.voiceAndSound}'),
          _SettingsTile(
            leading: const Icon(Icons.record_voice_over),
            title: l10n.enableTTS,
            trailing: Switch(
              value: _getBool(HiveBoxes.kTtsEnabled),
              onChanged: (v) => _setBool(HiveBoxes.kTtsEnabled, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.play_circle),
            title: l10n.autoPlayResults,
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
                Text(l10n.speechSpeed,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(l10n.slow,
                        style:
                            const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
                    Text(l10n.fast,
                        style:
                            const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ─── Notifications ───
          _SectionHeader(title: '🔔  ${l10n.notifications}'),
          _SettingsTile(
            leading: const Icon(Icons.notifications_active),
            title: l10n.statusAlerts,
            trailing: Switch(
              value: _getBool(HiveBoxes.kStatusAlerts),
              onChanged: (v) => _setBool(HiveBoxes.kStatusAlerts, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.description),
            title: l10n.documentReminders,
            trailing: Switch(
              value: _getBool(HiveBoxes.kDocumentReminders),
              onChanged: (v) => _setBool(HiveBoxes.kDocumentReminders, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.new_releases),
            title: l10n.newSchemeAlerts,
            trailing: Switch(
              value: _getBool(HiveBoxes.kNewSchemeAlerts, defaultValue: false),
              onChanged: (v) => _setBool(HiveBoxes.kNewSchemeAlerts, v),
              activeColor: AppColors.primary,
            ),
          ),

          const Divider(height: 1),

          // ─── Accessibility ───
          _SectionHeader(title: '♿  ${l10n.accessibility}'),
          _SettingsTile(
            leading: const Icon(Icons.text_fields),
            title: l10n.largeText,
            subtitle: 'Increases font scale to 1.3x',
            trailing: Switch(
              value: _getBool(HiveBoxes.kLargeTextMode, defaultValue: false),
              onChanged: (v) => _setBool(HiveBoxes.kLargeTextMode, v),
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            leading: const Icon(Icons.contrast),
            title: l10n.highContrast,
            trailing: Switch(
              value: _getBool(HiveBoxes.kHighContrastMode, defaultValue: false),
              onChanged: (v) => _setBool(HiveBoxes.kHighContrastMode, v),
              activeColor: AppColors.primary,
            ),
          ),

          const Divider(height: 1),

          // ─── Data & Privacy ───
          _SectionHeader(title: '🔒  ${l10n.dataPrivacy}'),
          _SettingsTile(
            leading: const Icon(Icons.download),
            title: l10n.exportData,
            trailing: const Icon(Icons.chevron_right),
            onTap: _exportData,
          ),
          _SettingsTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: l10n.deleteAccount,
            titleColor: AppColors.error,
            trailing: const Icon(Icons.chevron_right, color: AppColors.error),
            onTap: _confirmDeleteAccount,
          ),

          const Divider(height: 1),

          // ─── About ───
          _SectionHeader(title: 'ℹ️  ${l10n.about}'),
          _SettingsTile(
            leading: const Icon(Icons.info_outline),
            title: l10n.appVersion,
            subtitle: _appVersion,
          ),
          _SettingsTile(
            leading: const Icon(Icons.favorite, color: AppColors.accentGreen),
            title: l10n.builtForBharat,
            subtitle: 'Making government accessible to all',
          ),
          _SettingsTile(
            leading: const Icon(Icons.email),
            title: l10n.contactSupport,
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested')),
              );
            },
            child: Text(l10n.confirm),
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
