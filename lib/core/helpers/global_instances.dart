import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

bool isAppLocationPermissionDeniedOnce = false;

AppLifecycleState laststate = AppLifecycleState.resumed;
