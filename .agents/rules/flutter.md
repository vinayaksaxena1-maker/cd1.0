---
trigger: always_on
description: Core Flutter architecture, UI/UX design, testing and debugging protocol for this project.
---

# Flutter Engineering & Skill Routing Protocol

This project is a native Flutter mobile application. When developing, modifying, testing, or debugging code in this repository, strictly route to the following active skills:

## 1. Architecture & Core Implementation
* **Layered Architecture**: Route to `flutter-apply-architecture-best-practices`. Enforce clean separation: UI (Screens/Widgets) ➔ Logic (State Management/Controllers) ➔ Data (Repositories/Models).
* **Responsive Layouts**: Route to `flutter-build-responsive-layout` (`LayoutBuilder`, `MediaQuery`). All screens must adapt seamlessly across varying Android screen sizes without overflow.
* **Declarative Routing**: Route to `flutter-setup-declarative-routing` (`go_router`) for URL/deep-link capable screen navigation.
* **Data Serialization**: Route to `flutter-implement-json-serialization` for all data models (`fromJson`, `toJson`).
* **Localization**: Route to `flutter-setup-localization` for Hindi and English bilingual support (`intl`, `l10n.yaml`).

## 2. Mobile UI/UX & State Resilience
* **Touch-First Guidelines**: Route to `mobile-design`. Minimum 48x48dp touch targets, thumb-zone navigation, and platform-respectful Android gestures.
* **Visual Styling & Cards**: Route to `ui-ux-pro-max` for typography, color harmonies, and digital card presentation.
* **5-State Resilience**: Route to `component-state-craftsman`. Every dynamic widget must explicitly handle 5 states:
  1. Default
  2. Hover / Active Tap
  3. Loading Skeleton
  4. Error / Fallback
  5. Empty Data

## 3. Testing & Device Automation
* **Autonomous Device QA**: Route to `google-artemis`. Autonomous vision-based UI flows on BlueStacks (`emulator-5554` / `127.0.0.1:5555`). Web automation (Puppeteer) is strictly prohibited.
* **Widget Tests**: Route to `flutter-add-widget-test` (`WidgetTester`) for component-level interaction testing.
* **Integration Tests**: Route to `flutter-add-integration-test` for end-to-end device regression suites.
* **Unit Tests**: Route to `dart-add-unit-test` for pure business logic and algorithms.

## 4. Debugging & Zero-Defect Gates
* **Layout Overflows**: When yellow/black overflow stripes or unbounded constraints appear, route to `flutter-fix-layout-issues`.
* **Runtime Crashes**: When stack traces or null errors appear in Logcat, route to `dart-fix-runtime-errors`.
* **Static Analysis**: Route to `dart-run-static-analysis` (`dart analyze`, `dart fix --apply`) before committing any code changes.
