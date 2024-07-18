import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/map_controller.dart';
import '../dialogs/report_dialog.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<InicioPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getReportMarkers();
  }

  Future<void> _getReportMarkers() async {
    await _mapController.getReportMarkers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _mapController.onMapCreated(controller, context),
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 15,
        ),
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        markers: {
          if (_mapController.redMarker != null) _mapController.redMarker!,
          ..._mapController.blueMarkers,
        },
        onTap: (position) {
          setState(() {
            _mapController.onMapTapped(position);
          });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ReportDialog(mapController: _mapController);
                },
              ).then((_) {
                setState(() {
                  _mapController.clearRedMarker();
                  _getReportMarkers();
                });
              });
            },
            child: const Icon(Icons.add),
            shape: const CircleBorder(),
            backgroundColor: Colors.pinkAccent[100],
          ),
        ),
      ),
    );
  }
}
