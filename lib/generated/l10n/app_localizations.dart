import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Adhikar'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your Right. Delivered.'**
  String get tagline;

  /// No description provided for @builtForBharat.
  ///
  /// In en, this message translates to:
  /// **'Built for Bharat 🇮🇳'**
  String get builtForBharat;

  /// No description provided for @poweredByAI.
  ///
  /// In en, this message translates to:
  /// **'Powered by AI for Bharat'**
  String get poweredByAI;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @continueWithEnglish.
  ///
  /// In en, this message translates to:
  /// **'Continue with English'**
  String get continueWithEnglish;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChanged(String language);

  /// No description provided for @voiceInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Describe your situation'**
  String get voiceInputTitle;

  /// No description provided for @voiceInputSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Speak about yourself, your family, income, occupation, etc.'**
  String get voiceInputSubtitle;

  /// No description provided for @transcriptLabel.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcriptLabel;

  /// No description provided for @typeInstead.
  ///
  /// In en, this message translates to:
  /// **'Type instead of speaking'**
  String get typeInstead;

  /// No description provided for @transcriptHint.
  ///
  /// In en, this message translates to:
  /// **'Your speech will appear here...'**
  String get transcriptHint;

  /// No description provided for @pleaseSpeak.
  ///
  /// In en, this message translates to:
  /// **'Please speak or type your information'**
  String get pleaseSpeak;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @tapToSpeakAgain.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak again'**
  String get tapToSpeakAgain;

  /// No description provided for @enterYourInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter your information'**
  String get enterYourInfo;

  /// No description provided for @describeHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your situation...'**
  String get describeHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @listeningIn.
  ///
  /// In en, this message translates to:
  /// **'Listening in: {language}'**
  String listeningIn(String language);

  /// No description provided for @speakPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please describe your situation in your own words'**
  String get speakPrompt;

  /// No description provided for @analyzingVoice.
  ///
  /// In en, this message translates to:
  /// **'Understanding your situation...'**
  String get analyzingVoice;

  /// No description provided for @matchingSchemes.
  ///
  /// In en, this message translates to:
  /// **'Finding your benefits...'**
  String get matchingSchemes;

  /// No description provided for @generatingForm.
  ///
  /// In en, this message translates to:
  /// **'Preparing your application...'**
  String get generatingForm;

  /// No description provided for @schemesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} Schemes Eligible'**
  String schemesFound(int count);

  /// No description provided for @totalBenefit.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} / year'**
  String totalBenefit(String amount);

  /// No description provided for @totalEstimatedBenefits.
  ///
  /// In en, this message translates to:
  /// **'Total Estimated Benefits'**
  String get totalEstimatedBenefits;

  /// No description provided for @eligibleSchemes.
  ///
  /// In en, this message translates to:
  /// **'Eligible Schemes'**
  String get eligibleSchemes;

  /// No description provided for @noSchemesFound.
  ///
  /// In en, this message translates to:
  /// **'No schemes found'**
  String get noSchemesFound;

  /// No description provided for @tryUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Try updating your profile to see eligible schemes'**
  String get tryUpdatingProfile;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @schemeDetails.
  ///
  /// In en, this message translates to:
  /// **'Scheme Details'**
  String get schemeDetails;

  /// No description provided for @eligibilityScore.
  ///
  /// In en, this message translates to:
  /// **'Eligibility Score'**
  String get eligibilityScore;

  /// No description provided for @whyEligible.
  ///
  /// In en, this message translates to:
  /// **'Why Eligible?'**
  String get whyEligible;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @requiredDocuments.
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get requiredDocuments;

  /// No description provided for @applicationInfo.
  ///
  /// In en, this message translates to:
  /// **'Application Information'**
  String get applicationInfo;

  /// No description provided for @ministry.
  ///
  /// In en, this message translates to:
  /// **'Ministry'**
  String get ministry;

  /// No description provided for @applyAt.
  ///
  /// In en, this message translates to:
  /// **'Apply At'**
  String get applyAt;

  /// No description provided for @visitOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Official Website'**
  String get visitOfficialWebsite;

  /// No description provided for @documentsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Documents You Need'**
  String get documentsNeeded;

  /// No description provided for @iHaveAllDocuments.
  ///
  /// In en, this message translates to:
  /// **'I have all documents → Apply Now'**
  String get iHaveAllDocuments;

  /// No description provided for @missingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Missing documents → Save for later'**
  String get missingDocuments;

  /// No description provided for @howToGet.
  ///
  /// In en, this message translates to:
  /// **'How to get?'**
  String get howToGet;

  /// No description provided for @findNearestOffice.
  ///
  /// In en, this message translates to:
  /// **'Find Nearest Office'**
  String get findNearestOffice;

  /// No description provided for @shareScheme.
  ///
  /// In en, this message translates to:
  /// **'Share Scheme'**
  String get shareScheme;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'{name}\nBenefit: {benefit}\nEligibility: {eligibility}\nApply at: {url}\n\nFound using Adhikar app'**
  String shareText(String name, String benefit, String eligibility, String url);

  /// No description provided for @applicationHistory.
  ///
  /// In en, this message translates to:
  /// **'Application History'**
  String get applicationHistory;

  /// No description provided for @noApplications.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get noApplications;

  /// No description provided for @allSchemes.
  ///
  /// In en, this message translates to:
  /// **'All Schemes'**
  String get allSchemes;

  /// No description provided for @forUser.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get forUser;

  /// No description provided for @hearResults.
  ///
  /// In en, this message translates to:
  /// **'Hear results'**
  String get hearResults;

  /// No description provided for @eligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible'**
  String get eligible;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @noSchemesMatch.
  ///
  /// In en, this message translates to:
  /// **'No schemes match'**
  String get noSchemesMatch;

  /// No description provided for @noSchemesInCategory.
  ///
  /// In en, this message translates to:
  /// **'No schemes in this category'**
  String get noSchemesInCategory;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @statusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get statusUnderReview;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @submittedDate.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String submittedDate(String date);

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Ref: {number}'**
  String referenceNumber(String number);

  /// No description provided for @offlineMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing saved schemes.'**
  String get offlineMessage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentLanguage;

  /// No description provided for @voiceAndSound.
  ///
  /// In en, this message translates to:
  /// **'Voice & Sound'**
  String get voiceAndSound;

  /// No description provided for @enableTTS.
  ///
  /// In en, this message translates to:
  /// **'Enable TTS Narration'**
  String get enableTTS;

  /// No description provided for @autoPlayResults.
  ///
  /// In en, this message translates to:
  /// **'Auto-play Results'**
  String get autoPlayResults;

  /// No description provided for @speechSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speech Speed'**
  String get speechSpeed;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @statusAlerts.
  ///
  /// In en, this message translates to:
  /// **'Application Status Alerts'**
  String get statusAlerts;

  /// No description provided for @documentReminders.
  ///
  /// In en, this message translates to:
  /// **'Document Reminders'**
  String get documentReminders;

  /// No description provided for @newSchemeAlerts.
  ///
  /// In en, this message translates to:
  /// **'New Scheme Alerts'**
  String get newSchemeAlerts;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @largeText.
  ///
  /// In en, this message translates to:
  /// **'Large Text Mode'**
  String get largeText;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast Mode'**
  String get highContrast;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataPrivacy;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get exportData;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteAccount;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your data. This action cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Adhikar'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Your personal guide to every government welfare scheme you deserve — in your language.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Speak Your Situation'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Just tap the mic and describe yourself — your age, occupation, family, income. Our AI understands your language.'**
  String get onboarding2Body;

  /// No description provided for @onboarding2Example.
  ///
  /// In en, this message translates to:
  /// **'I am a 45-year-old widow farmer with 2 acres of land...'**
  String get onboarding2Example;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Benefits'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'We match your profile to 200+ government schemes and show you exactly what you\'re entitled to — with benefit amounts.'**
  String get onboarding3Body;

  /// No description provided for @onboarding4Title.
  ///
  /// In en, this message translates to:
  /// **'Apply Instantly'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Body.
  ///
  /// In en, this message translates to:
  /// **'We auto-fill application forms for you. Find the nearest office on the map. Track your application status live.'**
  String get onboarding4Body;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skipOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipOnboarding;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet. Please try again.'**
  String get networkError;

  /// No description provided for @geminiError.
  ///
  /// In en, this message translates to:
  /// **'AI unavailable. Using basic matching.'**
  String get geminiError;

  /// No description provided for @firebaseError.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Data saved locally.'**
  String get firebaseError;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryAgriculture.
  ///
  /// In en, this message translates to:
  /// **'Agriculture'**
  String get categoryAgriculture;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get categoryHousing;

  /// No description provided for @categoryWomen.
  ///
  /// In en, this message translates to:
  /// **'Women & Child'**
  String get categoryWomen;

  /// No description provided for @categoryEmployment.
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get categoryEmployment;

  /// No description provided for @categoryDisability.
  ///
  /// In en, this message translates to:
  /// **'Disability'**
  String get categoryDisability;

  /// No description provided for @categorySenior.
  ///
  /// In en, this message translates to:
  /// **'Senior Citizen'**
  String get categorySenior;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @caste.
  ///
  /// In en, this message translates to:
  /// **'Caste Category'**
  String get caste;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get income;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @landOwned.
  ///
  /// In en, this message translates to:
  /// **'Land Owned (acres)'**
  String get landOwned;

  /// No description provided for @familySize.
  ///
  /// In en, this message translates to:
  /// **'Family Size'**
  String get familySize;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @disability.
  ///
  /// In en, this message translates to:
  /// **'Disability'**
  String get disability;

  /// No description provided for @helpButton.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get helpButton;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @aiGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello! I am Adhikar AI. Ask me anything about government schemes.'**
  String get aiGreeting;

  /// No description provided for @askScheme.
  ///
  /// In en, this message translates to:
  /// **'Ask about any scheme...'**
  String get askScheme;

  /// No description provided for @profileReview.
  ///
  /// In en, this message translates to:
  /// **'Profile Review'**
  String get profileReview;

  /// No description provided for @noProfileData.
  ///
  /// In en, this message translates to:
  /// **'No profile found. Please go back and speak again.'**
  String get noProfileData;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @schemes.
  ///
  /// In en, this message translates to:
  /// **'Schemes'**
  String get schemes;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @economicInfo.
  ///
  /// In en, this message translates to:
  /// **'Economic Information'**
  String get economicInfo;

  /// No description provided for @socialStatus.
  ///
  /// In en, this message translates to:
  /// **'Social Status'**
  String get socialStatus;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get fieldAge;

  /// No description provided for @fieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get fieldGender;

  /// No description provided for @fieldState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get fieldState;

  /// No description provided for @fieldDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get fieldDistrict;

  /// No description provided for @fieldCaste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get fieldCaste;

  /// No description provided for @fieldOccupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get fieldOccupation;

  /// No description provided for @fieldAnnualIncome.
  ///
  /// In en, this message translates to:
  /// **'Annual Income ()'**
  String get fieldAnnualIncome;

  /// No description provided for @fieldLandHolding.
  ///
  /// In en, this message translates to:
  /// **'Land (acres)'**
  String get fieldLandHolding;

  /// No description provided for @fieldFamilySize.
  ///
  /// In en, this message translates to:
  /// **'Family Size'**
  String get fieldFamilySize;

  /// No description provided for @fieldBplCard.
  ///
  /// In en, this message translates to:
  /// **'BPL Card'**
  String get fieldBplCard;

  /// No description provided for @fieldAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card'**
  String get fieldAadhaar;

  /// No description provided for @fieldBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get fieldBankAccount;

  /// No description provided for @fieldWidow.
  ///
  /// In en, this message translates to:
  /// **'Widow'**
  String get fieldWidow;

  /// No description provided for @fieldDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get fieldDisabled;

  /// No description provided for @fieldPregnant.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get fieldPregnant;

  /// No description provided for @fieldEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get fieldEducation;

  /// No description provided for @findEligibleSchemes.
  ///
  /// In en, this message translates to:
  /// **'Find Eligible Schemes'**
  String get findEligibleSchemes;

  /// No description provided for @notDetected.
  ///
  /// In en, this message translates to:
  /// **'Not detected'**
  String get notDetected;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @acres.
  ///
  /// In en, this message translates to:
  /// **'acres'**
  String get acres;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @occupationFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get occupationFarmer;

  /// No description provided for @occupationStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get occupationStudent;

  /// No description provided for @occupationDailyWage.
  ///
  /// In en, this message translates to:
  /// **'Daily Wage'**
  String get occupationDailyWage;

  /// No description provided for @occupationBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get occupationBusiness;

  /// No description provided for @occupationGovernment.
  ///
  /// In en, this message translates to:
  /// **'Government'**
  String get occupationGovernment;

  /// No description provided for @occupationUnemployed.
  ///
  /// In en, this message translates to:
  /// **'Unemployed'**
  String get occupationUnemployed;

  /// No description provided for @categoryWomenChild.
  ///
  /// In en, this message translates to:
  /// **'Women & Child'**
  String get categoryWomenChild;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @documentsReady.
  ///
  /// In en, this message translates to:
  /// **'Documents Ready'**
  String get documentsReady;

  /// No description provided for @saveForLater.
  ///
  /// In en, this message translates to:
  /// **'Save for Later'**
  String get saveForLater;

  /// No description provided for @applyAnyway.
  ///
  /// In en, this message translates to:
  /// **'Apply Anyway'**
  String get applyAnyway;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @documentsMissing.
  ///
  /// In en, this message translates to:
  /// **'documents missing. Gather them before applying.'**
  String get documentsMissing;

  /// No description provided for @documentsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved for later — check My Applications'**
  String get documentsSaved;

  /// No description provided for @documentsYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Documents You Need'**
  String get documentsYouNeed;

  /// No description provided for @documentsReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents Ready'**
  String get documentsReadyTitle;

  /// No description provided for @ofWord.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofWord;

  /// No description provided for @applyNowButton.
  ///
  /// In en, this message translates to:
  /// **'Apply Now ✓'**
  String get applyNowButton;

  /// No description provided for @visitGovtOffice.
  ///
  /// In en, this message translates to:
  /// **'Visit your nearest government office with valid ID proof.'**
  String get visitGovtOffice;

  /// No description provided for @fieldMinistry.
  ///
  /// In en, this message translates to:
  /// **'Ministry'**
  String get fieldMinistry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bn',
        'en',
        'gu',
        'hi',
        'kn',
        'ml',
        'mr',
        'or',
        'pa',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
