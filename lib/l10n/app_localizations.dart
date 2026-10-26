import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CardSaathi'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Smart Digital Business Card Partner'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get navCards;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get navReminders;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @scanCardButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Visiting Card'**
  String get scanCardButton;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @recentCards.
  ///
  /// In en, this message translates to:
  /// **'Recent Cards'**
  String get recentCards;

  /// No description provided for @upcomingMeetings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Meetings'**
  String get upcomingMeetings;

  /// No description provided for @noCardsYet.
  ///
  /// In en, this message translates to:
  /// **'No cards added yet'**
  String get noCardsYet;

  /// No description provided for @noMeetingsToday.
  ///
  /// In en, this message translates to:
  /// **'No meetings scheduled for today'**
  String get noMeetingsToday;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Visiting Card'**
  String get scanTitle;

  /// No description provided for @scanInstructions.
  ///
  /// In en, this message translates to:
  /// **'Align the business card within the frame'**
  String get scanInstructions;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Card Details'**
  String get reviewTitle;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save Card'**
  String get saveCard;

  /// No description provided for @retakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakePhoto;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company / Business'**
  String get company;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Designation / Role'**
  String get jobTitle;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Business Address'**
  String get address;

  /// No description provided for @gstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN / Tax ID'**
  String get gstin;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Business Category'**
  String get category;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes & Key Context'**
  String get notes;

  /// No description provided for @shareOnWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get shareOnWhatsApp;

  /// No description provided for @whatsAppGreeting.
  ///
  /// In en, this message translates to:
  /// **'Great meeting you! Here is my digital business card.'**
  String get whatsAppGreeting;

  /// No description provided for @callDirectly.
  ///
  /// In en, this message translates to:
  /// **'Call Directly'**
  String get callDirectly;

  /// No description provided for @recordVoiceMemo.
  ///
  /// In en, this message translates to:
  /// **'Record 10s Voice Memo'**
  String get recordVoiceMemo;

  /// No description provided for @voiceMemoSaved.
  ///
  /// In en, this message translates to:
  /// **'Voice memo attached'**
  String get voiceMemoSaved;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageToggle.
  ///
  /// In en, this message translates to:
  /// **'Language / भाषा'**
  String get languageToggle;

  /// No description provided for @cameraDisclosure.
  ///
  /// In en, this message translates to:
  /// **'CardSaathi only uses camera to scan physical visiting cards. Your data stays securely on your phone.'**
  String get cameraDisclosure;

  /// No description provided for @deleteAccountData.
  ///
  /// In en, this message translates to:
  /// **'Permanently Delete Account & All Data'**
  String get deleteAccountData;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your scanned cards, voice notes, and categories will be permanently removed.'**
  String get deleteConfirmMessage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cardFront.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get cardFront;

  /// No description provided for @cardBack.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get cardBack;

  /// No description provided for @cameraDisclosureTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Disclosure'**
  String get cameraDisclosureTitle;

  /// No description provided for @agreeAndEnable.
  ///
  /// In en, this message translates to:
  /// **'Agree & Continue'**
  String get agreeAndEnable;

  /// No description provided for @useGalleryOnly.
  ///
  /// In en, this message translates to:
  /// **'Use Gallery Only'**
  String get useGalleryOnly;

  /// No description provided for @alignCardInFrame.
  ///
  /// In en, this message translates to:
  /// **'Align visiting card in frame'**
  String get alignCardInFrame;

  /// No description provided for @cardCaptured.
  ///
  /// In en, this message translates to:
  /// **'Card captured successfully'**
  String get cardCaptured;

  /// No description provided for @holdSteadyHint.
  ///
  /// In en, this message translates to:
  /// **'Hold steady in bright light for clean OCR'**
  String get holdSteadyHint;

  /// No description provided for @offlinePrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Scans stored 100% locally on your phone. Safe & private.'**
  String get offlinePrivacyNotice;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording... (10s max)'**
  String get recording;

  /// No description provided for @tapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get tapToStop;

  /// No description provided for @playMemo.
  ///
  /// In en, this message translates to:
  /// **'Play Memo'**
  String get playMemo;

  /// No description provided for @deleteMemo.
  ///
  /// In en, this message translates to:
  /// **'Delete Memo'**
  String get deleteMemo;

  /// No description provided for @voiceDisclosure.
  ///
  /// In en, this message translates to:
  /// **'CardSaathi uses microphone to record a quick 10-second context memo. Audio is stored 100% offline on your device.'**
  String get voiceDisclosure;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, company, phone, GSTIN...'**
  String get searchHint;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get sortOldest;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get sortNameAZ;

  /// No description provided for @sortCompanyAZ.
  ///
  /// In en, this message translates to:
  /// **'Company (A-Z)'**
  String get sortCompanyAZ;

  /// No description provided for @noMatchingCards.
  ///
  /// In en, this message translates to:
  /// **'No matching cards found'**
  String get noMatchingCards;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @tapToCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get tapToCall;

  /// No description provided for @tapToWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get tapToWhatsApp;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get cardDetails;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
