# Graph Report - CD1.0  (2026-10-27)

## Corpus Check
- 92 files · ~45,545 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 31 file(s) not represented in the graph (top: .xml 7, (none) 5, .plist 4)

## Summary
- 1493 nodes · 1928 edges · 68 communities (57 shown, 11 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `879e42e4`
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
- reminders_screen.dart
- category_repository.dart
- package:hive/hive.dart
- card_parser_service.dart
- card_edit_screen.dart
- category_drilldown_sheet.dart
- Category
- review_scan_screen.dart
- voice_memo_service.dart
- voice_memo_widget.dart
- meeting_reminder.dart
- card_detail_screen.dart
- package:flutter_test/flutter_test.dart
- review_scan_test.dart
- package:flutter/material.dart
- card_guide_overlay.dart
- extracted_card_data.dart
- locale_controller.dart
- card_tile_widget.dart
- contact_picker_test.dart
- add_edit_reminder_sheet.dart
- State
- card_edit_and_vcard_test.dart
- app_typography.dart
- category.dart
- categories_hub_test.dart
- StatelessWidget
- dart:io
- add_category_dialog.dart
- package:cardsaathi/core/theme/app_theme.dart
- notification_service.dart
- meeting_reminder_card.dart
- reminders_test.dart
- build
- card_meetings_section.dart
- card_parser_test.dart
- card_meetings_and_alarms_test.dart

## God Nodes (most connected - your core abstractions)
1. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
2. `Category` - 11 edges
3. `ContactCard` - 8 edges
4. `AppLocalizations` - 7 edges
5. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
6. `MeetingReminder` - 7 edges
7. `UserProfile` - 6 edges
8. `Components` - 6 edges
9. `MainActivity` - 5 edges
10. `AppDelegate` - 5 edges

## Surprising Connections (you probably didn't know these)
- `AppLocalizationsEn` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_en.dart → lib/l10n/app_localizations.dart
- `AppLocalizationsHi` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_hi.dart → lib/l10n/app_localizations.dart
- `UserProfileAdapter` --references--> `UserProfile`  [EXTRACTED]
  lib/data/models/user_profile.g.dart → lib/data/models/user_profile.dart
- `CategoryAdapter` --references--> `Category`  [EXTRACTED]
  lib/data/models/category.g.dart → lib/data/models/category.dart
- `ContactCardAdapter` --references--> `ContactCard`  [EXTRACTED]
  lib/data/models/contact_card.g.dart → lib/data/models/contact_card.dart

## Import Cycles
- None detected.

## Communities (68 total, 11 thin omitted)

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
Nodes (159): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+151 more)

### Community 10 - "repository_test.dart"
Cohesion: 0.15
Nodes (8): CategoryRepository, ReminderRepository, categoryRepo, contactRepo, main, profileRepo, reminderRepo, tempDir

### Community 17 - "categories_screen.dart"
Cohesion: 0.10
Nodes (17): _allCards, build, _buildBody, _buildHeaderStatBadge, _buildSkeletonGrid, _cardCounts, _categories, CategoriesScreen (+9 more)

### Community 18 - "app_localizations_en.dart"
Cohesion: 0.01
Nodes (151): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+143 more)

### Community 19 - "app_localizations_hi.dart"
Cohesion: 0.01
Nodes (151): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+143 more)

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
Cohesion: 0.14
Nodes (9): categoriesBox, clearAllUserData, contactCardsBox, HiveRegistrar, initHive, _initialized, registerAdapters, remindersBox (+1 more)

### Community 28 - "contact_repository.dart"
Cohesion: 0.14
Nodes (12): _box, clearAllCards, ContactRepository, deleteCard, findDuplicate, getAllCards, getCardById, getCardsByCategory (+4 more)

### Community 29 - "reminder_repository.dart"
Cohesion: 0.13
Nodes (14): _box, clearAllReminders, deleteReminder, getAllReminders, getCompletedReminders, getOverdueReminders, getReminderById, getRemindersForContact (+6 more)

### Community 30 - "reminders_screen.dart"
Cohesion: 0.09
Nodes (18): build, _buildEmptyState, _buildReminderList, _buildTabItem, _completedList, _confirmDelete, createState, dispose (+10 more)

