import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:lost_and_found/model/user.dart';
import 'package:lost_and_found/model/item.dart';

class ListOfItems extends ChangeNotifier {
  final List<User> users;

  List<Item> items = [];

  ListOfItems()
      : users = [
          User(
            email: "ashishlodhi5559@gmail.com",
            username: "Ashish Singh",
            password: "ashish59",
            phoneNo: '7723883598',
          ),
          User(
            email: "ashish@gmail.com",
            username: "ashish",
            password: "ashish",
            phoneNo: '123456789',
          ),
          User(
            email: "a",
            username: "Ashish Singh",
            password: "a",
            phoneNo: 'a',
          ),
        ];

  List<Item> get itemList {
    return items;
  }

  List<User> get userList {
    return users;
  }

  Future<void> initializeItems() async {
    items = [
      Item(
        imageBytes: await getImageBytesFromAssets("images/nokia.jpg"),
        itemName: "Nokia SuperSonic 5G 1",
        itemDescription: "White and Blue Nokia with small screen and old number pad",
        location: "Lost in FTKKI",
        user: users[1],
        type: false,
      ),
      Item(
        imageBytes: await getImageBytesFromAssets("images/nokia.jpg"),
        itemName: "Nokia SuperSonic 5G 2",
        itemDescription: "White and Blue Nokia with small screen and old number pad",
        location: "Lost in FTKKI",
        user: users[0],
        type: true,
      ),
    ];
    notifyListeners();
  }

  Future<Uint8List> getImageBytesFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    return byteData.buffer.asUint8List();
  }

  void deleteItem(Item item) {
    items.remove(item);
    notifyListeners();
  }

  void addItem(Item item) {
    items.add(item);
    notifyListeners();
  }

  void updateItem(Item item, int index) {
    items[index] = item;
    notifyListeners();
  }

  // Add this method
  void addUser(User user) {
    users.add(user);
    notifyListeners();
  }
}