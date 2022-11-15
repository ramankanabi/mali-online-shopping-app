import 'package:intl/intl.dart';

class Advertise {
  final String advertiseTitle;
  final String advertiseId;
  final DateTime duration;
  final int timeToEnd;
  final String imageCover;

  Advertise({
    required this.advertiseTitle,
    required this.advertiseId,
    required this.duration,
    required this.timeToEnd,
    required this.imageCover,
  });

  factory Advertise.fromJson(Map<String, dynamic> extractedData) {
    return Advertise(
      advertiseTitle: extractedData["advertiseTitle"],
      advertiseId: extractedData["_id"],
      duration: DateTime.parse(DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(extractedData["duration"]))),
      timeToEnd: DateTime.parse(extractedData["duration"])
          .difference(DateTime.now())
          .inSeconds,
      imageCover: extractedData["imageCover"],
    );
  }
}
