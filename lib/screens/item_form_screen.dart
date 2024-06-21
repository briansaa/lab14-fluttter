import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/item.dart';
import 'package:intl/intl.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;
  final Function(Item) onSave;

  ItemFormScreen({this.item, required this.onSave});

  @override
  _ItemFormScreenState createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _foundingYear;
  late DateTime _lastChampDate;

  @override
  void initState() {
    super.initState();
    _name = widget.item?.name ?? '';
    _foundingYear = widget.item?.foundingYear ?? DateTime.now().year;
    _lastChampDate = widget.item?.lastChampDate ?? DateTime.now();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final id = widget.item?.id ?? Uuid().v4();
      final newItem = Item(
        id: id,
        name: _name,
        foundingYear: _foundingYear,
        lastChampDate: _lastChampDate,
      );
      widget.onSave(newItem);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _foundingYear == DateTime.now().year ? '' : _foundingYear.toString(),
                decoration: InputDecoration(labelText: 'Founding Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the founding year';
                  }
                  int? year = int.tryParse(value);
                  if (year! < 1900 || year > DateTime.now().year) {
                    return 'Please enter a valid founding year';
                  }
                  return null;
                },
                onSaved: (value) {
                  _foundingYear = int.parse(value!);
                },
              ),
              TextFormField(
                controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_lastChampDate)),
                decoration: InputDecoration(labelText: 'Last Championship Date'),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _lastChampDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _lastChampDate = selectedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the last championship date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
