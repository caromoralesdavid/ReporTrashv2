import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../controllers/report_controller.dart';
import '../dialogs/marker_details_dialog.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({Key? key}) : super(key: key);

  @override
  _MyReportsPageState createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  final ReportController _reportController = ReportController();
  List<Map<String, dynamic>> _userReports = [];

  @override
  void initState() {
    super.initState();
    _fetchUserReports();
  }

  Future<void> _fetchUserReports() async {
    List<Map<String, dynamic>> userReports = await _reportController.getReportsForUser();
    setState(() {
      _userReports = userReports;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _userReports.isEmpty
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _userReports.map((report) {
                  final String title = report['title'] ?? '';
                  final DateTime? date = report['date']?.toDate();
                  final String formattedDate = date != null ? DateFormat('dd/MM/yyyy').format(date) : '';
                  return ReportItem(
                    title: title,
                    date: formattedDate,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MarkerDetailsDialog(
                            marker: Marker(
                              markerId: MarkerId(title),
                              position: LatLng(
                                report['location']?.latitude ?? 0.0,
                                report['location']?.longitude ?? 0.0,
                              ),
                            ),
                            title: title,
                            description: report['description'] ?? '',
                            imageUrls: List<String>.from(report['imageUrls'] ?? []),
                            userName: report['userName'],
                            date: date ?? DateTime.now(),
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onTap;

  const ReportItem({
    Key? key,
    required this.title,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(Icons.person, size: 40),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.report, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.green),
                        SizedBox(width: 8),
                        Text(date, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
