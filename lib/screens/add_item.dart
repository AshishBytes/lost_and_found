import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/data/list_of_items_dummy.dart';
import 'package:lost_and_found/model/item.dart';
import 'package:lost_and_found/model/user.dart';
import 'package:provider/provider.dart';

class AddItem extends StatefulWidget {
  final User user;
  const AddItem({super.key, required this.user});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescController = TextEditingController();
  final TextEditingController _itemLocController = TextEditingController();
  bool isFoundSelected = true;
  Uint8List? _selectedImageBytes;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListOfItems>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => isFoundSelected = false),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: !isFoundSelected ? Colors.blue : Colors.grey,
                        child: const Text('Lost', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => isFoundSelected = true),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: isFoundSelected ? Colors.green : Colors.grey,
                        child: const Text('Found', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(labelText: 'Item Name *'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter the item name' : null,
                ),
                TextFormField(
                  controller: _itemDescController,
                  decoration: const InputDecoration(labelText: 'Description *'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: _itemLocController,
                  decoration: const InputDecoration(labelText: 'Location *'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter the location' : null,
                ),
                Row(
                  children: [
                    const Text('Pick Image:'),
                    TextButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: const Text("Gallery"),
                    ),
                    TextButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: const Text("Camera"),
                    ),
                  ],
                ),
                if (_selectedImageBytes != null)
                  Image.memory(_selectedImageBytes!, width: 150, height: 150),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedImageBytes != null) {
                      final newItem = Item(
                        imageBytes: _selectedImageBytes!,
                        itemName: _itemNameController.text,
                        itemDescription: _itemDescController.text,
                        location: _itemLocController.text,
                        user: widget.user,
                        type: isFoundSelected,
                      );

                      // Add item to the provider
                      provider.addItem(newItem);

                      // Close only once
                      Navigator.of(context).pop(newItem);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }
}