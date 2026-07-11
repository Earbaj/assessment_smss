import '../../domain/entities/cost_breakdown.dart';

abstract class SmsState {}

class SmsInitial extends SmsState {}

class SmsLoading extends SmsState {}

class SmsLoaded extends SmsState {
  final CostBreakdown costBreakdown;
  final String? successMessage;

  SmsLoaded({required this.costBreakdown, this.successMessage});
}

class SmsError extends SmsState {
  final String message;
  SmsError({required this.message});
}
