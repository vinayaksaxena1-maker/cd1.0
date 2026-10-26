# Graph Report - CD1.0  (2026-10-26)

## Corpus Check
- 83 files · ~39,422 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 31 file(s) not represented in the graph (top: .xml 7, (none) 5, .plist 4)

## Summary
- 1283 nodes · 1630 edges · 62 communities (51 shown, 11 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f1d7413b`
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
- camera_disclosure_dialog.dart
- AppDelegate
- app_localizations.dart
- repository_test.dart
- MainActivity.kt
- LaunchImage.imageset/README.md
- categories_screen.dart
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
- card_edit_screen.dart
- category_drilldown_sheet.dart
- main.dart
- review_scan_screen.dart
- voice_memo_service.dart
- voice_memo_widget.dart
- Category
- card_detail_screen.dart
- package:flutter_test/flutter_test.dart
- review_scan_test.dart
- meeting_reminder.dart
- contact_picker_service.dart
- extracted_card_data.dart
- ../../../core/theme/app_colors.dart
- card_tile_widget.dart
- contact_picker_test.dart
- add_category_dialog.dart
- State
- card_edit_and_vcard_test.dart
- app_typography.dart
- category_card_tile.dart
- categories_hub_test.dart
- dart:io
- ../../../data/models/contact_card.dart
- package:flutter/material.dart
- build
- package:cardsaathi/core/theme/app_theme.dart

## God Nodes (most connected - your core abstractions)
1. `Category` - 11 edges
2. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
3. `ContactCard` - 10 edges
4. `AppLocalizations` - 7 edges
5. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
6. `MeetingReminder` - 6 edges
7. `UserProfile` - 6 edges
8. `Components` - 6 edges
9. `MainActivity` - 5 edges
10. `AppDelegate` - 5 edges

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

## Communities (62 total, 11 thin omitted)

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

### Community 7 - "camera_disclosure_dialog.dart"
Cohesion: 0.29
Nodes (5): build, CameraDisclosureDialog, onAgree, onUseGallery, show

### Community 8 - "AppDelegate"
Cohesion: 0.11
Nodes (6): Flutter, AppDelegate, SceneDelegate, RunnerTests, UIKit, XCTest

### Community 9 - "app_localizations.dart"
Cohesion: 0.01
Nodes (133): addCategory, address, addTag, agreeAndEnable, alignCardInFrame, allCategories, appTagline, appTitle (+125 more)

### Community 10 - "repository_test.dart"
Cohesion: 0.13
Nodes (7): main, categoryRepo, contactRepo, main, profileRepo, reminderRepo, tempDir

### Community 17 - "categories_screen.dart"
Cohesion: 0.10
Nodes (15): _allCards, build, _buildBody, _buildHeaderStatBadge, _buildSkeletonGrid, _cardCounts, _categories, createState (+7 more)

### Community 18 - "app_localizations_en.dart"
Cohesion: 0.02
Nodes (125): addCategory, address, addTag, agreeAndEnable, alignCardInFrame, allCategories, appTagline, appTitle (+117 more)

### Community 19 - "app_localizations_hi.dart"
Cohesion: 0.02
Nodes (125): addCategory, address, addTag, agreeAndEnable, alignCardInFrame, allCategories, appTagline, appTitle (+117 more)

### Community 20 - "scan_screen.dart"
Cohesion: 0.06
Nodes (23): _availableCameras, _backImagePath, build, _cameraController, _captureCard, _checkPermissionsAndInitCamera, createState, didChangeAppLifecycleState (+15 more)

### Community 21 - "storage_service.dart"
Cohesion: 0.12
Nodes (9): categoryRepo, contactRepo, initAll, _initialized, instance, isInitialized, reminderRepo, StorageService (+1 more)

### Community 22 - "contact_card.dart"
Cohesion: 0.09
Nodes (25): hashCode, operator, read, typeId, write, address, categoryId, company (+17 more)

### Community 23 - "AppLocalizations"
Cohesion: 0.33
Nodes (5): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, AppLocalizationsHi, of

### Community 25 - "user_profile.dart"
Cohesion: 0.13
Nodes (18): hashCode, operator, read, typeId, write, address, company, copyWith (+10 more)

### Community 26 - "cards_screen.dart"
Cohesion: 0.06
Nodes (27): _allCards, _applyFiltersAndSort, build, _buildCategoryPills, _buildMainContent, CardSortOption, CardsScreen, _CardsScreenState (+19 more)

### Community 27 - "hive_registrar.dart"
Cohesion: 0.15
Nodes (9): categoriesBox, clearAllUserData, contactCardsBox, HiveRegistrar, initHive, _initialized, registerAdapters, remindersBox (+1 more)

### Community 28 - "contact_repository.dart"
Cohesion: 0.14
Nodes (12): _box, clearAllCards, ContactRepository, deleteCard, findDuplicate, getAllCards, getCardById, getCardsByCategory (+4 more)

### Community 29 - "reminder_repository.dart"
Cohesion: 0.15
Nodes (10): _box, clearAllReminders, deleteReminder, getAllReminders, getRemindersForContact, getUpcomingReminders, init, ReminderRepository (+2 more)

### Community 30 - "card_parser_test.dart"
Cohesion: 0.15
Nodes (6): 07AAAPG1234F1Z8, Hospital, Kumar, main, Physician, Saxena

### Community 31 - "category_repository.dart"
Cohesion: 0.15
Nodes (10): addCustomCategory, _box, CategoryRepository, deleteCategory, getAllCategories, getCategoryById, init, seedDefaultCategories (+2 more)

### Community 32 - "user_profile_repository.dart"
Cohesion: 0.18
Nodes (7): _box, clearProfile, getProfile, init, _profileKey, saveProfile, UserProfileRepository

### Community 33 - "card_parser_service.dart"
Cohesion: 0.05
Nodes (21): AppRouter, _rootNavigatorKey, router, CardParserService, _companyKeywords, _designations, _domainRegex, _emailRegex (+13 more)

### Community 34 - "card_edit_screen.dart"
Cohesion: 0.06
Nodes (33): _addressController, _availableCategories, build, _buildPhotoThumbnailCard, _buildSectionCard, cardId, _companyController, createState (+25 more)

### Community 35 - "category_drilldown_sheet.dart"
Cohesion: 0.20
Nodes (8): build, cards, category, _getInitials, _getPrimaryPhone, isHindi, _makeCall, _openWhatsApp

### Community 36 - "main.dart"
Cohesion: 0.29
Nodes (3): build, CardSaathiApp, main

### Community 37 - "review_scan_screen.dart"
Cohesion: 0.07
Nodes (29): _addressController, _availableCategories, _checkForDuplicates, _companyController, createState, _detectedDuplicate, dispose, _emailController (+21 more)

### Community 38 - "voice_memo_service.dart"
Cohesion: 0.05
Nodes (23): isHindi, _locale, LocaleController, setLocale, toggleLocale, _countdownTimer, _currentFilePath, deleteMemo (+15 more)

### Community 39 - "voice_memo_widget.dart"
Cohesion: 0.06
Nodes (30): VoiceMemoService, _animController, build, CardGuideOverlay, _CardGuideOverlayState, createState, dispose, initState (+22 more)

### Community 40 - "Category"
Cohesion: 0.29
Nodes (8): CategoryAdapter, ContactCardAdapter, MeetingReminderAdapter, UserProfileAdapter, Category, ContactCard, MeetingReminder, UserProfile

### Community 41 - "card_detail_screen.dart"
Cohesion: 0.06
Nodes (30): _audioPlayer, build, _buildActionCircle, _buildCardImageViewer, _buildContactDetailsCard, _buildContactHeader, _buildCredentialsSection, _buildNotesAndTagsSection (+22 more)

### Community 42 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.13
Nodes (6): main, createTestApp, main, createTestApp, main, main

### Community 43 - "review_scan_test.dart"
Cohesion: 0.12
Nodes (7): AppTheme, createTestApp, main, tempDir, createTestApp, main, tempDir

### Community 44 - "meeting_reminder.dart"
Cohesion: 0.07
Nodes (31): hashCode, operator, read, typeId, write, hashCode, operator, read (+23 more)

### Community 45 - "contact_picker_service.dart"
Cohesion: 0.13
Nodes (11): _channel, channelName, ContactPickerService, email, fromMap, instance, name, phone (+3 more)

### Community 46 - "extracted_card_data.dart"
Cohesion: 0.11
Nodes (17): address, company, copyWith, email, ExtractedCardData, fromJson, gstin, jobTitle (+9 more)

### Community 47 - "../../../core/theme/app_colors.dart"
Cohesion: 0.13
Nodes (12): CategoryCardTile, CategoryDrillDownSheet, build, DigitalCardScreen, HomeScreen, ProfileScreen, _showDeleteAccountDialog, build (+4 more)

### Community 48 - "card_tile_widget.dart"
Cohesion: 0.22
Nodes (7): build, _buildInitialsAvatar, card, _getInitials, _makeCall, onTap, _openWhatsApp

### Community 49 - "contact_picker_test.dart"
Cohesion: 0.15
Nodes (8): createTestApp, main, tempDir, child, createTestApp, locale, main, tempDir

### Community 50 - "add_category_dialog.dart"
Cohesion: 0.14
Nodes (10): _availableIcons, build, createState, dispose, _formKey, _isSaving, _nameEnController, _nameHiController (+2 more)

### Community 51 - "State"
Cohesion: 0.32
Nodes (6): CardEditScreen, _CardEditScreenState, CategoriesScreen, _CategoriesScreenState, AddCategoryDialog, _AddCategoryDialogState

### Community 52 - "card_edit_and_vcard_test.dart"
Cohesion: 0.11
Nodes (13): child, createTestApp, createTestAppWithNavigation, FakeAudioplayersPlatform, FakeGlobalAudioplayersPlatform, getCurrentPosition, getDuration, getEventStream (+5 more)

### Community 53 - "app_typography.dart"
Cohesion: 0.14
Nodes (12): AppTypography, bodyLarge, bodyMedium, bodySmall, headlineLarge, headlineMedium, headlineSmall, labelLarge (+4 more)

### Community 54 - "category_card_tile.dart"
Cohesion: 0.22
Nodes (6): build, cardCount, category, isHindi, onDelete, onTap

### Community 55 - "categories_hub_test.dart"
Cohesion: 0.22
Nodes (5): child, createTestApp, locale, main, tempDir

### Community 56 - "dart:io"
Cohesion: 0.20
Nodes (4): dispose, OcrService, processCardImage, _textRecognizer

### Community 57 - "../../../data/models/contact_card.dart"
Cohesion: 0.22
Nodes (5): exportVCardFile, generateVCardString, shareAsText, shareVCard, VCardService

### Community 58 - "package:flutter/material.dart"
Cohesion: 0.22
Nodes (5): build, MainShell, navigationShell, _onDestinationSelected, getCategoryIcon

## Knowledge Gaps
- **879 isolated node(s):** `XCTest`, `_locale`, `isHindi`, `setLocale`, `toggleLocale` (+874 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1044 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **11 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Category` connect `Category` to `category_drilldown_sheet.dart`, `meeting_reminder.dart`, `contact_picker_test.dart`, `card_edit_and_vcard_test.dart`, `category_card_tile.dart`, `categories_hub_test.dart`, `hive_registrar.dart`, `category_repository.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **What connects `XCTest`, `_locale`, `isHindi` to the rest of the system?**
  _879 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `ContactCard` connect `Category` to `card_edit_screen.dart`, `review_scan_screen.dart`, `card_detail_screen.dart`, `card_tile_widget.dart`, `contact_card.dart`, `hive_registrar.dart`, `contact_repository.dart`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Why does `VoiceMemoService` connect `voice_memo_widget.dart` to `review_scan_screen.dart`, `voice_memo_service.dart`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Should `AppDelegate` be split into smaller, more focused modules?**
  _Cohesion score 0.11052631578947368 - nodes in this community are weakly interconnected._