# Graph Report - CD1.0  (2026-10-27)

## Corpus Check
- 122 files · ~353,537 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 32 file(s) not represented in the graph (top: .xml 8, (none) 5, .plist 4)

## Summary
- 1954 nodes · 2570 edges · 88 communities (78 shown, 10 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `dfcee550`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- README.md
- कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना
- app_colors.dart
- Flutter Engineering & Skill Routing Protocol
- Workspace Agent Guidelines & Active Skills
- Google Artemis Testing Protocol
- design_system.md
- digital_card_screen.dart
- AppDelegate
- app_localizations.dart
- reminders_test.dart
- MainActivity.kt
- LaunchImage.imageset/README.md
- categories_screen.dart
- app_localizations_en.dart
- app_localizations_hi.dart
- scan_screen.dart
- storage_service.dart
- contact_card.dart
- AppLocalizations
- cloud_sync_service.dart
- user_profile.dart
- cards_screen.dart
- hive_registrar.dart
- meeting_reminder_card.dart
- reminder_repository.dart
- reminders_screen.dart
- digital_card_canvas.dart
- user_profile_edit_screen.dart
- card_parser_service.dart
- card_edit_screen.dart
- category_drilldown_sheet.dart
- firebase_service.dart
- review_scan_screen.dart
- voice_memo_service.dart
- voice_memo_widget.dart
- meeting_reminder.dart
- card_detail_screen.dart
- package:flutter_test/flutter_test.dart
- review_scan_test.dart
- profile_screen.dart
- auth_modal.dart
- extracted_card_data.dart
- locale_controller.dart
- ../../../data/local/storage_service.dart
- dart:io
- add_edit_reminder_sheet.dart
- ../../../data/models/contact_card.dart
- card_edit_and_vcard_test.dart
- app_typography.dart
- category.dart
- digital_card_template.dart
- package:flutter/material.dart
- data_export_service.dart
- camera_disclosure_dialog.dart
- ../../../l10n/app_localizations.dart
- notification_service.dart
- 🛑 2. App Feature Gaps & Honest Limitations (क्या-क्या बाकी या अधूरा है)
- categories_hub_test.dart
- Route /
- card_meetings_section.dart
- card_guide_overlay.dart
- _ScanScreenState
- card_meetings_and_alarms_test.dart
- contact_picker_service.dart
- _proceedToReview
- repository_test.dart
- digital_card_templates_test.dart
- card_parser_test.dart
- digital_card_action_buttons.dart
- ../../../core/theme/app_colors.dart
- ContactCard
- app_router.dart
- State
- nfc_write_modal.dart
- contact_repository.dart
- category_repository.dart
- splash_screen.dart
- ocr_service.dart
- battery_optimization_dialog.dart
- nfc_service.dart
- List
- cloud_storage_service.dart

## God Nodes (most connected - your core abstractions)
1. `ContactCard` - 15 edges
2. `Category` - 11 edges
3. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
4. `MeetingReminder` - 8 edges
5. `AppLocalizations` - 7 edges
6. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
7. `UserProfile` - 6 edges
8. `🎓 CardSaathi — Honest Stitch & App-Wide Gap Audit Report` - 6 edges
9. `🛑 2. App Feature Gaps & Honest Limitations (क्या-क्या बाकी या अधूरा है)` - 6 edges
10. `Components` - 6 edges

## Surprising Connections (you probably didn't know these)
- `UserProfileAdapter` --references--> `UserProfile`  [EXTRACTED]
  lib/data/models/user_profile.g.dart → lib/data/models/user_profile.dart
- `AppLocalizationsEn` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_en.dart → lib/l10n/app_localizations.dart
- `AppLocalizationsHi` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_hi.dart → lib/l10n/app_localizations.dart
- `CategoryAdapter` --references--> `Category`  [EXTRACTED]
  lib/data/models/category.g.dart → lib/data/models/category.dart
- `ContactCardAdapter` --references--> `ContactCard`  [EXTRACTED]
  lib/data/models/contact_card.g.dart → lib/data/models/contact_card.dart

## Import Cycles
- None detected.

## Communities (88 total, 10 thin omitted)

### Community 1 - "कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना"
Cohesion: 0.11
Nodes (17): 📝 10. रिलीज़ साइन-ऑफ एवं सत्यापन रिपोर्ट प्रोटोकॉल, 🛡️ 1. Google Play Developer Content Policy (2026) एवं अनुमतियाँ (Permissions), 📱 2. टेस्टिंग एवं डिवाइस कनेक्शन आर्किटेक्चर (Artemis via ADB), 🌟 3. 2026 के अनूठे फ़ीचर्स (Unique & Core Features), ☁️ 4. मल्टी-डिवाइस क्लाउड सिंक: Firebase प्रोटोकॉल, 🎨 5. Google Stitch डिप्लॉयमेंट व थीम कलर कैलिब्रेशन, 🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order), 🧪 7. माइलस्टोन-स्तरीय टेस्ट-गेट एवं रिग्रेशन प्रोटोकॉल (Quality Gates) (+9 more)

