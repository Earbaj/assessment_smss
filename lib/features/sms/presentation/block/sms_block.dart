import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_cost_breakdown_usecase.dart';
import '../../domain/usecase/send_sms_usecase.dart';
import '../event/sms_event.dart';
import '../state/sms_state.dart';

class SmsBloc extends AppBloc<SmsEvent, SmsState> {
  final GetCostBreakdownUseCase getCostBreakdownUseCase;
  final SendSmsUseCase sendSmsUseCase;

  SmsBloc({
    required this.getCostBreakdownUseCase,
    required this.sendSmsUseCase,
  }) : super(SmsInitial()) {
    on<FetchCostBreakdownEvent>(_onFetchCostBreakdown);
    on<SendSmsEvent>(_onSendSms);
  }

  Future<void> _onFetchCostBreakdown(FetchCostBreakdownEvent event, Emitter<SmsState> emit) async {
    emit(SmsLoading());
    final result = await getCostBreakdownUseCase();
    result.fold(
      (failure) => emit(SmsError(message: failure.message)),
      (breakdown) => emit(SmsLoaded(costBreakdown: breakdown)),
    );
  }

  Future<void> _onSendSms(SendSmsEvent event, Emitter<SmsState> emit) async {
    emit(SmsLoading());
    final sendResult = await sendSmsUseCase(event.to, event.body);

    await sendResult.fold(
      (failure) async {
        emit(SmsError(message: failure.message));
      },
      (smsResponse) async {
        final breakdownResult = await getCostBreakdownUseCase();
        breakdownResult.fold(
          (failure) => emit(SmsError(message: failure.message)),
          (breakdown) => emit(
            SmsLoaded(
              costBreakdown: breakdown,
              successMessage: 'Sent via ${smsResponse.provider} — €${smsResponse.cost}',
            ),
          ),
        );
      },
    );
  }
}

abstract class AppBloc<E, S> extends Bloc<E, S> {
  AppBloc(super.initialState);
}
