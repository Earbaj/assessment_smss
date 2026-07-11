class CostRowModel {
  final String provider;
  final String totalCost;

  const CostRowModel({required this.provider, required this.totalCost});

  factory CostRowModel.fromJson(Map<String, dynamic> json) {
    return CostRowModel(
      provider: json['provider'] ?? 'UNKNOWN',
      totalCost: json['totalCost']?.toString() ?? '0.0000',
    );
  }
}

class CostBreakdownModel {
  final List<CostRowModel> rows;

  const CostBreakdownModel({required this.rows});

  factory CostBreakdownModel.fromJson(Map<String, dynamic> json) {
    final list = json['rows'] as List<dynamic>? ?? [];
    return CostBreakdownModel(
      rows: list.map((e) => CostRowModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
