import 'package:flutter/material.dart';

/// it is for a proper context management from root
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// due to the restrictions you can not ask more than two times for location usage permission. App knows that it needs to be enabled by settings
bool isAppLocationPermissionDeniedOnce = false;

/// Holds the last appcycle state
AppLifecycleState laststate = AppLifecycleState.resumed;
