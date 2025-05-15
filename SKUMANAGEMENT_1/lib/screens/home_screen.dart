import 'package:flutter/material.dart';
import 'stock_level_screen.dart'; // Changed to relative import
import 'stock_adjustment_screen.dart'; // Changed to relative import
import 'reorder_alert_screen.dart'; // Changed to relative import
import 'stock_transfer_screen.dart'; // Changed to relative import
import 'branch_stock_screen.dart'; // Changed to relative import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SKU Management System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          children: [
            _buildFeatureCard(
              context,
              Icons.inventory,
              'Stock Level Tracking',
              const Color(0xFF837b5f),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StockLevelScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              Icons.edit,
              'Stock Adjustment',
              const Color(0xFFc7896a),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StockAdjustmentScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              Icons.notifications,
              'Reorder Alerts',
              const Color(0xFFb99a45),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReorderAlertScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              Icons.transfer_within_a_station,
              'Stock Transfer',
              const Color(0xFF5c4e2e),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StockTransferScreen()),
              ),
            ),
            _buildFeatureCard(
              context,
              Icons.store,
              'Branch Stock',
              const Color(0xFF837b5f),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BranchStockScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
