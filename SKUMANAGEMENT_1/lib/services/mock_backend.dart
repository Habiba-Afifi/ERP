import 'package:flutter/material.dart';
import '../models/sku_model.dart';

class MockBackend {
  static final MockBackend _instance = MockBackend._internal();
  factory MockBackend() => _instance;
  MockBackend._internal();

  final List<SKU> _skus = [
    SKU(
      id: '1',
      code: 'SKU-001',
      name: 'Premium Coffee Beans',
      description: 'Arabica beans from Colombia',
      currentStock: 45,
      reservedStock: 5,
      reorderThreshold: 50,
      branchId: '1',
      branchName: 'Main Warehouse',
    ),
    SKU(
      id: '2',
      code: 'SKU-002',
      name: 'Ceramic Coffee Mug',
      description: '12oz ceramic mug with handle',
      currentStock: 120,
      reservedStock: 20,
      reorderThreshold: 100,
      branchId: '1',
      branchName: 'Main Warehouse',
    ),
    SKU(
      id: '3',
      code: 'SKU-003',
      name: 'Paper Coffee Cups',
      description: '16oz disposable cups',
      currentStock: 80,
      reservedStock: 30,
      reorderThreshold: 150,
      branchId: '2',
      branchName: 'Downtown Branch',
    ),
    SKU(
      id: '4',
      code: 'SKU-004',
      name: 'Coffee Filters',
      description: '#4 cone-shaped filters',
      currentStock: 25,
      reservedStock: 5,
      reorderThreshold: 30,
      branchId: '2',
      branchName: 'Downtown Branch',
    ),
  ];

  final List<StockAdjustment> _adjustments = [];
  final List<StockTransfer> _transfers = [];

  // Stock Level Tracking
  SKU? getSKUByCode(String code) {
    return _skus.firstWhere((sku) => sku.code == code);
  }

  // Stock Adjustment
  void adjustStock(String skuId, int quantity, String reason) {
    final sku = _skus.firstWhere((s) => s.id == skuId);
    final newStock = sku.currentStock + quantity;

    _skus[_skus.indexOf(sku)] = sku.copyWith(currentStock: newStock);
    _adjustments.add(StockAdjustment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      skuId: skuId,
      quantity: quantity,
      reason: reason,
      date: DateTime.now(),
    ));

    if (newStock < sku.reorderThreshold) {
      _triggerReorderAlert(sku);
    }
  }

  // Reorder Alert
  void _triggerReorderAlert(SKU sku) {
    debugPrint(
        'Reorder alert for ${sku.name} (${sku.code}) - Current stock: ${sku.currentStock}');
    // In a real app, this would trigger email/webhook/etc.
  }

  // Stock Transfer
  void transferStock({
    required String skuId,
    required String sourceLocation,
    required String destinationLocation,
    required int quantity,
  }) {
    final sku =
        _skus.firstWhere((s) => s.id == skuId && s.branchId == sourceLocation);
    if (sku.currentStock < quantity) {
      throw Exception('Insufficient stock for transfer');
    }

    _skus[_skus.indexOf(sku)] =
        sku.copyWith(currentStock: sku.currentStock - quantity);

    // Find or create destination SKU
    try {
      final destSku = _skus.firstWhere(
          (s) => s.id == skuId && s.branchId == destinationLocation);
      _skus[_skus.indexOf(destSku)] =
          destSku.copyWith(currentStock: destSku.currentStock + quantity);
    } catch (e) {
      // If SKU doesn't exist at destination, create it
      _skus.add(sku.copyWith(
        branchId: destinationLocation,
        branchName:
            destinationLocation == '1' ? 'Main Warehouse' : 'Downtown Branch',
        currentStock: quantity,
        reservedStock: 0,
      ));
    }

    _transfers.add(StockTransfer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      skuId: skuId,
      sourceLocation: sourceLocation,
      destinationLocation: destinationLocation,
      quantity: quantity,
      date: DateTime.now(),
    ));
  }

  // Branch-Specific Stock
  List<SKU> getStockByBranch(String branchId) {
    return _skus.where((sku) => sku.branchId == branchId).toList();
  }

  // Get all SKUs
  List<SKU> getAllSKUs() => _skus;

  // Get all adjustments
  List<StockAdjustment> getAllAdjustments() => _adjustments;

  // Get all transfers
  List<StockTransfer> getAllTransfers() => _transfers;
}

extension SKUCopy on SKU {
  SKU copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    int? currentStock,
    int? reservedStock,
    int? reorderThreshold,
    String? branchId,
    String? branchName,
  }) {
    return SKU(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      currentStock: currentStock ?? this.currentStock,
      reservedStock: reservedStock ?? this.reservedStock,
      reorderThreshold: reorderThreshold ?? this.reorderThreshold,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
    );
  }
}
