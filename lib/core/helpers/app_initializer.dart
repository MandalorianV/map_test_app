import 'package:flutter/material.dart';

void appInitializer() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Normally Google api keys needs to retrieve from .env but for testing
  /// purposes, I'll leave as it is.
  // await FlutterConfig.loadEnvVariables();
}
