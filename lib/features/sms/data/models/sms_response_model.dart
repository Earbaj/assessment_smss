import '../../domain/entities/sms_response.dart';

class SmsResponseModel extends SmsResponse {
  const SmsResponseModel({
    required super.provider,
    required super.cost,
    required super.segmentCount,
  });

  factory SmsResponseModel.fromJson(Map<String, dynamic> json) {
    return SmsResponseModel(
      provider: json['provider'] ?? 'UNKNOWN',
      cost: json['cost']?.toString() ?? '0.0000',
      segmentCount: json['segmentCount'] as int? ?? 1,
    );
  }
}
