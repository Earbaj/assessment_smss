class CostRow {
  final String provider;
  final String totalCost;

  const CostRow({
    required this.provider,
    required this.totalCost,
  });
}

class CostBreakdown {
  final List<CostRow> rows;
  final String totalCostSum;

  const CostBreakdown({
    required this.rows,
    required this.totalCostSum,
  });
}