### Community 2 - "app_colors.dart"
Cohesion: 0.06
Nodes (33): AppColors, borderSubtle, canvasIvory, error, errorContainer, forestGreen, onError, onPrimary (+25 more)

### Community 3 - "Flutter Engineering & Skill Routing Protocol"
Cohesion: 0.33
Nodes (5): 1. Architecture & Core Implementation, 2. Mobile UI/UX & State Resilience, 3. Testing & Device Automation, 4. Debugging & Zero-Defect Gates, Flutter Engineering & Skill Routing Protocol

### Community 4 - "Workspace Agent Guidelines & Active Skills"
Cohesion: 0.40
Nodes (4): Active Skills Matrix, Critical Boundaries, Google Stitch Design System Binding, Workspace Agent Guidelines & Active Skills

### Community 5 - "Google Artemis Testing Protocol"
Cohesion: 0.50
Nodes (3): Execution Rules, Google Artemis Testing Protocol, Target Device: BlueStacks 5

### Community 6 - "design_system.md"
Cohesion: 0.15
Nodes (12): Bottom Navigation, Brand & Style, Buttons, Cards & Contact Rows, Chips & Badges, Colors, Components, Elevation & Depth (+4 more)

### Community 7 - "digital_card_screen.dart"
Cohesion: 0.09
Nodes (18): _activeTemplate, _allCards, _availableTemplates, build, _buildCardSelectorDropdown, _buildCategoryRecommendationPills, _buildFilterChip, createState (+10 more)

### Community 8 - "AppDelegate"
Cohesion: 0.11
Nodes (6): Flutter, AppDelegate, SceneDelegate, RunnerTests, UIKit, XCTest

### Community 9 - "app_localizations.dart"
Cohesion: 0.01
Nodes (202): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+194 more)

### Community 10 - "reminders_test.dart"
Cohesion: 0.17
Nodes (4): createTestApp, main, tempDir, main

### Community 17 - "categories_screen.dart"
Cohesion: 0.10
Nodes (17): _allCards, build, _buildBody, _buildHeaderStatBadge, _buildSkeletonGrid, _cardCounts, _categories, CategoriesScreen (+9 more)

### Community 18 - "app_localizations_en.dart"
Cohesion: 0.01
Nodes (194): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+186 more)

### Community 19 - "app_localizations_hi.dart"
Cohesion: 0.01
Nodes (194): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+186 more)

### Community 20 - "scan_screen.dart"
Cohesion: 0.07
Nodes (20): _availableCameras, _backImagePath, build, _cameraController, _captureCard, _checkPermissionsAndInitCamera, createState, didChangeAppLifecycleState (+12 more)

### Community 21 - "storage_service.dart"
Cohesion: 0.12
Nodes (9): categoryRepo, contactRepo, initAll, _initialized, instance, isInitialized, reminderRepo, StorageService (+1 more)

### Community 22 - "contact_card.dart"
Cohesion: 0.09
Nodes (25): hashCode, operator, read, typeId, write, address, categoryId, company (+17 more)

### Community 23 - "AppLocalizations"
Cohesion: 0.33
Nodes (5): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, AppLocalizationsHi, of

### Community 24 - "cloud_sync_service.dart"
Cohesion: 0.14
Nodes (10): CloudSyncService, instance, lastSyncedAt, _parseDateTime, status, syncAll, _syncContacts, syncError (+2 more)

### Community 25 - "user_profile.dart"
Cohesion: 0.12
Nodes (19): hashCode, operator, read, typeId, UserProfileAdapter, write, address, company (+11 more)

### Community 26 - "cards_screen.dart"
Cohesion: 0.06
Nodes (26): _allCards, _applyFiltersAndSort, build, _buildCategoryPills, _buildMainContent, CardSortOption, CardsScreen, _CardsScreenState (+18 more)

### Community 27 - "hive_registrar.dart"
Cohesion: 0.14
Nodes (9): categoriesBox, clearAllUserData, contactCardsBox, HiveRegistrar, initHive, _initialized, registerAdapters, remindersBox (+1 more)

