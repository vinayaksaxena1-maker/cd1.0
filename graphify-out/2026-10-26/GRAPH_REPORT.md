# Graph Report - CD1.0  (2026-10-26)

## Corpus Check
- 59 files · ~19,064 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 31 file(s) not represented in the graph (top: .xml 7, (none) 5, .plist 4)

## Summary
- 664 nodes · 798 edges · 33 communities (25 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `db43711d`
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
- app_typography.dart
- app_localizations_en.dart
- app_localizations_hi.dart
- scan_screen.dart
- storage_service.dart
- contact_card.dart
- AppLocalizations
- user_profile.dart
- meeting_reminder.dart
- hive_registrar.dart
- contact_repository.dart
- reminder_repository.dart
- scan_test.dart
- category_repository.dart
- user_profile_repository.dart

## God Nodes (most connected - your core abstractions)
1. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
2. `AppLocalizations` - 7 edges
3. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
4. `Category` - 6 edges
5. `ContactCard` - 6 edges
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

## Communities (33 total, 8 thin omitted)

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
Cohesion: 0.06
Nodes (26): build, CardSaathiApp, main, build, MainShell, navigationShell, _onDestinationSelected, build (+18 more)

### Community 8 - "AppDelegate"
Cohesion: 0.11
Nodes (6): Flutter, AppDelegate, SceneDelegate, RunnerTests, UIKit, XCTest

### Community 9 - "app_localizations.dart"
Cohesion: 0.03
Nodes (61): address, agreeAndEnable, alignCardInFrame, appTagline, appTitle, callDirectly, cameraDisclosure, cameraDisclosureTitle (+53 more)

### Community 10 - "repository_test.dart"
Cohesion: 0.12
Nodes (7): main, categoryRepo, contactRepo, main, profileRepo, reminderRepo, tempDir

### Community 17 - "app_typography.dart"
Cohesion: 0.06
Nodes (16): AppRouter, _rootNavigatorKey, router, AppTheme, AppTypography, bodyLarge, bodyMedium, bodySmall (+8 more)

### Community 18 - "app_localizations_en.dart"
Cohesion: 0.04
Nodes (53): address, agreeAndEnable, alignCardInFrame, appTagline, appTitle, callDirectly, cameraDisclosure, cameraDisclosureTitle (+45 more)

### Community 19 - "app_localizations_hi.dart"
Cohesion: 0.04
Nodes (53): address, agreeAndEnable, alignCardInFrame, appTagline, appTitle, callDirectly, cameraDisclosure, cameraDisclosureTitle (+45 more)

### Community 20 - "scan_screen.dart"
Cohesion: 0.05
Nodes (32): _availableCameras, _backImagePath, build, _cameraController, _captureCard, _checkPermissionsAndInitCamera, createState, didChangeAppLifecycleState (+24 more)

### Community 21 - "storage_service.dart"
Cohesion: 0.08
Nodes (14): isHindi, _locale, LocaleController, setLocale, toggleLocale, categoryRepo, contactRepo, initAll (+6 more)

### Community 22 - "contact_card.dart"
Cohesion: 0.08
Nodes (25): hashCode, operator, read, typeId, write, address, categoryId, company (+17 more)

### Community 23 - "AppLocalizations"
Cohesion: 0.33
Nodes (5): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, AppLocalizationsHi, of

### Community 25 - "user_profile.dart"
Cohesion: 0.13
Nodes (18): hashCode, operator, read, typeId, write, address, company, copyWith (+10 more)

### Community 26 - "meeting_reminder.dart"
Cohesion: 0.13
Nodes (16): hashCode, operator, read, typeId, write, agenda, contactCardId, copyWith (+8 more)

### Community 27 - "hive_registrar.dart"
Cohesion: 0.06
Nodes (32): CategoryAdapter, hashCode, operator, read, typeId, write, ContactCardAdapter, MeetingReminderAdapter (+24 more)

### Community 28 - "contact_repository.dart"
Cohesion: 0.14
Nodes (12): _box, clearAllCards, ContactRepository, deleteCard, findDuplicate, getAllCards, getCardById, getCardsByCategory (+4 more)

### Community 29 - "reminder_repository.dart"
Cohesion: 0.15
Nodes (10): _box, clearAllReminders, deleteReminder, getAllReminders, getRemindersForContact, getUpcomingReminders, init, ReminderRepository (+2 more)

### Community 30 - "scan_test.dart"
Cohesion: 0.11
Nodes (6): main, main, createTestApp, main, main, main

### Community 31 - "category_repository.dart"
Cohesion: 0.15
Nodes (10): addCustomCategory, _box, CategoryRepository, deleteCategory, getAllCategories, getCategoryById, init, seedDefaultCategories (+2 more)

### Community 32 - "user_profile_repository.dart"
Cohesion: 0.18
Nodes (7): _box, clearProfile, getProfile, init, _profileKey, saveProfile, UserProfileRepository

## Knowledge Gaps
- **382 isolated node(s):** `XCTest`, `_locale`, `isHindi`, `setLocale`, `toggleLocale` (+377 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 505 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ContactCard` connect `hive_registrar.dart` to `contact_repository.dart`, `contact_card.dart`?**
  _High betweenness centrality (0.039) - this node is a cross-community bridge._
- **What connects `XCTest`, `_locale`, `isHindi` to the rest of the system?**
  _382 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `Category` connect `hive_registrar.dart` to `category_repository.dart`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Why does `MeetingReminder` connect `hive_registrar.dart` to `meeting_reminder.dart`, `reminder_repository.dart`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Should `package:flutter/material.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06386066763425254 - nodes in this community are weakly interconnected._