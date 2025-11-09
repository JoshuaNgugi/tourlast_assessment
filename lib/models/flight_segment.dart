class FlightSegment {
  final String marketingAirlineCode;
  final String marketingAirlineName;
  final String flightNumber;
  final String departureAirportCode;
  final String arrivalAirportCode;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String durationMinutes;

  FlightSegment({
    required this.marketingAirlineCode,
    required this.marketingAirlineName,
    required this.flightNumber,
    required this.departureAirportCode,
    required this.arrivalAirportCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.durationMinutes,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      marketingAirlineCode: json['MarketingAirlineCode'],
      marketingAirlineName: json['MarketingAirlineName'],
      flightNumber: json['FlightNumber'],
      departureAirportCode: json['DepartureAirportLocationCode'],
      arrivalAirportCode: json['ArrivalAirportLocationCode'],
      
      departureTime: DateTime.parse(json['DepartureDateTime']),
      arrivalTime: DateTime.parse(json['ArrivalDateTime']),
      durationMinutes: json['JourneyDuration'],
    );
  }
}