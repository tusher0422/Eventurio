import 'package:eventurio/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late Event event;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  String _category = "Music Concert";
  bool _isPaid = false;
  double? _price;
  DateTime? _selectedDate;

  final eventController = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    final eventId = Get.parameters['id'];
    event = eventController.events.firstWhere((e) => e.id == eventId);

    _titleController.text = event.title;
    _descController.text = event.description;
    _locationController.text = event.location;
    _category = event.category;
    _isPaid = event.isPaid;
    _price = event.price;
    _selectedDate = event.date;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) return;

    final updated = event.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _category,
      isPaid: _isPaid,
      price: _isPaid ? _price : null,
      date: _selectedDate,
      location: _locationController.text.trim(),
    );

    await eventController.updateEvent(updated);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (val) => val!.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (val) => val!.isEmpty ? "Enter a description" : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (val) => val!.isEmpty ? "Enter a location" : null,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: "Music Concert", child: Text("Music Concert")),
                  DropdownMenuItem(value: "Dance Show", child: Text("Dance Show")),
                  DropdownMenuItem(value: "Cultural Program", child: Text("Cultural Program")),
                  DropdownMenuItem(value: "Workshop", child: Text("Workshop")),
                ],
                onChanged: (val) => setState(() => _category = val!),
                decoration: const InputDecoration(labelText: "Category"),
              ),
              Row(
                children: [
                  const Text("Paid Event?"),
                  Switch(
                    value: _isPaid,
                    onChanged: (val) => setState(() => _isPaid = val),
                  ),
                ],
              ),
              if (_isPaid)
                TextFormField(
                  initialValue: _price?.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                  onChanged: (val) => _price = double.tryParse(val),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "No date chosen"
                          : "Date: ${_selectedDate!.toLocal()}".split(" ")[0],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _submit();
                  Get.toNamed(Routes.home);
                },
                child: const Text("Update Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
