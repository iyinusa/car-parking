import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/session.dart';
import '../models/booking_model.dart';

class BookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Session sess = Session();

  Future<String> bookSpace(BookingModel booking) async {
    try {
      // format date
      final date = booking.bookingDate.toString().split(' ')[0];

      // Check if the selected space is available for the chosen date
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('spaceId', isEqualTo: booking.spaceId)
          .where('bookingDate', isEqualTo: date)
          .get();

      if (bookingsSnapshot.docs.isNotEmpty) {
        return 'Space is already booked for the selected date'; // Return error message if space is not available
      }

      final uID = await sess.getData('string', 'uID'); // get user ID

      // If space is available, save the booking information to Firestore
      final resp = await _firestore.collection('bookings').add({
        'userId': uID,
        'spaceId': booking.spaceId,
        'bookingDate': date,
        'carPlateNumber': booking.carPlateNumber,
        // You can add more booking information fields as needed
      });

      return 'Successful!'; // Return null if booking succeeds
    } catch (e) {
      return e.toString(); // Return error message if booking fails
    }
  }
}
