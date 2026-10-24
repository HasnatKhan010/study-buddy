import 'package:study_buddy/main.dart';
import 'package:study_buddy/planner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  testWidgets('navigation and task form validation work', (tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final planner = Planner();
    await tester.pumpWidget(StudyBuddyApp(planner: planner));
    expect(tester.takeException(), isNull, reason: 'Plan screen must fit');

    expect(find.text('Make today count.'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    await tester.tap(find.text('Subjects'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Subjects screen must fit');
    expect(find.text('Study by subject.'), findsOneWidget);

    await tester.tap(find.text('New task'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Add task screen must fit');
    expect(find.text('Plan a small win.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Read chapter 4');
    await tester.enterText(find.byType(TextField).last, '0');
    await tester.ensureVisible(find.text('Add to my plan'));
    await tester.tap(find.text('Add to my plan'));
    await tester.pump();
    expect(
      find.text('Enter a task and a duration from 1 to 600 minutes.'),
      findsOneWidget,
    );
    expect(planner.tasks, isEmpty);

    await tester.enterText(find.byType(TextField).last, '30');
    await tester.ensureVisible(find.text('Add to my plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to my plan'));
    await tester.pumpAndSettle();
    expect(planner.tasks.length, 1);
    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Read chapter 4'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Read chapter 4'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Read chapter 4'));
    await tester.pumpAndSettle();
    expect(find.text('FOCUS TIMER'), findsOneWidget);
    expect(find.text('30:00'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'Timer screen must fit');
  });

  testWidgets('quotes rotate and the focus timer can pause and finish', (
    tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final planner = Planner();
    planner.addTask('Practice layouts', Subject.coding, 1);
    final task = planner.tasks.single;
    await tester.pumpWidget(StudyBuddyApp(planner: planner));

    expect(
      find.text('Big goals are tiny tasks in a trench coat.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    expect(
      find.text('Study now. Let your pillow be proud later.'),
      findsOneWidget,
    );
    await tester.fling(find.byType(PageView), const Offset(-650, 0), 1000);
    await tester.pumpAndSettle();
    expect(
      find.text('Plot twist: you are actually making progress.'),
      findsOneWidget,
    );

    planner.startTimer(task);
    await tester.pump();
    final startingSeconds = task.secondsLeft;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 2)),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(task.secondsLeft, lessThan(startingSeconds));
    planner.pauseTimer(task);
    final pausedSeconds = task.secondsLeft;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 1)),
    );
    expect(task.secondsLeft, pausedSeconds);
    planner.finishTask(task);
    expect(task.isDone, isTrue);
    expect(task.secondsLeft, 0);

    await tester.pumpWidget(const SizedBox());
    planner.dispose();
  });
}
