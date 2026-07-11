import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/sms_response_entity.dart';
import '../repository/sms_repository.dart';
class SendSmsUseCase {
  final SmsRepository repository;

  SendSmsUseCase(this.repository);

  Future<Either<Failure, SmsResponse>> call(String to, String body) async {
    if (to.isEmpty || body.isEmpty) {
      return const Left(ServerFailure('Phone number and message cannot be empty.'));
    }
    return await repository.sendSms(to, body);
  }
}
