abstract class SmsEvent {}

class FetchCostBreakdownEvent extends SmsEvent {}

class SendSmsEvent extends SmsEvent {
  final String to;
  final String body;
  SendSmsEvent({required this.to, required this.body});
}
