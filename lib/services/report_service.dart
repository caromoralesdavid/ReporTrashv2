import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import '../controllers/auth_controller.dart';
import '../utils/logger.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthController _authController = AuthController();

  Future<List<String>> uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];

    for (String imagePath in imagePaths) {
      String fileName = path.basename(imagePath);
      Reference ref = _storage.ref().child('reports/$fileName');
      UploadTask uploadTask = ref.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<void> uploadReport(
      String title,
      String description,
      DateTime date,
      List<String> imagePaths,
      LatLng location,
      ) async {
    try {
      User? user = await _authController.getCurrentUser();
      if (user != null) {
        List<String> imageUrls = await uploadImages(imagePaths);
        await _firestore.collection('reports').add({
          'title': title,
          'description': description,
          'date': date,
          'imageUrls': imageUrls,
          'location': GeoPoint(location.latitude, location.longitude),
          'uid': user.uid,
        });
        Logger.log('Report uploaded successfully for user: ${user.uid}');
      } else {
        Logger.log('No user logged in. Unable to upload report.');
      }
    } catch (e, stackTrace) {
      Logger.logError('Error uploading report', error: e, stackTrace: stackTrace);
    }
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    QuerySnapshot snapshot = await _firestore.collection('reports').get();
    List<Map<String, dynamic>> reports = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic> reportData = doc.data() as Map<String, dynamic>;
      String userId = reportData['uid'];

      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        String userName = userData['fullName'];
        reportData['userName'] = userName;
      }

      reports.add(reportData);
    }

    return reports;
  }

  Future<List<Map<String, dynamic>>> getReportsForUser() async {
    User? user = await _authController.getCurrentUser();
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('reports')
          .where('uid', isEqualTo: user.uid)
          .get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    }
    return [];
  }

}
