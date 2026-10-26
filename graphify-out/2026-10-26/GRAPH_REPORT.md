# Graph Report - CD1.0  (2026-10-26)

## Corpus Check
- 40 files · ~12,812 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 31 file(s) not represented in the graph (top: .xml 7, (none) 5, .plist 4)

## Summary
- 379 nodes · 421 edges · 25 communities (17 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a3bbcbe3`
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
- router_test.dart
- MainActivity.kt
- LaunchImage.imageset/README.md
- app_typography.dart
- app_localizations_en.dart
- app_localizations_hi.dart
- app_router.dart
- locale_controller.dart
- build
- AppLocalizations

## God Nodes (most connected - your core abstractions)
1. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
2. `AppLocalizations` - 7 edges
3. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
4. `Components` - 6 edges
5. `AppDelegate` - 5 edges
6. `Flutter Engineering & Skill Routing Protocol` - 5 edges
7. `Workspace Agent Guidelines & Active Skills` - 4 edges
8. `Flutter` - 3 edges
9. `RunnerTests` - 3 edges
10. `_AppLocalizationsDelegate` - 3 edges

## Surprising Connections (you probably didn't know these)
- `AppLocalizationsEn` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_en.dart → lib/l10n/app_localizations.dart
- `AppLocalizationsHi` --inherits--> `AppLocalizations`  [EXTRACTED]
  lib/l10n/app_localizations_hi.dart → lib/l10n/app_localizations.dart

## Import Cycles
- None detected.

## Communities (25 total, 8 thin omitted)

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
Cohesion: 0.08
Nodes (21): AppTheme, build, CardSaathiApp, main, build, MainShell, navigationShell, _onDestinationSelected (+13 more)

### Community 8 - "AppDelegate"
Cohesion: 0.11
Nodes (6): Flutter, AppDelegate, SceneDelegate, RunnerTests, UIKit, XCTest

### Community 9 - "app_localizations.dart"
Cohesion: 0.03
Nodes (51): address, appTagline, appTitle, callDirectly, cameraDisclosure, cancel, category, company (+43 more)

### Community 10 - "router_test.dart"
Cohesion: 0.14
Nodes (4): main, main, main, main

### Community 17 - "app_typography.dart"
Cohesion: 0.14
Nodes (12): AppTypography, bodyLarge, bodyMedium, bodySmall, headlineLarge, headlineMedium, headlineSmall, labelLarge (+4 more)

### Community 18 - "app_localizations_en.dart"
Cohesion: 0.04
Nodes (43): address, appTagline, appTitle, callDirectly, cameraDisclosure, cancel, category, company (+35 more)

### Community 19 - "app_localizations_hi.dart"
Cohesion: 0.04
Nodes (43): address, appTagline, appTitle, callDirectly, cameraDisclosure, cancel, category, company (+35 more)

### Community 20 - "app_router.dart"
Cohesion: 0.14
Nodes (3): AppRouter, _rootNavigatorKey, router

### Community 21 - "locale_controller.dart"
Cohesion: 0.20
Nodes (5): isHindi, _locale, LocaleController, setLocale, toggleLocale

### Community 22 - "build"
Cohesion: 0.29
Nodes (3): build, build, build

### Community 23 - "AppLocalizations"
Cohesion: 0.33
Nodes (5): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsEn, AppLocalizationsHi, of

## Knowledge Gaps
- **205 isolated node(s):** `XCTest`, `_locale`, `isHindi`, `setLocale`, `toggleLocale` (+200 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 300 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppLocalizations` connect `AppLocalizations` to `app_localizations.dart`?**
  _High betweenness centrality (0.007) - this node is a cross-community bridge._
- **What connects `XCTest`, `_locale`, `isHindi` to the rest of the system?**
  _205 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Why does `build` connect `build` to `package:flutter/material.dart`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Why does `build` connect `build` to `package:flutter/material.dart`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Should `package:flutter/material.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.07632850241545894 - nodes in this community are weakly interconnected._