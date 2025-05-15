class SKU {
  final String id;
  final String code;
  final String name;
  final String description;
  final int currentStock;
  final int reservedStock;
  final int reorderThreshold;
  final String branchId;
  final String branchName;

  SKU({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.currentStock,
    required this.reservedStock,
    required this.reorderThreshold,
    required this.branchId,
    required this.branchName,
  });

  bool get needsReorder => currentStock < reorderThreshold;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'currentStock': currentStock,
      'reservedStock': reservedStock,
      'reorderThreshold': reorderThreshold,
      'branchId': branchId,
      'branchName': branchName,
    };
  }

  factory SKU.fromMap(Map<String, dynamic> map) {
    return SKU(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      description: map['description'],
      currentStock: map['currentStock'],
      reservedStock: map['reservedStock'],
      reorderThreshold: map['reorderThreshold'],
      branchId: map['branchId'],
      branchName: map['branchName'],
    );
  }
}

class StockAdjustment {
  final String id;
  final String skuId;
  final int quantity;
  final String reason;
  final DateTime date;

  StockAdjustment({
    required this.id,
    required this.skuId,
    required this.quantity,
    required this.reason,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skuId': skuId,
      'quantity': quantity,
      'reason': reason,
      'date': date.toIso8601String(),
    };
  }

  factory StockAdjustment.fromMap(Map<String, dynamic> map) {
    return StockAdjustment(
      id: map['id'],
      skuId: map['skuId'],
      quantity: map['quantity'],
      reason: map['reason'],
      date: DateTime.parse(map['date']),
    );
  }
}

class StockTransfer {
  final String id;
  final String skuId;
  final String sourceLocation;
  final String destinationLocation;
  final int quantity;
  final DateTime date;

  StockTransfer({
    required this.id,
    required this.skuId,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.quantity,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'skuId': skuId,
      'sourceLocation': sourceLocation,
      'destinationLocation': destinationLocation,
      'quantity': quantity,
      'date': date.toIso8601String(),
    };
  }

  factory StockTransfer.fromMap(Map<String, dynamic> map) {
    return StockTransfer(
      id: map['id'],
      skuId: map['skuId'],
      sourceLocation: map['sourceLocation'],
      destinationLocation: map['destinationLocation'],
      quantity: map['quantity'],
      date: DateTime.parse(map['date']),
    );
  }
}
