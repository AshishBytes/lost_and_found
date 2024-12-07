import 'package:flutter/material.dart';
import 'package:lost_and_found/data/list_of_items_dummy.dart';
import 'package:lost_and_found/model/item.dart';
import 'package:lost_and_found/model/user.dart';
import 'package:lost_and_found/screens/add_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListOfItems>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('The Losts & Founds'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
                text: 'Lost',
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
                text: 'Founds',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildItemListView(provider, false), // Lost Items
            _buildItemListView(provider, true),  // Found Items
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newItem = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddItem(user: widget.user),
              ),
            );

            if (newItem != null) {
              // No need to add again; provider already handles this
              setState(() {});
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildItemListView(ListOfItems provider, bool isFound) {
    final items = provider.itemList.where((item) => item.type == isFound).toList();

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            title: Text(item.itemName),
            subtitle: Text(item.itemDescription),
            leading: Image.memory(item.imageBytes, width: 50, height: 50),
          ),
        );
      },
    );
  }
}