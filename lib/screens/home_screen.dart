import 'package:flutter/material.dart';
import '../models/item.dart';
import 'item_form_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];

  void _addItem(Item item) {
    setState(() {
      items.add(item);
    });
  }

  void _editItem(String id, Item newItem) {
    setState(() {
      int index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        items[index] = newItem;
      }
    });
  }

  void _deleteItem(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  void _navigateToAddItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemFormScreen(
          onSave: (item) => _addItem(item),
        ),
      ),
    );
  }

  void _navigateToEditItem(Item item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemFormScreen(
          item: item,
          onSave: (newItem) => _editItem(item.id, newItem),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD App'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Formatear la fecha del último campeonato
          String formattedLastChampDate = DateFormat('yyyy-MM-dd').format(item.lastChampDate);

          return ListTile(
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${item.id}'),
                Text('Founded: ${item.foundingYear.toString()}'),
                Text('Last Champ: $formattedLastChampDate'),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToEditItem(item),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteItem(item.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
