import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_test_app/core/helpers/app_initializer.dart';
import 'package:map_test_app/core/helpers/global_instances.dart';
import 'package:map_test_app/core/helpers/location_permission_handler.dart';
import 'package:map_test_app/home_page/bloc/home_bloc.dart';
import 'package:map_test_app/home_page/view/home_view.dart';
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print(state);
    if (laststate != AppLifecycleState.resumed) {
      laststate = state;
    }
    switch (state) {
      case AppLifecycleState.resumed:
        if (laststate == AppLifecycleState.hidden) {
          getLocationPermissions();
          notifyListeners();
        }

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(),
        )
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          theme: ThemeData.light().copyWith(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.green,
            ),
          ),
          navigatorKey: navigatorKey,
          initialRoute: "home",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "home":
                return CupertinoPageRoute(
                  builder: (context) => const HomeView(),
                );

              default:
            }
            return null;
          },
        ),
      ),
    );
  }
}
