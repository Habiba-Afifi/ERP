import 'package:flutter/material.dart';
import '../models/sku_model.dart';
import '../services/mock_backend.dart';
import '../widgets/sku_selection_dialog.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  SKU? _selectedSKU;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
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
      });
    }
  }

  void _submitAdjustment() {
    if (_selectedSKU == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an SKU')),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reason')),
      );
      return;
    }

    MockBackend().adjustStock(
      _selectedSKU!.id,
      quantity,
      _reasonController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stock adjusted for ${_selectedSKU!.name}')),
    );

    setState(() {
      _selectedSKU = null;
      _quantityController.clear();
      _reasonController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Adjustment'),
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
                      'Adjustment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5c4e2e),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintText:
                            'Positive for addition, negative for deduction',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason',
                        hintText: 'Damage, return, correction, etc.',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitAdjustment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff9c9381),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit Adjustment'),
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
