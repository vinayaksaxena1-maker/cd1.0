# Graph Report - CD1.0  (2026-10-27)

## Corpus Check
- 104 files · ~52,783 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 31 file(s) not represented in the graph (top: .xml 7, (none) 5, .plist 4)

## Summary
- 1706 nodes · 2216 edges · 73 communities (63 shown, 10 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `eb1ed340`
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
- cloud_sync_service.dart
- user_profile.dart
- cards_screen.dart
- hive_registrar.dart
- contact_repository.dart
- reminder_repository.dart
- reminders_screen.dart
- category_repository.dart
- user_profile_repository.dart
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
- package:hive/hive.dart
- ../../../core/theme/app_typography.dart
- auth_modal.dart
- extracted_card_data.dart
- locale_controller.dart
- card_tile_widget.dart
- contact_picker_test.dart
- add_edit_reminder_sheet.dart
- State
- card_edit_and_vcard_test.dart
- app_typography.dart
- category.dart
- package:cardsaathi/core/theme/app_theme.dart
- ../../../core/theme/app_colors.dart
- package:flutter/material.dart
- add_category_dialog.dart
- notification_service.dart
- meeting_reminder_card.dart
- reminders_test.dart
- build
- card_meetings_section.dart
- card_parser_test.dart
- card_meetings_and_alarms_test.dart
- contact_picker_service.dart
- Category
- categories_hub_test.dart
- digital_card_templates_test.dart
- dart:io
- stitch_template_registry.dart

## God Nodes (most connected - your core abstractions)
1. `ContactCard` - 14 edges
2. `Category` - 11 edges
3. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
4. `MeetingReminder` - 8 edges
5. `AppLocalizations` - 7 edges
6. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
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

## Communities (73 total, 10 thin omitted)

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
Cohesion: 0.06
Nodes (31): DigitalCardTemplate, _activeTemplate, _allCards, _availableTemplates, build, _buildActionButtons, _buildCardSelectorDropdown, _buildCategoryRecommendationPills (+23 more)

### Community 8 - "AppDelegate"
Cohesion: 0.11
Nodes (6): Flutter, AppDelegate, SceneDelegate, RunnerTests, UIKit, XCTest

### Community 9 - "app_localizations.dart"
Cohesion: 0.01
Nodes (182): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+174 more)

### Community 10 - "repository_test.dart"
Cohesion: 0.10
Nodes (9): ContactRepository, main, main, categoryRepo, contactRepo, main, profileRepo, reminderRepo (+1 more)

### Community 17 - "categories_screen.dart"
Cohesion: 0.10
Nodes (17): _allCards, build, _buildBody, _buildHeaderStatBadge, _buildSkeletonGrid, _cardCounts, _categories, CategoriesScreen (+9 more)

### Community 18 - "app_localizations_en.dart"
Cohesion: 0.01
Nodes (174): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+166 more)

### Community 19 - "app_localizations_hi.dart"
Cohesion: 0.01
Nodes (174): addCategory, addMeeting, address, addTag, agenda, agreeAndEnable, alignCardInFrame, allCategories (+166 more)

### Community 20 - "scan_screen.dart"
Cohesion: 0.06
Nodes (23): _availableCameras, _backImagePath, build, _cameraController, _captureCard, _checkPermissionsAndInitCamera, createState, didChangeAppLifecycleState (+15 more)

### Community 21 - "storage_service.dart"
Cohesion: 0.12
Nodes (10): categoryRepo, contactRepo, initAll, _initialized, instance, isInitialized, reminderRepo, StorageService (+2 more)

### Community 22 - "contact_card.dart"
Cohesion: 0.09
Nodes (25): hashCode, operator, read, typeId, write, address, categoryId, company (+17 more)

### Community 23 - "AppLocalizations"
Cohesion: 0.33
Nodes (5): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, AppLocalizationsHi, of

### Community 24 - "cloud_sync_service.dart"
Cohesion: 0.09
Nodes (14): CloudStorageService, instance, uploadCardPhoto, uploadVoiceMemo, CloudSyncService, instance, lastSyncedAt, _parseDateTime (+6 more)

### Community 25 - "user_profile.dart"
Cohesion: 0.13
Nodes (18): hashCode, operator, read, typeId, write, address, company, copyWith (+10 more)

### Community 26 - "cards_screen.dart"
Cohesion: 0.06
Nodes (26): _allCards, _applyFiltersAndSort, build, _buildCategoryPills, _buildMainContent, CardSortOption, CardsScreen, _CardsScreenState (+18 more)

### Community 27 - "hive_registrar.dart"
Cohesion: 0.15
Nodes (9): categoriesBox, clearAllUserData, contactCardsBox, HiveRegistrar, initHive, _initialized, registerAdapters, remindersBox (+1 more)

### Community 28 - "contact_repository.dart"
Cohesion: 0.15
Nodes (11): _box, clearAllCards, deleteCard, findDuplicate, getAllCards, getCardById, getCardsByCategory, init (+3 more)

