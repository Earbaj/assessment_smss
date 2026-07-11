class SmsResponse {
  final String provider;
  final String cost;
  final int segmentCount;

  const SmsResponse({
    required this.provider,
    required this.cost,
    required this.segmentCount,
  });
}
