import 'package:flutter/material.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await HiveService().init();
  await initDependencies();
  runApp(const MyApp());
}
