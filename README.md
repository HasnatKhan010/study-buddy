# Study Buddy

[Live web app](https://hasnatkhan010.github.io/study-buddy/)

A small Flutter study planner. Create tasks with a focus timer length, start or pause a live countdown, finish tasks, search and filter the plan, and review progress. Swipe through funny motivational quotes or let them advance every 10 seconds. Tasks and timer deadlines are saved locally. No account is needed.

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

Add “Practice Flutter layouts” in Coding for 30 minutes. Open the task and start its timer; watch the seconds count down. Pause or finish it, open Progress to see the counts update, and reload the app to show local saving. Swipe the quote card on Plan, then wait 10 seconds to see the next quote appear automatically.