### Community 29 - "reminder_repository.dart"
Cohesion: 0.13
Nodes (14): _box, clearAllReminders, deleteReminder, getAllReminders, getCompletedReminders, getOverdueReminders, getReminderById, getRemindersForContact (+6 more)

### Community 30 - "reminders_screen.dart"
Cohesion: 0.05
Nodes (30): build, _buildEmptyState, _buildReminderList, _buildTabItem, _completedList, _confirmDelete, createState, dispose (+22 more)

### Community 31 - "category_repository.dart"
Cohesion: 0.15
Nodes (10): addCustomCategory, _box, CategoryRepository, deleteCategory, getAllCategories, getCategoryById, init, seedDefaultCategories (+2 more)

### Community 32 - "user_profile_repository.dart"
Cohesion: 0.17
Nodes (7): _box, clearProfile, getProfile, init, _profileKey, saveProfile, UserProfileRepository

### Community 33 - "card_parser_service.dart"
Cohesion: 0.04
Nodes (25): AppRouter, _rootNavigatorKey, router, CardParserService, _companyKeywords, _designations, _domainRegex, _emailRegex (+17 more)

### Community 34 - "card_edit_screen.dart"
Cohesion: 0.06
Nodes (33): _addressController, _availableCategories, build, _buildPhotoThumbnailCard, _buildSectionCard, cardId, _companyController, createState (+25 more)

### Community 35 - "category_drilldown_sheet.dart"
Cohesion: 0.11
Nodes (15): build, cardCount, category, CategoryCardTile, isHindi, onDelete, onTap, build (+7 more)

### Community 36 - "firebase_service.dart"
Cohesion: 0.11
Nodes (13): authStateChanges, continueAsGuest, currentUser, FirebaseService, init, _initialized, instance, _isAvailable (+5 more)

### Community 37 - "review_scan_screen.dart"
Cohesion: 0.07
Nodes (27): _addressController, _availableCategories, _checkForDuplicates, _companyController, createState, _detectedDuplicate, dispose, _emailController (+19 more)

### Community 38 - "voice_memo_service.dart"
Cohesion: 0.07
Nodes (18): _countdownTimer, _currentFilePath, deleteMemo, dispose, _isPlaying, _isRecording, maxDurationSeconds, pause (+10 more)

### Community 39 - "voice_memo_widget.dart"
Cohesion: 0.05
Nodes (34): VoiceMemoService, accentColor, backgroundColor, cardBorderColor, hasDarkBackground, id, matchesCategory, nameEn (+26 more)

### Community 40 - "meeting_reminder.dart"
Cohesion: 0.13
Nodes (16): hashCode, operator, read, typeId, write, agenda, contactCardId, copyWith (+8 more)

### Community 41 - "card_detail_screen.dart"
Cohesion: 0.07
Nodes (28): _audioPlayer, build, _buildActionCircle, _buildCardImageViewer, _buildContactDetailsCard, _buildContactHeader, _buildCredentialsSection, _buildNotesAndTagsSection (+20 more)

### Community 42 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.13
Nodes (6): main, createTestApp, main, createTestApp, main, main

### Community 43 - "package:hive/hive.dart"
Cohesion: 0.13
Nodes (7): AppTheme, createTestApp, main, tempDir, createTestApp, main, tempDir

### Community 44 - "../../../core/theme/app_typography.dart"
Cohesion: 0.11
Nodes (11): SyncStatus, build, HomeScreen, _buildAccountCard, ProfileScreen, _showDeleteAccountDialog, build, CloudSyncCard (+3 more)

### Community 45 - "auth_modal.dart"
Cohesion: 0.12
Nodes (16): AuthModal, _AuthModalState, build, createState, dispose, _errorMessage, _handleGuestLogin, _handleSendOtp (+8 more)

### Community 46 - "extracted_card_data.dart"
Cohesion: 0.11
Nodes (17): address, company, copyWith, email, ExtractedCardData, fromJson, gstin, jobTitle (+9 more)

### Community 47 - "locale_controller.dart"
Cohesion: 0.20
Nodes (5): isHindi, _locale, LocaleController, setLocale, toggleLocale

### Community 48 - "card_tile_widget.dart"
Cohesion: 0.12
Nodes (12): build, _buildInitialsAvatar, card, _getInitials, _makeCall, onTap, _openWhatsApp, build (+4 more)

### Community 49 - "contact_picker_test.dart"
Cohesion: 0.15
Nodes (8): createTestApp, main, tempDir, child, createTestApp, locale, main, tempDir

### Community 50 - "add_edit_reminder_sheet.dart"
Cohesion: 0.08
Nodes (20): _agendaController, _availableContacts, build, createState, dispose, _formKey, initialContactId, initState (+12 more)

