import 'package:dio/dio.dart';
import '../models/cost_breakdown_model.dart';
import '../models/sms_response_model.dart';

abstract class SmsRemoteDataSource {
  Future<SmsResponseModel> sendSms(String to, String body);
  Future<CostBreakdownModel> getCostBreakdown();
}

class SmsRemoteDataSourceImpl implements SmsRemoteDataSource {
  final Dio dio;

  SmsRemoteDataSourceImpl(this.dio);

  @override
  Future<SmsResponseModel> sendSms(String to, String body) async {
    final response = await dio.post(
      '/api/v1/sms/send',
      data: {'to': to, 'body': body},
    );
    return SmsResponseModel.fromJson(response.data);
  }

  @override
  Future<CostBreakdownModel> getCostBreakdown() async {
    final response = await dio.get('/api/v1/sms/cost/breakdown');
    return CostBreakdownModel.fromJson(response.data);
  }
}
