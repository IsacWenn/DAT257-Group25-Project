import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'caffeine.dart';


class CaffeineRepository {
  final CollectionReference instance =
      FirebaseFirestore.instance.collection('ConsumptionHistory');

  /// Returns the current caffeine level
  Future<Caffeine> fetchCurrentCaffeine() async {

    final today = DateTime.now();
    final startOfToday = Timestamp.fromDate(
        DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0));

    final endOfToday = Timestamp.fromDate(
        DateTime(today.year, today.month, today.day, 23, 59, 59, 999, 999));

    /// Get all the caffeine consumed today
    final QuerySnapshot querySnapshot = await instance
        .where('timeConsumed', isGreaterThanOrEqualTo: startOfToday)
        .where('timeConsumed', isLessThanOrEqualTo: endOfToday)
        .get();

    final total = getTotalCaffeine(querySnapshot);
    final status = _getStatus(total);

    return Caffeine(amount: total, status: status);
  }

  /// Returns the status of the caffeine level.
  /// This is calculated by taking the total amount of caffeine consumed today
  /// and comparing it to the thresholds.
  String _getStatus(double total) {
    String status;

    if (total < 50) {
      status = "Low";
    } else if (total >= 50 && total < 150) {
      status = "Medium";
    } else if (total >= 150) {
      status = "High";
    } else {
      status = "Error";
    }

    return status;
  }

  /// Returns the total amount of caffeine consumed today.
  /// This is calculated by taking the amount of caffeine consumed and
  /// using the half life formula to calculate the amount of caffeine in the body.
  double getTotalCaffeine(QuerySnapshot<Object?> snapshot) {
    double total = 0;
    for (QueryDocumentSnapshot<Object?> doc in snapshot.docs) {
      final secondElapsed = doc['timeConsumed'].seconds.toDouble();

      final amountCaffeine = doc['amountConsumed'];

      DateTime currentTime = DateTime.now();
      DateTime storedTime =
          DateTime.fromMillisecondsSinceEpoch(secondElapsed.toInt() * 1000);

      Duration timePassed = currentTime.difference(storedTime);

      int secondsPassed = timePassed.inSeconds + 1;

      final numberOfHalfs = (secondsPassed / (5 * 60 * 60));

      total += amountCaffeine * math.pow(0.5, numberOfHalfs);
    }

    return total;
  }

  /// Adds a new caffeine consumption to the database
  Future<void> addConsumedCaffeine(String userId, int caffeineLevel) async {
    try {
      await FirebaseFirestore.instance.collection('ConsumptionHistory').add({
        'userId': userId,
        'amountConsumed': caffeineLevel,
        'timeConsumed': FieldValue.serverTimestamp(),
      });
      print('Document added successfully!');
    } catch (e) {
      print('Error adding document: $e');
    }
  }
}