### Community 28 - "meeting_reminder_card.dart"
Cohesion: 0.12
Nodes (11): build, _buildLinkedContact, _makeCall, MeetingReminderCard, onDelete, onEdit, onToggleCompleted, reminder (+3 more)

### Community 29 - "reminder_repository.dart"
Cohesion: 0.13
Nodes (14): _box, clearAllReminders, deleteReminder, getAllReminders, getCompletedReminders, getOverdueReminders, getReminderById, getRemindersForContact (+6 more)

### Community 30 - "reminders_screen.dart"
Cohesion: 0.09
Nodes (18): build, _buildEmptyState, _buildReminderList, _buildTabItem, _completedList, _confirmDelete, createState, dispose (+10 more)

### Community 31 - "digital_card_canvas.dart"
Cohesion: 0.18
Nodes (10): build, _buildContactFooter, _buildHeader, _buildInfoRow, _buildNameBlock, _buildStyleBackgroundAccents, card, isHindi (+2 more)

### Community 32 - "user_profile_edit_screen.dart"
Cohesion: 0.09
Nodes (19): _addressController, build, _buildAvatarSection, _companyController, createState, _designationController, dispose, _emailController (+11 more)

### Community 33 - "card_parser_service.dart"
Cohesion: 0.09
Nodes (19): CardParserService, _companyKeywords, _designations, _domainRegex, _emailRegex, _extractPhonesFromLine, _gstinRegex, _hasNameHonorific (+11 more)

### Community 34 - "card_edit_screen.dart"
Cohesion: 0.06
Nodes (35): _addressController, _availableCategories, build, _buildPhotoThumbnailCard, _buildSectionCard, CardEditScreen, _CardEditScreenState, cardId (+27 more)

### Community 35 - "category_drilldown_sheet.dart"
Cohesion: 0.11
Nodes (16): build, cardCount, category, CategoryCardTile, isHindi, onDelete, onTap, build (+8 more)

### Community 36 - "firebase_service.dart"
Cohesion: 0.11
Nodes (13): authStateChanges, continueAsGuest, currentUser, FirebaseService, init, _initialized, instance, _isAvailable (+5 more)

### Community 37 - "review_scan_screen.dart"
Cohesion: 0.07
Nodes (27): _addressController, _availableCategories, _checkForDuplicates, _companyController, createState, _detectedDuplicate, dispose, _emailController (+19 more)

### Community 38 - "voice_memo_service.dart"
Cohesion: 0.08
Nodes (18): _countdownTimer, _currentFilePath, deleteMemo, dispose, _isPlaying, _isRecording, maxDurationSeconds, pause (+10 more)

### Community 39 - "voice_memo_widget.dart"
Cohesion: 0.10
Nodes (18): VoiceMemoService, build, createState, _deleteMemo, dispose, initialMemoPath, initState, _internalService (+10 more)

### Community 40 - "meeting_reminder.dart"
Cohesion: 0.13
Nodes (16): hashCode, operator, read, typeId, write, agenda, contactCardId, copyWith (+8 more)

### Community 41 - "card_detail_screen.dart"
Cohesion: 0.07
Nodes (28): _audioPlayer, build, _buildActionCircle, _buildCardImageViewer, _buildContactDetailsCard, _buildContactHeader, _buildCredentialsSection, _buildNotesAndTagsSection (+20 more)

### Community 42 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.10
Nodes (8): createTestApp, main, main, createTestApp, main, createTestApp, main, main

### Community 43 - "review_scan_test.dart"
Cohesion: 0.29
Nodes (3): createTestApp, main, tempDir

### Community 44 - "profile_screen.dart"
Cohesion: 0.15
Nodes (3): _buildAccountCard, _buildBusinessProfileCard, createState

### Community 45 - "auth_modal.dart"
Cohesion: 0.12
Nodes (16): AuthModal, _AuthModalState, build, createState, dispose, _errorMessage, _handleGuestLogin, _handleSendOtp (+8 more)

### Community 46 - "extracted_card_data.dart"
Cohesion: 0.11
Nodes (17): address, company, copyWith, email, ExtractedCardData, fromJson, gstin, jobTitle (+9 more)

### Community 47 - "locale_controller.dart"
Cohesion: 0.20
Nodes (5): isHindi, _locale, LocaleController, setLocale, toggleLocale

### Community 48 - "../../../data/local/storage_service.dart"
Cohesion: 0.14
Nodes (10): build, _buildInitialsAvatar, card, CardTileWidget, _getInitials, _makeCall, onTap, _openWhatsApp (+2 more)

