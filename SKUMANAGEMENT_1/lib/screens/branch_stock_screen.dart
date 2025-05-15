import 'package:flutter/material.dart';
import '../models/sku_model.dart'; // Changed to relative import
import '../services/mock_backend.dart'; // Changed to relative import
import '../widgets/sku_card.dart'; // Changed to relative import

class BranchStockScreen extends StatefulWidget {
  const BranchStockScreen({super.key});

  @override
  State<BranchStockScreen> createState() => _BranchStockScreenState();
}

class _BranchStockScreenState extends State<BranchStockScreen> {
  String? _selectedBranch;
  List<SKU> _branchSkus = [];

  @override
  void initState() {
    super.initState();
    _selectedBranch = '1';
    _loadBranchSKUs();
  }

  void _loadBranchSKUs() {
    if (_selectedBranch == null) return;

    setState(() {
      _branchSkus = MockBackend().getStockByBranch(_selectedBranch!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Stock'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: _selectedBranch,
                items: const [
                  DropdownMenuItem(
                    value: '1',
                    child: Text('Main Warehouse'),
                  ),
                  DropdownMenuItem(
                    value: '2',
                    child: Text('Downtown Branch'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedBranch = value;
                    _loadBranchSKUs();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Branch',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: _branchSkus.isEmpty
                ? const Center(
                    child: Text(
                      'No items in this branch',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _branchSkus.length,
                    itemBuilder: (context, index) {
                      final sku = _branchSkus[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SKUCard(sku: sku),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
