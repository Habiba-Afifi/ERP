import 'package:flutter/material.dart';
import '../models/sku_model.dart';
import '../services/mock_backend.dart';
import '../widgets/sku_selection_dialog.dart';

class StockTransferScreen extends StatefulWidget {
  const StockTransferScreen({super.key});

  @override
  State<StockTransferScreen> createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen> {
  final TextEditingController _quantityController = TextEditingController();
  SKU? _selectedSKU;
  String? _sourceBranch;
  String? _destinationBranch;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectSKU(BuildContext context) async {
    final sku = await showDialog<SKU>(
      context: context,
      builder: (context) => const SKUSelectionDialog(),
    );

    if (sku != null) {
      setState(() {
        _selectedSKU = sku;
        _sourceBranch = sku.branchId;
        _destinationBranch = sku.branchId == '1' ? '2' : '1';
      });
    }
  }

  void _submitTransfer() {
    if (_selectedSKU == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an SKU')),
      );
      return;
    }

    if (_sourceBranch == null || _destinationBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select source and destination')),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    try {
      MockBackend().transferStock(
        skuId: _selectedSKU!.id,
        sourceLocation: _sourceBranch!,
        destinationLocation: _destinationBranch!,
        quantity: quantity,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer completed for ${_selectedSKU!.name}')),
      );

      setState(() {
        _selectedSKU = null;
        _sourceBranch = null;
        _destinationBranch = null;
        _quantityController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select SKU',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5c4e2e),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectSKU(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(width: 8),
                            Text(
                              _selectedSKU?.name ?? 'Tap to select SKU',
                              style: TextStyle(
                                color: _selectedSKU != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedSKU != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Current Stock: ${_selectedSKU!.currentStock}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current Location: ${_selectedSKU!.branchName}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transfer Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5c4e2e),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedSKU != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('From:'),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: _sourceBranch,
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
                                      _sourceBranch = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('To:'),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: _destinationBranch,
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
                                      _destinationBranch = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitTransfer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff9c9381),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit Transfer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