### Community 49 - "dart:io"
Cohesion: 0.11
Nodes (11): captureCardToImage, CardExportService, shareCardOnWhatsApp, createTestApp, main, tempDir, child, createTestApp (+3 more)

### Community 50 - "add_edit_reminder_sheet.dart"
Cohesion: 0.05
Nodes (35): allTemplates, getTemplateById, getTemplatesForCategory, StitchTemplateRegistry, AddCategoryDialog, _AddCategoryDialogState, _availableIcons, build (+27 more)

### Community 51 - "../../../data/models/contact_card.dart"
Cohesion: 0.25
Nodes (5): exportVCardFile, generateVCardString, shareAsText, shareVCard, VCardService

### Community 52 - "card_edit_and_vcard_test.dart"
Cohesion: 0.11
Nodes (13): child, createTestApp, createTestAppWithNavigation, FakeAudioplayersPlatform, FakeGlobalAudioplayersPlatform, getCurrentPosition, getDuration, getEventStream (+5 more)

### Community 53 - "app_typography.dart"
Cohesion: 0.07
Nodes (20): BatteryOptimizationService, _channel, getManufacturer, getOemInstructions, instance, isExempted, openBatterySettings, AppTheme (+12 more)

### Community 54 - "category.dart"
Cohesion: 0.13
Nodes (15): hashCode, operator, read, typeId, write, cardCount, copyWith, defaultCategories (+7 more)

### Community 55 - "digital_card_template.dart"
Cohesion: 0.12
Nodes (14): accentColor, backgroundColor, cardBorderColor, hasDarkBackground, id, matchesCategory, nameEn, nameHi (+6 more)

### Community 56 - "package:flutter/material.dart"
Cohesion: 0.10
Nodes (15): getCategoryIcon, build, DeveloperInfoFooter, build, _buildPolicySection, GooglePlayPolicyModal, _launchPolicyUrl, show (+7 more)

### Community 57 - "data_export_service.dart"
Cohesion: 0.22
Nodes (5): DataExportService, exportAllContactsAsVCard, exportAllDataAsJson, generateVCardString, instance

### Community 58 - "camera_disclosure_dialog.dart"
Cohesion: 0.29
Nodes (5): build, CameraDisclosureDialog, onAgree, onUseGallery, show

### Community 59 - "../../../l10n/app_localizations.dart"
Cohesion: 0.12
Nodes (8): build, CardSaathiApp, main, build, navigationShell, _onDestinationSelected, build, HomeScreen

### Community 60 - "notification_service.dart"
Cohesion: 0.05
Nodes (30): AppConstants, appName, appVersion, buildNumber, developerEmail, developerName, developerTagline, developerWebsite (+22 more)

### Community 62 - "🛑 2. App Feature Gaps & Honest Limitations (क्या-क्या बाकी या अधूरा है)"
Cohesion: 0.14
Nodes (13): 📐 1. Stitch Screens & Templates: ज़मीनी हकीकत ऑडिट, 🛑 2. App Feature Gaps & Honest Limitations (क्या-क्या बाकी या अधूरा है), 📊 3. कंपाइलर व ज़ीरो-डिफ़ेक्ट सत्यापन परिणाम, 🏁 4. अंतिम निष्कर्ष (Final Verdict), 🔹 (A) 20 डिजिटल कार्ड टेम्प्लेट्स की हकीकत:, 🔹 (B) Stitch की 17 मुख्य ऐप स्क्रीन्स का मिलान:, 🎓 CardSaathi — Honest Stitch & App-Wide Gap Audit Report, 🔍 Executive Summary (+5 more)

### Community 63 - "categories_hub_test.dart"
Cohesion: 0.12
Nodes (7): child, createTestApp, locale, main, tempDir, main, main

### Community 64 - "Route /"
Cohesion: 0.50
Nodes (3): build, _goToHome, main

### Community 65 - "card_meetings_section.dart"
Cohesion: 0.12
Nodes (13): build, card, cardId, _confirmDelete, createState, didUpdateWidget, initState, _isLoading (+5 more)

### Community 66 - "card_guide_overlay.dart"
Cohesion: 0.17
Nodes (10): _animController, build, CardGuideOverlay, _CardGuideOverlayState, createState, dispose, initState, isFrontSide (+2 more)

### Community 68 - "card_meetings_and_alarms_test.dart"
Cohesion: 0.17
Nodes (6): createTestApp, main, tempDir, createTestApp, main, tempDir

### Community 69 - "contact_picker_service.dart"
Cohesion: 0.13
Nodes (11): _channel, channelName, ContactPickerService, email, fromMap, instance, name, phone (+3 more)

