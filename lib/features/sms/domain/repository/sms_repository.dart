import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/cost_breakdown_entity.dart';
import '../entity/sms_response_entity.dart';

abstract class SmsRepository {
  Future<Either<Failure, SmsResponse>> sendSms(String to, String body);
  Future<Either<Failure, CostBreakdown>> getCostBreakdown();
}
