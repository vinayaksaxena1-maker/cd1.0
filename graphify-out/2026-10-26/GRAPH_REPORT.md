# Graph Report - CD1.0  (2026-10-26)

## Corpus Check
- 71 files · ~27,863 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 31 file(s) not represented in the graph (top: .xml 7, (none) 5, .plist 4)

## Summary
- 921 nodes · 1140 edges · 55 communities (41 shown, 14 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `41676849`
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
- package:flutter/material.dart
- AppDelegate
- app_localizations.dart
- repository_test.dart
- MainActivity.kt
- LaunchImage.imageset/README.md
- app_router.dart
- app_localizations_en.dart
- app_localizations_hi.dart
- scan_screen.dart
- storage_service.dart
- contact_card.dart
- AppLocalizations
- user_profile.dart
- cards_screen.dart
- hive_registrar.dart
- contact_repository.dart
- reminder_repository.dart
- card_parser_test.dart
- category_repository.dart
- user_profile_repository.dart
- card_parser_service.dart
- category.dart
- extracted_card_data.dart
- app_typography.dart
- review_scan_screen.dart
- voice_memo_service.dart
- voice_memo_widget.dart
- Category
- scan_test.dart
- package:flutter_test/flutter_test.dart
- review_scan_test.dart
- theme_test.dart
- build
- ocr_service.dart
- locale_controller.dart
- card_tile_widget.dart
- build
- main.dart
- camera_disclosure_dialog.dart
- main_shell.dart
- models_test.dart
- voice_memo_test.dart

## God Nodes (most connected - your core abstractions)
1. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
2. `ContactCard` - 8 edges
3. `AppLocalizations` - 7 edges
4. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
5. `Category` - 6 edges
6. `MeetingReminder` - 6 edges
7. `UserProfile` - 6 edges
8. `Components` - 6 edges
9. `AppDelegate` - 5 edges
10. `Flutter Engineering & Skill Routing Protocol` - 5 edges

## Surprising Connections (you probably didn't know these)
- `AppLocalizationsEn` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_en.dart → lib/l10n/app_localizations.dart
- `AppLocalizationsHi` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_hi.dart → lib/l10n/app_localizations.dart
- `CategoryAdapter` --references--> `Category`  [EXTRACTED]
  lib/data/models/category.g.dart → lib/data/models/category.dart
- `ContactCardAdapter` --references--> `ContactCard`  [EXTRACTED]
  lib/data/models/contact_card.g.dart → lib/data/models/contact_card.dart
- `MeetingReminderAdapter` --references--> `MeetingReminder`  [EXTRACTED]
  lib/data/models/meeting_reminder.g.dart → lib/data/models/meeting_reminder.dart

## Import Cycles
- None detected.

## Communities (55 total, 14 thin omitted)

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

### Community 7 - "package:flutter/material.dart"
Cohesion: 0.13
Nodes (13): build, CategoriesScreen, default20Categories, build, DigitalCardScreen, HomeScreen, ProfileScreen, _showDeleteAccountDialog (+5 more)

### Community 8 - "AppDelegate"
Cohesion: 0.11
Nodes (6): Flutter, AppDelegate, SceneDelegate, RunnerTests, UIKit, XCTest

### Community 9 - "app_localizations.dart"
Cohesion: 0.02
Nodes (78): address, agreeAndEnable, alignCardInFrame, allCategories, appTagline, appTitle, callDirectly, cameraDisclosure (+70 more)

### Community 10 - "repository_test.dart"
Cohesion: 0.15
Nodes (8): CategoryRepository, UserProfileRepository, categoryRepo, contactRepo, main, profileRepo, reminderRepo, tempDir

### Community 17 - "app_router.dart"
Cohesion: 0.13
Nodes (3): AppRouter, _rootNavigatorKey, router

### Community 18 - "app_localizations_en.dart"
Cohesion: 0.03
Nodes (70): address, agreeAndEnable, alignCardInFrame, allCategories, appTagline, appTitle, callDirectly, cameraDisclosure (+62 more)

### Community 19 - "app_localizations_hi.dart"
Cohesion: 0.03
Nodes (70): address, agreeAndEnable, alignCardInFrame, allCategories, appTagline, appTitle, callDirectly, cameraDisclosure (+62 more)

### Community 20 - "scan_screen.dart"
Cohesion: 0.06
Nodes (23): _availableCameras, _backImagePath, build, _cameraController, _captureCard, _checkPermissionsAndInitCamera, createState, didChangeAppLifecycleState (+15 more)

### Community 21 - "storage_service.dart"
Cohesion: 0.12
Nodes (9): categoryRepo, contactRepo, initAll, _initialized, instance, isInitialized, reminderRepo, StorageService (+1 more)

### Community 22 - "contact_card.dart"
Cohesion: 0.05
Nodes (41): hashCode, operator, read, typeId, write, hashCode, operator, read (+33 more)

### Community 23 - "AppLocalizations"
Cohesion: 0.33
Nodes (5): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, AppLocalizationsHi, of

### Community 25 - "user_profile.dart"
Cohesion: 0.13
Nodes (18): hashCode, operator, read, typeId, write, address, company, copyWith (+10 more)

### Community 26 - "cards_screen.dart"
Cohesion: 0.08
Nodes (19): _allCards, _applyFiltersAndSort, _buildCategoryPills, CardSortOption, _categories, _clearFilters, createState, dispose (+11 more)

### Community 27 - "hive_registrar.dart"
Cohesion: 0.15
Nodes (9): categoriesBox, clearAllUserData, contactCardsBox, HiveRegistrar, initHive, _initialized, registerAdapters, remindersBox (+1 more)

### Community 28 - "contact_repository.dart"
Cohesion: 0.15
Nodes (12): _box, clearAllCards, ContactRepository, deleteCard, findDuplicate, getAllCards, getCardById, getCardsByCategory (+4 more)

### Community 29 - "reminder_repository.dart"
Cohesion: 0.17
Nodes (10): _box, clearAllReminders, deleteReminder, getAllReminders, getRemindersForContact, getUpcomingReminders, init, ReminderRepository (+2 more)

### Community 30 - "card_parser_test.dart"
Cohesion: 0.15
Nodes (6): 07AAAPG1234F1Z8, Hospital, Kumar, main, Physician, Saxena

### Community 31 - "category_repository.dart"
Cohesion: 0.17
Nodes (9): addCustomCategory, _box, deleteCategory, getAllCategories, getCategoryById, init, seedDefaultCategories, updateCardCount (+1 more)

### Community 32 - "user_profile_repository.dart"
Cohesion: 0.18
Nodes (6): _box, clearProfile, getProfile, init, _profileKey, saveProfile

### Community 33 - "card_parser_service.dart"
Cohesion: 0.10
Nodes (18): CardParserService, _companyKeywords, _designations, _domainRegex, _emailRegex, _extractPhonesFromLine, _gstinRegex, _hasNameHonorific (+10 more)

### Community 34 - "category.dart"
Cohesion: 0.13
Nodes (15): hashCode, operator, read, typeId, write, cardCount, copyWith, defaultCategories (+7 more)

### Community 35 - "extracted_card_data.dart"
Cohesion: 0.11
Nodes (17): address, company, copyWith, email, ExtractedCardData, fromJson, gstin, jobTitle (+9 more)

### Community 36 - "app_typography.dart"
Cohesion: 0.11
Nodes (13): AppTheme, AppTypography, bodyLarge, bodyMedium, bodySmall, headlineLarge, headlineMedium, headlineSmall (+5 more)

### Community 37 - "review_scan_screen.dart"
Cohesion: 0.07
Nodes (27): _addressController, _availableCategories, _checkForDuplicates, _companyController, createState, _detectedDuplicate, dispose, _emailController (+19 more)

### Community 38 - "voice_memo_service.dart"
Cohesion: 0.06
Nodes (18): _countdownTimer, _currentFilePath, deleteMemo, dispose, _isPlaying, _isRecording, maxDurationSeconds, pause (+10 more)

### Community 39 - "voice_memo_widget.dart"
Cohesion: 0.05
Nodes (34): VoiceMemoService, CardsScreen, _CardsScreenState, ReviewScanScreen, _ReviewScanScreenState, _animController, build, CardGuideOverlay (+26 more)

### Community 40 - "Category"
Cohesion: 0.29
Nodes (8): CategoryAdapter, ContactCardAdapter, MeetingReminderAdapter, UserProfileAdapter, Category, ContactCard, MeetingReminder, UserProfile

### Community 43 - "review_scan_test.dart"
Cohesion: 0.15
Nodes (6): createTestApp, main, tempDir, createTestApp, main, tempDir

### Community 46 - "ocr_service.dart"
Cohesion: 0.18
Nodes (4): dispose, OcrService, processCardImage, _textRecognizer

### Community 47 - "locale_controller.dart"
Cohesion: 0.20
Nodes (5): isHindi, _locale, LocaleController, setLocale, toggleLocale

### Community 48 - "card_tile_widget.dart"
Cohesion: 0.20
Nodes (7): build, _buildInitialsAvatar, card, _getInitials, _makeCall, onTap, _openWhatsApp

### Community 49 - "build"
Cohesion: 0.25
Nodes (4): build, _buildMainContent, build, build

### Community 50 - "main.dart"
Cohesion: 0.29
Nodes (3): build, CardSaathiApp, main

### Community 51 - "camera_disclosure_dialog.dart"
Cohesion: 0.29
Nodes (5): build, CameraDisclosureDialog, onAgree, onUseGallery, show

### Community 52 - "main_shell.dart"
Cohesion: 0.33
Nodes (4): build, MainShell, navigationShell, _onDestinationSelected

## Knowledge Gaps
- **574 isolated node(s):** `XCTest`, `_locale`, `isHindi`, `setLocale`, `toggleLocale` (+569 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 721 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **14 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ContactCard` connect `Category` to `review_scan_screen.dart`, `card_tile_widget.dart`, `contact_card.dart`, `hive_registrar.dart`, `contact_repository.dart`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **What connects `XCTest`, `_locale`, `isHindi` to the rest of the system?**
  _574 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `VoiceMemoService` connect `voice_memo_widget.dart` to `review_scan_screen.dart`, `voice_memo_service.dart`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Why does `Category` connect `Category` to `category.dart`, `hive_registrar.dart`, `category_repository.dart`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Should `package:flutter/material.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.13105413105413105 - nodes in this community are weakly interconnected._