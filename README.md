# Study Buddy

[Live web app](https://hasnatkhan010.github.io/study-buddy/)

A Flutter study planner with editable tasks, optional due dates and notes, a focus timer, daily goals, focus history, and a completion chime. Search and filter the plan, review progress, and swipe through funny motivational quotes that advance every 10 seconds. Tasks, sessions, and settings are saved locally. No account is needed.

The focus timer shows an in-app completion message and plays a chime while the app is open. A browser or device may limit automatic sound, so the Progress screen includes a **Play chime** button and a sound switch. Background system notifications are not part of this version.

## Install on iPhone now

Open the [live app](https://hasnatkhan010.github.io/study-buddy/) in Safari on the iPhone. Tap Share, choose **Add to Home Screen**, enable **Open as Web App** if shown, then tap **Add**. The Study Buddy icon opens the Flutter web app from the Home Screen. Keep an internet connection available when opening it; this site does not include offline caching.

This Home Screen installation is a web app. Building a native iOS `.ipa` from Flutter also requires macOS, Xcode, and Apple signing.

## Run

```bash
flutter pub get
flutter run -d chrome
```

For Android, install and configure the Android SDK, then use `flutter run -d <device-id>`.

Pushes to `main` automatically run the tests and publish the web app to GitHub Pages.

## How it works

- `lib/main.dart` starts the app and loads saved tasks.
- `lib/app.dart` holds `MaterialApp`, the theme, the main `AppBar`, and the bottom navigation bar.
- `lib/app_colors.dart` holds the shared colors.
- `lib/planner.dart` holds task data, timer logic, progress calculations, and local saving.
- `lib/focus_session.dart` records completed focus sessions. `lib/focus_chime.dart` plays the bundled completion sound.
- `lib/screens/` has one file per main screen or related detail screen: Plan, Subjects, Progress, New task, and Task details.
- `lib/widgets/` holds cards reused by the screens. `lib/quote_carousel.dart` holds the swipeable quotes and their 10-second timer.
- `lib/timer_text.dart` formats the countdown. `Planner` is a `ChangeNotifier`, so `AnimatedBuilder` updates the screens when tasks change.
- The `AppBar` shows the app name on the main tabs; detail pages use it for a title and back button. The bottom bar switches main tabs. `Navigator.push` opens detail screens.

## Lab concepts used in the actual app

| Concept | Use |
| --- | --- |
| `TextField` | Task title, timer minutes, and live search |
| `ElevatedButton` | Submit a new task and complete a task |
| `TextStyle`, `TextTheme`, `ThemeData` | Consistent typography, teal colors, inputs, and buttons |
| `AppBar`, `BottomNavigationBar`, `Icon` | App identity, back navigation, three main destinations, and recognizable actions |
| Dart logic | Validation, search/filter, task counts, countdown, and progress calculations |
| `Container`, `Row`, `Column`, `GridView` | Dashboard card, task rows, detail layout, and focus-area grid |
| `Image.asset`, `Card` | Study Buddy logo in the header and real task cards |
| Basic routing | Add-task, subject-detail, and task-detail pages |
| `StatefulWidget`, `StatelessWidget` | Form and selected-tab state; reusable display widgets |

## Try it in a viva

Add “Practice Flutter layouts” in Coding for 30 minutes, with a due date and note. Open the task, edit it, and start its timer. On Progress, set a daily goal and use **Play chime** to hear the alert. When the timer ends, a completion message appears and the session joins focus history. Finish the task separately, then reload to show local saving. Swipe the quote card on Plan, then wait 10 seconds to see the next quote appear automatically.
