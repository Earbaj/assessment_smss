import '../models/cost_breakdown_model.dart';
import '../../domain/entities/cost_breakdown.dart';

class CostBreakdownMapper {
  static CostBreakdown toEntity(CostBreakdownModel model) {
    double totalAccumulator = 0.0;
    final entityRows = model.rows.map((rowModel) {
      final doubleValue = double.tryParse(rowModel.totalCost) ?? 0.0;
      totalAccumulator += doubleValue;
      
      return CostRow(
        provider: rowModel.provider,
        totalCost: rowModel.totalCost,
      );
    }).toList();

    return CostBreakdown(
      rows: entityRows,
      totalCostSum: totalAccumulator.toStringAsFixed(4),
    );
  }
}
