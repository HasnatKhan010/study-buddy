# Aster Study

[Live web app](https://hasnatkhan010.github.io/aster-study/)

A small, complete Flutter study planner. Create study tasks, choose a focus area and estimated time, mark tasks complete, search and filter the plan, and review progress. Tasks are saved locally on the device. No account or internet connection is needed.

## Run

```bash
flutter pub get
flutter run -d chrome
```

For Android, install and configure the Android SDK, then use `flutter run -d <device-id>`.

Pushes to `main` automatically run the tests and publish the web app to GitHub Pages.

## How it works

- `lib/planner.dart` contains the `StudyTask` model, the four focus areas, the Dart calculations, and local JSON saving through `shared_preferences`.
- `lib/main.dart` contains the theme and screens. `Planner` is a `ChangeNotifier`, so an `AnimatedBuilder` redraws a screen when tasks change.
- The bottom bar switches between Plan, Subjects, and Progress. `Navigator.push` opens the add-task, subject-detail, and task-detail screens.

## Lab concepts used in the actual app

| Concept | Use |
| --- | --- |
| `TextField` | Task title, minutes, and live search |
| `ElevatedButton` | Submit a new task and complete a task |
| `TextStyle`, `TextTheme`, `ThemeData` | Consistent typography, teal colors, inputs, and buttons |
| `BottomNavigationBar`, `Icon` | Three main destinations and recognizable actions |
| Dart logic | Validation, search/filter, task counts, and progress calculations |
| `Container`, `Row`, `Column`, `GridView` | Dashboard card, task rows, detail layout, and focus-area grid |
| Basic routing | Add-task, subject-detail, and task-detail pages |
| `StatefulWidget`, `StatelessWidget` | Form and selected-tab state; reusable display widgets |

## Try it in a viva

Add “Practice Flutter layouts” in Coding for 30 minutes. Mark it done, open Subjects to see Coding update, then open Progress to see the task and minutes counts change. Close and reopen the app to show local saving.