### Community 31 - "category_repository.dart"
Cohesion: 0.15
Nodes (9): addCustomCategory, _box, deleteCategory, getAllCategories, getCategoryById, init, seedDefaultCategories, updateCardCount (+1 more)

### Community 32 - "package:hive/hive.dart"
Cohesion: 0.18
Nodes (7): _box, clearProfile, getProfile, init, _profileKey, saveProfile, UserProfileRepository

### Community 33 - "card_parser_service.dart"
Cohesion: 0.04
Nodes (25): AppRouter, _rootNavigatorKey, router, CardParserService, _companyKeywords, _designations, _domainRegex, _emailRegex (+17 more)

### Community 34 - "card_edit_screen.dart"
Cohesion: 0.06
Nodes (35): _addressController, _availableCategories, build, _buildPhotoThumbnailCard, _buildSectionCard, CardEditScreen, _CardEditScreenState, cardId (+27 more)

### Community 35 - "category_drilldown_sheet.dart"
Cohesion: 0.11
Nodes (14): build, cardCount, category, isHindi, onDelete, onTap, build, cards (+6 more)

### Community 36 - "Category"
Cohesion: 0.29
Nodes (8): CategoryAdapter, ContactCardAdapter, MeetingReminderAdapter, UserProfileAdapter, Category, ContactCard, MeetingReminder, UserProfile

### Community 37 - "review_scan_screen.dart"
Cohesion: 0.06
Nodes (27): _addressController, _availableCategories, _checkForDuplicates, _companyController, createState, _detectedDuplicate, dispose, _emailController (+19 more)

### Community 38 - "voice_memo_service.dart"
Cohesion: 0.07
Nodes (18): _countdownTimer, _currentFilePath, deleteMemo, dispose, _isPlaying, _isRecording, maxDurationSeconds, pause (+10 more)

### Community 39 - "voice_memo_widget.dart"
Cohesion: 0.09
Nodes (18): VoiceMemoService, build, createState, _deleteMemo, dispose, initialMemoPath, initState, _internalService (+10 more)

### Community 40 - "meeting_reminder.dart"
Cohesion: 0.13
Nodes (16): hashCode, operator, read, typeId, write, agenda, contactCardId, copyWith (+8 more)

### Community 41 - "card_detail_screen.dart"
Cohesion: 0.06
Nodes (30): _audioPlayer, build, _buildActionCircle, _buildCardImageViewer, _buildContactDetailsCard, _buildContactHeader, _buildCredentialsSection, _buildNotesAndTagsSection (+22 more)

### Community 42 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.13
Nodes (6): main, createTestApp, main, createTestApp, main, main

### Community 43 - "review_scan_test.dart"
Cohesion: 0.29
Nodes (3): createTestApp, main, tempDir

### Community 44 - "package:flutter/material.dart"
Cohesion: 0.11
Nodes (15): build, MainShell, navigationShell, _onDestinationSelected, getCategoryIcon, build, DigitalCardScreen, HomeScreen (+7 more)

### Community 45 - "card_guide_overlay.dart"
Cohesion: 0.18
Nodes (8): _animController, build, createState, dispose, initState, isFrontSide, _laserAnimation, statusText

### Community 46 - "extracted_card_data.dart"
Cohesion: 0.06
Nodes (28): _channel, channelName, ContactPickerService, email, fromMap, instance, name, phone (+20 more)

### Community 47 - "locale_controller.dart"
Cohesion: 0.20
Nodes (5): isHindi, _locale, LocaleController, setLocale, toggleLocale

### Community 48 - "card_tile_widget.dart"
Cohesion: 0.13
Nodes (9): build, main, build, _buildInitialsAvatar, card, _getInitials, _makeCall, onTap (+1 more)

### Community 49 - "contact_picker_test.dart"
Cohesion: 0.15
Nodes (8): createTestApp, main, tempDir, child, createTestApp, locale, main, tempDir

### Community 50 - "add_edit_reminder_sheet.dart"
Cohesion: 0.08
Nodes (20): _agendaController, _availableContacts, build, createState, dispose, _formKey, initialContactId, initState (+12 more)

