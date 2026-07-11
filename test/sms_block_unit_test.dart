import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sms_console/core/errors/failures.dart';
import 'package:sms_console/features/sms/domain/entity/cost_breakdown_entity.dart';
import 'package:sms_console/features/sms/domain/entity/sms_response_entity.dart';
import 'package:sms_console/features/sms/domain/usecase/get_cost_breakdown_usecase.dart';
import 'package:sms_console/features/sms/domain/usecase/send_sms_usecase.dart';
import 'package:sms_console/features/sms/presentation/block/sms_block.dart';
import 'package:sms_console/features/sms/presentation/event/sms_event.dart';
import 'package:sms_console/features/sms/presentation/state/sms_state.dart';

class MockGetCostBreakdownUseCase extends Mock implements GetCostBreakdownUseCase {}
class MockSendSmsUseCase extends Mock implements SendSmsUseCase {}

void main() {
  late SmsBloc smsBloc;
  late MockGetCostBreakdownUseCase mockGetCostBreakdownUseCase;
  late MockSendSmsUseCase mockSendSmsUseCase;

  setUp(() {
    mockGetCostBreakdownUseCase = MockGetCostBreakdownUseCase();
    mockSendSmsUseCase = MockSendSmsUseCase();
    smsBloc = SmsBloc(
      getCostBreakdownUseCase: mockGetCostBreakdownUseCase,
      sendSmsUseCase: mockSendSmsUseCase,
    );
  });

  tearDown(() {
    smsBloc.close();
  });

  const tCostBreakdown = CostBreakdown(rows: [], totalCostSum: '0.0000');
  const tSmsResponse = SmsResponse(provider: 'TWILIO', cost: '0.0750', segmentCount: 1);

  blocTest<SmsBloc, SmsState>(
    'emits [SmsLoading, SmsLoaded] when FetchCostBreakdownEvent is successful',
    build: () {
      when(() => mockGetCostBreakdownUseCase()).thenAnswer((_) async => const Right(tCostBreakdown));
      return smsBloc;
    },
    act: (bloc) => bloc.add(FetchCostBreakdownEvent()),
    expect: () => [
      isA<SmsLoading>(),
      isA<SmsLoaded>(),
    ],
  );

  blocTest<SmsBloc, SmsState>(
    'emits [SmsLoading, SmsError] when FetchCostBreakdownEvent fails',
    build: () {
      when(() => mockGetCostBreakdownUseCase()).thenAnswer((_) async => const Left(ServerFailure('Error')));
      return smsBloc;
    },
    act: (bloc) => bloc.add(FetchCostBreakdownEvent()),
    expect: () => [
      isA<SmsLoading>(),
      isA<SmsError>(),
    ],
  );

  blocTest<SmsBloc, SmsState>(
    'emits [SmsLoading, SmsLoaded] when SendSmsEvent is completely successful',
    build: () {
      when(() => mockSendSmsUseCase(any(), any())).thenAnswer((_) async => const Right(tSmsResponse));
      when(() => mockGetCostBreakdownUseCase()).thenAnswer((_) async => const Right(tCostBreakdown));
      return smsBloc;
    },
    act: (bloc) => bloc.add(SendSmsEvent(to: '+123456', body: 'Hello')),
    expect: () => [
      isA<SmsLoading>(),
      isA<SmsLoaded>(),
    ],
  );
}