### Community 51 - "State"
Cohesion: 0.23
Nodes (10): CardDetailScreen, _CardDetailScreenState, CardEditScreen, _CardEditScreenState, ReviewScanScreen, _ReviewScanScreenState, CardMeetingsSection, _CardMeetingsSectionState (+2 more)

### Community 52 - "card_edit_and_vcard_test.dart"
Cohesion: 0.11
Nodes (13): child, createTestApp, createTestAppWithNavigation, FakeAudioplayersPlatform, FakeGlobalAudioplayersPlatform, getCurrentPosition, getDuration, getEventStream (+5 more)

### Community 53 - "app_typography.dart"
Cohesion: 0.14
Nodes (12): AppTypography, bodyLarge, bodyMedium, bodySmall, headlineLarge, headlineMedium, headlineSmall, labelLarge (+4 more)

### Community 54 - "category.dart"
Cohesion: 0.13
Nodes (15): hashCode, operator, read, typeId, write, cardCount, copyWith, defaultCategories (+7 more)

### Community 56 - "../../../core/theme/app_colors.dart"
Cohesion: 0.11
Nodes (13): CardSaathiApp, build, MainShell, navigationShell, _onDestinationSelected, CategoryDrillDownSheet, build, CardTileSkeleton (+5 more)

### Community 57 - "package:flutter/material.dart"
Cohesion: 0.12
Nodes (8): captureCardToImage, CardExportService, shareCardOnWhatsApp, getCategoryIcon, build, card, show, VCardQrModal

### Community 58 - "add_category_dialog.dart"
Cohesion: 0.14
Nodes (12): AddCategoryDialog, _AddCategoryDialogState, _availableIcons, build, createState, dispose, _formKey, _isSaving (+4 more)

### Community 60 - "notification_service.dart"
Cohesion: 0.08
Nodes (18): cancelMeetingNotification, init, _initialized, instance, isInitialized, meetingChannelDesc, meetingChannelId, meetingChannelName (+10 more)

### Community 62 - "meeting_reminder_card.dart"
Cohesion: 0.22
Nodes (7): build, _buildLinkedContact, _makeCall, onDelete, onEdit, onToggleCompleted, reminder

### Community 63 - "reminders_test.dart"
Cohesion: 0.25
Nodes (3): createTestApp, main, tempDir

### Community 65 - "card_meetings_section.dart"
Cohesion: 0.09
Nodes (15): build, main, build, card, cardId, _confirmDelete, createState, didUpdateWidget (+7 more)

### Community 66 - "card_parser_test.dart"
Cohesion: 0.15
Nodes (6): 07AAAPG1234F1Z8, Hospital, Kumar, main, Physician, Saxena

### Community 68 - "card_meetings_and_alarms_test.dart"
Cohesion: 0.25
Nodes (3): createTestApp, main, tempDir

### Community 69 - "contact_picker_service.dart"
Cohesion: 0.13
Nodes (11): _channel, channelName, ContactPickerService, email, fromMap, instance, name, phone (+3 more)

### Community 70 - "Category"
Cohesion: 0.29
Nodes (8): CategoryAdapter, ContactCardAdapter, MeetingReminderAdapter, UserProfileAdapter, Category, ContactCard, MeetingReminder, UserProfile

### Community 71 - "categories_hub_test.dart"
Cohesion: 0.22
Nodes (5): child, createTestApp, locale, main, tempDir

### Community 72 - "digital_card_templates_test.dart"
Cohesion: 0.25
Nodes (3): createTestApp, main, tempDir

### Community 73 - "dart:io"
Cohesion: 0.25
Nodes (5): exportVCardFile, generateVCardString, shareAsText, shareVCard, VCardService

### Community 74 - "stitch_template_registry.dart"
Cohesion: 0.29
Nodes (4): allTemplates, getTemplateById, getTemplatesForCategory, StitchTemplateRegistry

## Knowledge Gaps
- **1213 isolated node(s):** `XCTest`, `_locale`, `isHindi`, `setLocale`, `toggleLocale` (+1208 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1416 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Category` connect `Category` to `category_drilldown_sheet.dart`, `categories_hub_test.dart`, `contact_picker_test.dart`, `card_edit_and_vcard_test.dart`, `category.dart`, `hive_registrar.dart`, `category_repository.dart`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `XCTest`, `_locale`, `isHindi` to the rest of the system?**
  _1213 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `ContactCard` connect `Category` to `card_meetings_section.dart`, `card_edit_screen.dart`, `review_scan_screen.dart`, `digital_card_screen.dart`, `card_detail_screen.dart`, `card_tile_widget.dart`, `contact_card.dart`, `package:flutter/material.dart`, `hive_registrar.dart`, `contact_repository.dart`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Why does `MeetingReminder` connect `Category` to `meeting_reminder.dart`, `add_edit_reminder_sheet.dart`, `hive_registrar.dart`, `reminder_repository.dart`, `meeting_reminder_card.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **Should `digital_card_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.0553306342780027 - nodes in this community are weakly interconnected._