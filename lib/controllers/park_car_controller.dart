import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/park_car_model.dart';

class ParkMyCarController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> checkBooking(ParkMyCarModel parkMyCar) async {
    try {
      // Check if there is a booking for the selected date and plate number
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('bookingDate', isEqualTo: parkMyCar.selectedDate)
          .where('carPlateNumber', isEqualTo: parkMyCar.plateNumber)
          .get();

      if (bookingsSnapshot.docs.isNotEmpty) {
        // There is a booking for the car on the selected date
        return 'Car is booked for the selected date';
      } else {
        // No booking found for the car on the selected date
        return 'No booking found for the car on the selected date';
      }
    } catch (e) {
      return e.toString(); // Return error message if check fails
    }
  }

  Future<String> removeCar(ParkMyCarModel parkMyCar) async {
    try {
      // Remove the booking for the car on the selected date
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('bookingDate', isEqualTo: parkMyCar.selectedDate)
          .where('carPlateNumber', isEqualTo: parkMyCar.plateNumber)
          .get();

      if (bookingsSnapshot.docs.isNotEmpty) {
        // Remove the booking document from Firestore
        await _firestore
            .collection('bookings')
            .doc(bookingsSnapshot.docs.first.id)
            .delete();
        return 'Car removed from parking space';
      } else {
        return 'No booking found for the car on the selected date';
      }
    } catch (e) {
      return e.toString(); // Return error message if removal fails
    }
  }

  // Function to send push notification
  Future<void> sendPushNotification(String message) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String serverKey = 'YOUR_SERVER_KEY'; // Replace with your FCM server key
      String deviceId =
          'YOUR_DEVICE_ID'; // Replace with the recipient's device token

      // Construct the message payload
      var payload = <String, dynamic>{
        'notification': {
          'title': 'Car Parking',
          'body': message,
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done'
        },
      };

      // Send the notification
      await messaging.sendMessage(
        to: deviceId,
        data: payload as dynamic,
      );
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
}
