import 'package:flutter/material.dart';
import '../models/sku_model.dart'; // Changed to relative import

class SKUCard extends StatelessWidget {
  final SKU sku;

  const SKUCard({super.key, required this.sku});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sku.code,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5c4e2e),
                  ),
                ),
                if (sku.needsReorder)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFb99a45).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFb99a45),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Reorder Needed',
                      style: TextStyle(
                        color: Color(0xFF5c4e2e),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              sku.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sku.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStockInfo('Current', sku.currentStock),
                const SizedBox(width: 16),
                _buildStockInfo('Reserved', sku.reservedStock),
                const SizedBox(width: 16),
                _buildStockInfo('Reorder At', sku.reorderThreshold),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Branch: ${sku.branchName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockInfo(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5c4e2e),
          ),
        ),
      ],
    );
  }
}
