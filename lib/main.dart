import 'package:flutter/material.dart';

import 'app.dart';
import 'planner.dart';

// Start the app after loading tasks saved on this device.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final planner = Planner();
  await planner.load();
  runApp(StudyBuddyApp(planner: planner));
}
