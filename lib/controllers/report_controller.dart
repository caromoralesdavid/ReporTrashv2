import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/report_service.dart';
import '../utils/logger.dart';
import '../widgets/custom_snackbar.dart';

class ReportController {
  final ReportService _reportService = ReportService();

  Future<void> uploadReport(
      BuildContext context,
      String title,
      String description,
      DateTime date,
      List<String> imagePaths,
      LatLng location,
      ) async {
    try {
      await _reportService.uploadReport(title, description, date, imagePaths, location);
      Logger.log('Report uploaded successfully');

      CustomSnackbar.show(
        context,
        'Report uploaded successfully',
        SnackbarState.completed,
      );

      Navigator.of(context).pop();

    } catch (e, stackTrace) {
      Logger.logError('Error uploading report', error: e, stackTrace: stackTrace);

      CustomSnackbar.show(
        context,
        'Error uploading report. Please try again.',
        SnackbarState.error,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    return await _reportService.getReports();
  }

  Future<List<Map<String, dynamic>>> getReportsForUser() async {
    return await _reportService.getReportsForUser();
  }
}
