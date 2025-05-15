import 'package:flutter/material.dart';
import '../models/sku_model.dart'; // Changed to relative import
import '../services/mock_backend.dart'; // Changed to relative import
import '../widgets/sku_card.dart'; // Changed to relative import

class ReorderAlertScreen extends StatefulWidget {
  const ReorderAlertScreen({super.key});

  @override
  State<ReorderAlertScreen> createState() => _ReorderAlertScreenState();
}

class _ReorderAlertScreenState extends State<ReorderAlertScreen> {
  List<SKU> _reorderSkus = [];

  @override
  void initState() {
    super.initState();
    _loadReorderSKUs();
  }

  void _loadReorderSKUs() {
    setState(() {
      _reorderSkus =
          MockBackend().getAllSKUs().where((sku) => sku.needsReorder).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder Alerts'),
      ),
      body: _reorderSkus.isEmpty
          ? const Center(
              child: Text(
                'No items need reordering',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reorderSkus.length,
              itemBuilder: (context, index) {
                final sku = _reorderSkus[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SKUCard(sku: sku),
                );
              },
            ),
    );
  }
}
