import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_test_app/core/helpers/app_initializer.dart';
import 'package:map_test_app/core/helpers/global_instances.dart';
import 'package:map_test_app/core/helpers/location_permission_handler.dart';
import 'package:map_test_app/home_page/bloc/home_bloc.dart';
import 'package:map_test_app/home_page/view/home_view.dart';
// ignore: depend_on_referenced_packages
import 'package:nested/nested.dart';

import 'package:toastification/toastification.dart';

void main() {
  appInitializer();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp>
    with WidgetsBindingObserver, ChangeNotifier {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (laststate != AppLifecycleState.resumed) {
      laststate = state;
    }
    switch (state) {
      case AppLifecycleState.resumed:
        if (laststate == AppLifecycleState.hidden) {
          await getLocationPermissions();
          notifyListeners();
        }

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(),
          ),
        ],
        child: ToastificationWrapper(
          child: MaterialApp(
            theme: ThemeData.light().copyWith(
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
              ),
            ),
            navigatorKey: navigatorKey,
            initialRoute: "home",
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case "home":
                  return CupertinoPageRoute<dynamic>(
                    builder: (BuildContext context) => const HomeView(),
                  );

                default:
              }
              return null;
            },
          ),
        ),
      );
}
