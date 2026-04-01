import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/saving.dart';

class AddSavingScreen extends StatefulWidget {
  const AddSavingScreen({super.key});

  @override
  State<AddSavingScreen> createState() => _AddSavingScreenState();
}

class _AddSavingScreenState extends State<AddSavingScreen> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  String _selectedFrequency = 'monthly';
  String _selectedCurrency = 'USD';

  final List<String> _frequencies = ['daily', 'weekly', 'monthly', 'yearly'];

  final List<String> _currencies = NumberFormat.simpleCurrency()
      .numberSymbols
      .keys
      .toList()
    ..sort();

  void _submit() {
    final name = _nameController.text.trim();
    final target = double.tryParse(_targetController.text);

    if (name.isEmpty || target == null || target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    final saving = Saving(
      id: const Uuid().v4(),
      name: name,
      targetAmount: target,
      currentAmount: 0,
      currencyCode: _selectedCurrency,
      frequency: _selectedFrequency,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, saving);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Saving')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Saving Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Amount',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedFrequency,
            decoration: const InputDecoration(
              labelText: 'Frequency',
              border: OutlineInputBorder(),
            ),
            items: _frequencies
                .map((f) => DropdownMenuItem(
                      value: f,
                      child: Text(f[0].toUpperCase() + f.substring(1)),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedFrequency = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCurrency,
            decoration: const InputDecoration(
              labelText: 'Currency',
              border: OutlineInputBorder(),
            ),
            items: _currencies
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedCurrency = v!),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            child: const Text('Create Saving'),
          ),
        ],
      ),
    );
  }
}
