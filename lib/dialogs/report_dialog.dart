import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/map_controller.dart';
import '../controllers/report_controller.dart';
import '../widgets/input_text_field.dart';
import 'package:easy_localization/easy_localization.dart';

class ReportDialog extends StatefulWidget {
  final MapController mapController;

  const ReportDialog({Key? key, required this.mapController}) : super(key: key);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  List<XFile> _imageFiles = [];
  final ReportController _reportController = ReportController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _pickImages() async {
    final imagePicker = ImagePicker();
    final pickedFiles = await imagePicker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('report_dialog.title'.tr()),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: widget.mapController.redMarker != null
                      ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.mapController.redMarker!.position,
                      zoom: 15,
                    ),
                    markers: {widget.mapController.redMarker!},
                  )
                      : Icon(Icons.map, size: 100, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                InputTextField(
                  labelText: 'report_dialog.title_label'.tr(),
                  hintText: 'report_dialog.enter_title'.tr(),
                  icon: Icons.title,
                  onChanged: (value) => _titleController.text = value,
                ),
                SizedBox(height: 10),
                InputTextField(
                  labelText: 'report_dialog.description_label'.tr(),
                  hintText: 'report_dialog.enter_description'.tr(),
                  icon: Icons.description,
                  onChanged: (value) => _descriptionController.text = value,
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    ..._imageFiles.map((file) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: FileImage(File(file.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.add_photo_alternate, size: 30),
                          onPressed: _pickImages,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: _isSubmitting
                ? CircularProgressIndicator()
                : TextButton(
              child: Text('report_dialog.submit_report'.tr()),
              onPressed: widget.mapController.redMarker != null
                  ? () async {
                setState(() {
                  _isSubmitting = true;
                });

                String title = _titleController.text;
                String description = _descriptionController.text;
                DateTime date = DateTime.now();
                List<String> imagePaths = _imageFiles.map((file) => file.path).toList();
                LatLng location = widget.mapController.redMarker!.position;

                await _reportController.uploadReport(context, title, description, date, imagePaths, location);

                setState(() {
                  widget.mapController.clearRedMarker();
                  _imageFiles.clear();
                  _titleController.clear();
                  _descriptionController.clear();
                  _isSubmitting = false;
                });

                context.pop();
              }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
