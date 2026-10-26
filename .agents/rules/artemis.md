---
trigger: always_on
description: Google Artemis Android automation and testing rules for BlueStacks and real devices.
---

## Google Artemis Testing Protocol

This project uses **Google Artemis** (`D:\artemis`) as the primary autonomous Android testing agent.

### Target Device: BlueStacks 5
- **Emulator Target**: BlueStacks 5 (`Pie64` instance)
- **ADB Endpoint**: `127.0.0.1:5555`
- **Connect Command**: `adb connect 127.0.0.1:5555`

### Execution Rules
1. **Zero Puppeteer for Mobile**: Web automation tools (Puppeteer) are strictly prohibited for Flutter/Android testing. Use Google Artemis (`mobile_run_task`, `mobile_get_device_state`, `mobile_diagnose`) for all mobile UI interactions.
2. **Device State Verification**: Before executing a mobile UI test, always verify that the target device (`127.0.0.1:5555` or USB connected device) is online via `adb devices`.
3. **Execution Modes**:
   - **Flash Mode**: Fast reactive UI tasks (button taps, text inputs, screen navigation).
   - **Pro Mode**: Exploratory QA, self-healing popups, crash/ANR detection, Logcat verification.
4. **Traces & Screenshots**: Inspect test artifacts in `D:\artemis\traces` or via `mobile_inspect_trace`.
