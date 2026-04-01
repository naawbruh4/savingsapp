import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/saving.dart';
import 'add_saving_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Saving> _savings = [];

  @override
  void initState() {
    super.initState();
    _loadSavings();
  }

  Future<void> _loadSavings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('savings') ?? [];
    setState(() {
      _savings = data
          .map((e) => Saving.fromMap(jsonDecode(e)))
          .toList();
    });
  }

  Future<void> _saveSavings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _savings.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('savings', data);
  }

  void _deleteSaving(String id) {
    setState(() {
      _savings.removeWhere((s) => s.id == id);
    });
    _saveSavings();
  }

  void _addDeposit(Saving saving) async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add to ${saving.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, double.tryParse(controller.text)),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result > 0) {
      setState(() {
        final index = _savings.indexWhere((s) => s.id == saving.id);
        _savings[index] = saving.copyWith(
          currentAmount: saving.currentAmount + result,
        );
      });
      _saveSavings();
    }
  }

  String _formatAmount(double amount, String currencyCode) {
    final format = NumberFormat.simpleCurrency(name: currencyCode);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Savings'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: _savings.isEmpty
          ? const Center(
              child: Text('No savings yet. Tap + to create one!'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _savings.length,
              itemBuilder: (ctx, i) {
                final s = _savings[i];
                final progress = s.targetAmount > 0
                    ? (s.currentAmount / s.targetAmount).clamp(0.0, 1.0)
                    : 0.0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(s.name,
                                style: Theme.of(context).textTheme.titleMedium),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteSaving(s.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatAmount(s.currentAmount, s.currencyCode)} / ${_formatAmount(s.targetAmount, s.currencyCode)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              s.frequency.toUpperCase(),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            TextButton(
                              onPressed: () => _addDeposit(s),
                              child: const Text('+ Add Money'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newSaving = await Navigator.push<Saving>(
            context,
            MaterialPageRoute(builder: (_) => const AddSavingScreen()),
          );
          if (newSaving != null) {
            setState(() => _savings.add(newSaving));
            _saveSavings();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
