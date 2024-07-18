import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class MarkerDetailsDialog extends StatelessWidget {
  final Marker marker;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? userName;
  final DateTime date;

  const MarkerDetailsDialog({
    Key? key,
    required this.marker,
    required this.title,
    required this.description,
    required this.imageUrls,
    this.userName,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    String formattedTime = DateFormat('hh:mm a').format(date);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'marker_details_dialog.details_report'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Divider(color: Colors.grey[400]),
              SizedBox(height: 16),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'marker_details_dialog.photos'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[600],
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageUrls.map((url) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          url,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[200]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              if (userName != null)
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      '${'marker_details_dialog.reported_by'.tr()} $userName',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              if (userName != null) SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${'marker_details_dialog.location'.tr()} ${marker.position.latitude}, ${marker.position.longitude}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    '${'marker_details_dialog.date'.tr()} $formattedDate',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    '${'marker_details_dialog.time'.tr()} $formattedTime',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
