import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

void appInitializer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  print(FlutterConfig.get('GOOGLE_API_KEY'));
}