### Community 51 - "State"
Cohesion: 0.20
Nodes (12): RemindersScreen, _RemindersScreenState, ReviewScanScreen, _ReviewScanScreenState, CardMeetingsSection, _CardMeetingsSectionState, AddEditReminderSheet, _AddEditReminderSheetState (+4 more)

### Community 52 - "card_edit_and_vcard_test.dart"
Cohesion: 0.11
Nodes (13): child, createTestApp, createTestAppWithNavigation, FakeAudioplayersPlatform, FakeGlobalAudioplayersPlatform, getCurrentPosition, getDuration, getEventStream (+5 more)

### Community 53 - "app_typography.dart"
Cohesion: 0.11
Nodes (13): AppTheme, AppTypography, bodyLarge, bodyMedium, bodySmall, headlineLarge, headlineMedium, headlineSmall (+5 more)

### Community 54 - "category.dart"
Cohesion: 0.13
Nodes (15): hashCode, operator, read, typeId, write, cardCount, copyWith, defaultCategories (+7 more)

### Community 55 - "categories_hub_test.dart"
Cohesion: 0.22
Nodes (5): child, createTestApp, locale, main, tempDir

### Community 56 - "StatelessWidget"
Cohesion: 0.22
Nodes (7): CardSaathiApp, CategoryCardTile, CategoryDrillDownSheet, CardTileWidget, MeetingReminderCard, build, MeetingReminderSkeleton

### Community 57 - "dart:io"
Cohesion: 0.22
Nodes (5): exportVCardFile, generateVCardString, shareAsText, shareVCard, VCardService

### Community 58 - "add_category_dialog.dart"
Cohesion: 0.13
Nodes (12): AddCategoryDialog, _AddCategoryDialogState, _availableIcons, build, createState, dispose, _formKey, _isSaving (+4 more)

### Community 60 - "notification_service.dart"
Cohesion: 0.08
Nodes (18): cancelMeetingNotification, init, _initialized, instance, isInitialized, meetingChannelDesc, meetingChannelId, meetingChannelName (+10 more)

### Community 62 - "meeting_reminder_card.dart"
Cohesion: 0.20
Nodes (7): build, _buildLinkedContact, _makeCall, onDelete, onEdit, onToggleCompleted, reminder

### Community 63 - "reminders_test.dart"
Cohesion: 0.17
Nodes (4): main, createTestApp, main, tempDir

### Community 65 - "card_meetings_section.dart"
Cohesion: 0.12
Nodes (13): build, card, cardId, _confirmDelete, createState, didUpdateWidget, initState, _isLoading (+5 more)

### Community 66 - "card_parser_test.dart"
Cohesion: 0.15
Nodes (6): 07AAAPG1234F1Z8, Hospital, Kumar, main, Physician, Saxena

### Community 68 - "card_meetings_and_alarms_test.dart"
Cohesion: 0.17
Nodes (6): createTestApp, main, tempDir, createTestApp, main, tempDir

## Knowledge Gaps
- **1047 isolated node(s):** `NotificationService`, `instance`, `_plugin`, `_initialized`, `isInitialized` (+1042 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1233 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **11 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ContactCard` connect `Category` to `card_edit_screen.dart`, `card_tile_widget.dart`, `contact_card.dart`, `hive_registrar.dart`, `contact_repository.dart`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **What connects `NotificationService`, `instance`, `_plugin` to the rest of the system?**
  _1047 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `Category` connect `Category` to `category_drilldown_sheet.dart`, `contact_picker_test.dart`, `card_edit_and_vcard_test.dart`, `category.dart`, `categories_hub_test.dart`, `hive_registrar.dart`, `category_repository.dart`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Why does `MeetingReminder` connect `Category` to `meeting_reminder.dart`, `hive_registrar.dart`, `reminder_repository.dart`, `meeting_reminder_card.dart`?**
  _High betweenness centrality (0.005) - this node is a cross-community bridge._
- **Should `AppDelegate` be split into smaller, more focused modules?**
  _Cohesion score 0.11052631578947368 - nodes in this community are weakly interconnected._