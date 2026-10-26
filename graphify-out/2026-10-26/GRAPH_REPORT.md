# Graph Report - CD1.0  (2026-10-26)

## Corpus Check
- 25 files · ~8,969 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 29 file(s) not represented in the graph (top: .xml 7, (none) 5, .plist 4)

## Summary
- 157 nodes · 151 edges · 18 communities (10 shown, 8 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8b331a0d`
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
- main.dart
- RunnerTests.swift
- AppDelegate
- theme_test.dart
- MainActivity.kt
- LaunchImage.imageset/README.md
- app_typography.dart

## God Nodes (most connected - your core abstractions)
1. `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` - 11 edges
2. `🏗️ 6. अनुशंसित क्रियान्वयन क्रम (Recommended 6-Milestone Order)` - 7 edges
3. `Components` - 6 edges
4. `AppDelegate` - 5 edges
5. `Flutter Engineering & Skill Routing Protocol` - 5 edges
6. `Workspace Agent Guidelines & Active Skills` - 4 edges
7. `Flutter` - 3 edges
8. `RunnerTests` - 3 edges
9. `MyHomePage` - 3 edges
10. `_MyHomePageState` - 3 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (18 total, 8 thin omitted)

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

### Community 7 - "main.dart"
Cohesion: 0.15
Nodes (9): build, _counter, createState, _incrementCounter, main, MyApp, MyHomePage, _MyHomePageState (+1 more)

### Community 8 - "RunnerTests.swift"
Cohesion: 0.22
Nodes (5): Flutter, SceneDelegate, RunnerTests, UIKit, XCTest

### Community 10 - "theme_test.dart"
Cohesion: 0.14
Nodes (3): AppTheme, main, main

### Community 17 - "app_typography.dart"
Cohesion: 0.14
Nodes (12): AppTypography, bodyLarge, bodyMedium, bodySmall, headlineLarge, headlineMedium, headlineSmall, labelLarge (+4 more)

## Knowledge Gaps
- **55 isolated node(s):** `XCTest`, `AppColors`, `forestGreen`, `primary`, `primaryContainer` (+50 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 124 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDelegate` connect `AppDelegate` to `RunnerTests.swift`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **What connects `XCTest`, `AppColors`, `forestGreen` to the rest of the system?**
  _55 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `कार्डसाथी (CardSaathi) — फ़्लटर संपूर्ण क्रियान्वयन योजना` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Should `app_colors.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._
- **Should `theme_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.14166666666666666 - nodes in this community are weakly interconnected._
- **Should `app_typography.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._