### Community 71 - "repository_test.dart"
Cohesion: 0.08
Nodes (18): ContactRepository, ReminderRepository, _box, clearProfile, getProfile, init, _profileKey, saveProfile (+10 more)

### Community 72 - "digital_card_templates_test.dart"
Cohesion: 0.25
Nodes (3): createTestApp, main, tempDir

### Community 73 - "card_parser_test.dart"
Cohesion: 0.15
Nodes (6): 07AAAPG1234F1Z8, Hospital, Kumar, main, Physician, Saxena

### Community 75 - "digital_card_action_buttons.dart"
Cohesion: 0.12
Nodes (8): build, DigitalCardActionButtons, repaintKey, selectedCard, build, card, show, VCardQrModal

### Community 76 - "../../../core/theme/app_colors.dart"
Cohesion: 0.11
Nodes (14): SyncStatus, MainShell, build, CardTileSkeleton, DigitalCardCanvas, TemplateSelectorCarousel, build, CloudSyncCard (+6 more)

### Community 77 - "ContactCard"
Cohesion: 0.31
Nodes (7): CategoryAdapter, ContactCardAdapter, MeetingReminderAdapter, Category, ContactCard, MeetingReminder, UserProfile

### Community 79 - "app_router.dart"
Cohesion: 0.11
Nodes (3): AppRouter, _rootNavigatorKey, router

### Community 80 - "State"
Cohesion: 0.18
Nodes (14): CardDetailScreen, _CardDetailScreenState, ProfileScreen, _ProfileScreenState, RemindersScreen, _RemindersScreenState, ReviewScanScreen, _ReviewScanScreenState (+6 more)

### Community 81 - "nfc_write_modal.dart"
Cohesion: 0.12
Nodes (14): build, _buildStatusIcon, createState, dispose, _errorMessage, initState, NfcWriteState, onFallbackToQr (+6 more)

### Community 82 - "contact_repository.dart"
Cohesion: 0.14
Nodes (11): _box, clearAllCards, deleteCard, findDuplicate, getAllCards, getCardById, getCardsByCategory, init (+3 more)

### Community 83 - "category_repository.dart"
Cohesion: 0.14
Nodes (10): addCustomCategory, _box, CategoryRepository, deleteCategory, getAllCategories, getCategoryById, init, seedDefaultCategories (+2 more)

### Community 84 - "splash_screen.dart"
Cohesion: 0.15
Nodes (11): build, _buildLoaderComponent, _controller, createState, dispose, _fadeAnimation, initState, _navigated (+3 more)

### Community 85 - "ocr_service.dart"
Cohesion: 0.18
Nodes (6): _combineRecognizedTexts, _devanagariRecognizer, dispose, _latinRecognizer, OcrService, processCardImage

### Community 86 - "battery_optimization_dialog.dart"
Cohesion: 0.18
Nodes (10): BatteryOptimizationDialog, _BatteryOptimizationDialogState, build, createState, initState, _isExempted, _loading, _loadState (+2 more)

### Community 87 - "nfc_service.dart"
Cohesion: 0.17
Nodes (5): checkAvailability, instance, NfcService, stopSession, writeVCardToTag

### Community 88 - "List"
Cohesion: 0.20
Nodes (6): DigitalCardTemplate, activeTemplate, availableTemplates, build, isHindi, onSelected

### Community 89 - "cloud_storage_service.dart"
Cohesion: 0.22
Nodes (4): CloudStorageService, instance, uploadCardPhoto, uploadVoiceMemo

## Knowledge Gaps
- **1376 isolated node(s):** `XCTest`, `AppConstants`, `appName`, `appVersion`, `buildNumber` (+1371 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1616 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ContactCard` connect `ContactCard` to `card_meetings_section.dart`, `card_edit_screen.dart`, `review_scan_screen.dart`, `digital_card_screen.dart`, `card_detail_screen.dart`, `digital_card_action_buttons.dart`, `../../../data/local/storage_service.dart`, `contact_repository.dart`, `contact_card.dart`, `hive_registrar.dart`, `digital_card_canvas.dart`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `XCTest`, `AppConstants`, `appName` to the rest of the system?**
  _1376 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `Category` connect `ContactCard` to `category_drilldown_sheet.dart`, `dart:io`, `category_repository.dart`, `card_edit_and_vcard_test.dart`, `category.dart`, `hive_registrar.dart`, `categories_hub_test.dart`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Why does `_proceedToReview` connect `_proceedToReview` to `scan_screen.dart`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Should `digital_card_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.08695652173913043 - nodes in this community are weakly interconnected._