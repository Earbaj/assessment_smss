import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/cost_breakdown_entity.dart';
import '../repository/sms_repository.dart';

class GetCostBreakdownUseCase {
  final SmsRepository repository;

  GetCostBreakdownUseCase(this.repository);

  Future<Either<Failure, CostBreakdown>> call() async {
    return await repository.getCostBreakdown();
  }
}
