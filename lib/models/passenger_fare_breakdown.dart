class PassengerFareBreakdown {
  final String passengerType;
  final int quantity;
  final double totalFare;

  PassengerFareBreakdown({
    required this.passengerType,
    required this.quantity,
    required this.totalFare,
  });

  factory PassengerFareBreakdown.fromJson(Map<String, dynamic> json) {
    final quantity = json['PassengerTypeQuantity']['Quantity'] as int;
    final code = json['PassengerTypeQuantity']['Code'] as String;
    final total = json['PassengerFare']['TotalFare']['Amount'] as String;

    return PassengerFareBreakdown(
      passengerType: code,
      quantity: quantity,
      totalFare: double.parse(total),
    );
  }
}