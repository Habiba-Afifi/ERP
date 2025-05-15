import 'package:flutter/material.dart';
import '../models/sku_model.dart'; // Changed to relative import
import '../services/mock_backend.dart'; // Changed to relative import
import '../widgets/sku_card.dart'; // Changed to relative import

class SKUSelectionDialog extends StatefulWidget {
  const SKUSelectionDialog({super.key});

  @override
  State<SKUSelectionDialog> createState() => _SKUSelectionDialogState();
}

class _SKUSelectionDialogState extends State<SKUSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<SKU> _skus = [];
  List<SKU> _filteredSkus = [];

  @override
  void initState() {
    super.initState();
    _loadSKUs();
    _searchController.addListener(_filterSKUs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSKUs() {
    setState(() {
      _skus = MockBackend().getAllSKUs();
      _filteredSkus = _skus;
    });
  }

  void _filterSKUs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSkus = _skus.where((sku) {
        return sku.code.toLowerCase().contains(query) ||
            sku.name.toLowerCase().contains(query) ||
            sku.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AppBar(
            title: const Text('Select SKU'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search SKUs',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: const Color(0xFFf7f7f7),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredSkus.length,
              itemBuilder: (context, index) {
                final sku = _filteredSkus[index];
                return InkWell(
                  onTap: () => Navigator.pop(context, sku),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SKUCard(sku: sku),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
