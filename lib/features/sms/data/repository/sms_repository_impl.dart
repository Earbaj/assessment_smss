import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/sms_repository.dart';
import '../datasources/sms_remote_data_source.dart';
import '../mappers/cost_breakdown_mapper.dart';
import '../entities/cost_breakdown.dart';
import '../entities/sms_response.dart';

class SmsRepositoryImpl implements SmsRepository {
  final SmsRemoteDataSource remoteDataSource;

  SmsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SmsResponse>> sendSms(String to, String body) async {
    try {
      final result = await remoteDataSource.sendSms(to, body);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'An unexpected network error occurred.'));
    }
  }

  @override
  Future<Either<Failure, CostBreakdown>> getCostBreakdown() async {
    try {
      final model = await remoteDataSource.getCostBreakdown();
      final entity = CostBreakdownMapper.toEntity(model);
      return Right(entity);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'An unexpected network error occurred.'));
    }
  }
}
