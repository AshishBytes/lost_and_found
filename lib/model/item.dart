import 'dart:typed_data';
import 'package:lost_and_found/model/user.dart';

class Item {
  final Uint8List imageBytes;
  final String itemName;
  final String itemDescription;
  final String location;
  final User user;
  final DateTime dateTime = DateTime.now();
  final bool type; // true for found, false for lost

  Item({
    required this.imageBytes,
    required this.itemName,
    required this.itemDescription,
    required this.location,
    required this.user,
    required this.type,
  });
}
