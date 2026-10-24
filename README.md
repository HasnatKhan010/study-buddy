# Study Buddy

[Live web app](https://hasnatkhan010.github.io/study-buddy/)

A small Flutter study planner. Create tasks with a focus timer length, start or pause a live countdown, finish tasks, search and filter the plan, and review progress. Swipe through funny motivational quotes or let them advance every 10 seconds. Tasks and timer deadlines are saved locally. No account or internet connection is needed.

## Run

```bash
flutter pub get
flutter run -d chrome
```

For Android, install and configure the Android SDK, then use `flutter run -d <device-id>`.

Pushes to `main` automatically run the tests and publish the web app to GitHub Pages.

## How it works

- `lib/planner.dart` contains the `StudyTask` model, countdown state, the four focus areas, progress calculations, and local JSON saving through `shared_preferences`.
- `lib/main.dart` contains the theme and screens. `Planner` is a `ChangeNotifier`, so an `AnimatedBuilder` redraws a screen when tasks change.
- `lib/quote_carousel.dart` contains a swipeable `PageView` and a 10-second `Timer`.
- The bottom bar switches between Plan, Subjects, and Progress. `Navigator.push` opens the add-task, subject-detail, and task-detail screens.

## Lab concepts used in the actual app

| Concept | Use |
| --- | --- |
| `TextField` | Task title, timer minutes, and live search |
| `ElevatedButton` | Submit a new task and complete a task |
| `TextStyle`, `TextTheme`, `ThemeData` | Consistent typography, teal colors, inputs, and buttons |
| `BottomNavigationBar`, `Icon` | Three main destinations and recognizable actions |
| Dart logic | Validation, search/filter, task counts, countdown, and progress calculations |
| `Container`, `Row`, `Column`, `GridView` | Dashboard card, task rows, detail layout, and focus-area grid |
| `Image.asset`, `Card` | Study Buddy logo in the header and real task cards |
| Basic routing | Add-task, subject-detail, and task-detail pages |
| `StatefulWidget`, `StatelessWidget` | Form and selected-tab state; reusable display widgets |

## Try it in a viva

Add “Practice Flutter layouts” in Coding for 30 minutes. Open the task and start its timer; watch the seconds count down. Pause or finish it, open Progress to see the counts update, and reload the app to show local saving. Swipe the quote card on Plan, then wait 10 seconds to see the next quote appear automatically.
