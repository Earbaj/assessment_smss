import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cost_breakdown_entity.dart';
import '../entities/sms_response_entity.dart';

abstract class SmsRepository {
  Future<Either<Failure, SmsResponse>> sendSms(String to, String body);
  Future<Either<Failure, CostBreakdown>> getCostBreakdown();
}
