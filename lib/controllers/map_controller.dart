import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../dialogs/marker_details_dialog.dart';
import '../utils/logger.dart';
import '../services/report_service.dart';

class MapController {
  late GoogleMapController mapController;
  Marker? redMarker;
  Set<Marker> blueMarkers = {};
  BuildContext? context;

  void onMapCreated(GoogleMapController controller, BuildContext context) {
    mapController = controller;
    this.context = context;
    Logger.log('Map created');
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      if (await Permission.location.request().isGranted) {
        _goToCurrentLocation();
      } else {
        Logger.log('Location permissions denied');
      }
    } else {
      _goToCurrentLocation();
    }
  }

  void _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    } catch (e) {
      Logger.log('Error getting current location: $e');
    }
  }

  void onMapTapped(LatLng position) {
    redMarker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  void clearRedMarker() {
    redMarker = null;
  }

  Future<void> getReportMarkers() async {
    List<Map<String, dynamic>> reports = await ReportService().getReports();

    blueMarkers.clear();

    for (var report in reports) {
      GeoPoint geoPoint = report['location'];
      LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
      String userName = report['userName'] ?? 'Unknown User';

      blueMarkers.add(
        Marker(
          markerId: MarkerId(report['title']),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () {
            if (context != null) {
              showDialog(
                context: context!,
                builder: (BuildContext context) {
                  return MarkerDetailsDialog(
                    marker: Marker(
                      markerId: MarkerId(report['title']),
                      position: position,
                    ),
                    title: report['title'],
                    description: report['description'],
                    imageUrls: List<String>.from(report['imageUrls']),
                    userName: userName,
                    date: (report['date'] as Timestamp).toDate(),
                  );
                },
              );
            }
          },
        ),
      );
    }
  }
}
