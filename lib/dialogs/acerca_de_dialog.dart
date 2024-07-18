import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AcercaDeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'about_dialog.title'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Color(0xFF1A237E)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'about_dialog.description'.tr(),
              style: TextStyle(fontSize: 16, color: Color(0xFF424242)),
            ),
            SizedBox(height: 24),
            Text(
              'about_dialog.features_title'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 8),
            _buildFeature('about_dialog.feature_1'.tr()),
            _buildFeature('about_dialog.feature_2'.tr()),
            _buildFeature('about_dialog.feature_3'.tr()),
            _buildFeature('about_dialog.feature_4'.tr()),
            SizedBox(height: 24),
            Text(
              'about_dialog.contact_title'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'about_dialog.contact_email'.tr(),
              style: TextStyle(fontSize: 16, color: Color(0xFF424242)),
            ),
            Text(
              'about_dialog.contact_phone'.tr(),
              style: TextStyle(fontSize: 16, color: Color(0xFF424242)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: Color(0xFF00C853)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Color(0xFF424242)),
            ),
          ),
        ],
      ),
    );
  }
}
