import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test_app/home_page/bloc/home_bloc.dart';
import 'package:map_test_app/home_page/view_model/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with HomeViewModel, ChangeNotifier {
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (HomeState previous, HomeState current) =>
              current.runtimeType == PathRecorderState,
          builder: (BuildContext context, HomeState state) {
            if (state.runtimeType == PathRecorderState) {
              isPathRecording = (state as PathRecorderState).activate;
            }
            return Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: centerMap,
                  child: const Icon(
                    Icons.map_rounded,
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  onPressed: playRecording,
                  child: Icon(
                    isPathRecording ? Icons.stop : Icons.play_arrow,
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  onPressed: save,
                  child: const Icon(
                    Icons.save,
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  onPressed: deleteRecording,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  onPressed: clearMap,
                  child: const Icon(
                    Icons.restart_alt_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
        ),
        body: ValueListenableBuilder<dynamic>(
          valueListenable: updateMarkers,
          builder: (BuildContext context, _, Widget? child) => GoogleMap(
            markers: markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentPosition?.latitude ?? 0,
                currentPosition?.longitude ?? 0,
              ),
              zoom: 19.151926040649414,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
          ),
        ),
      );
}
