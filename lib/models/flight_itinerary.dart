import 'package:tourlast_assessment/models/flight_segment.dart';
import 'package:tourlast_assessment/models/passenger_fare_breakdown.dart';

class FlightItinerary {
  final String fareSourceCode;
  final double totalFareAmount;
  final String validatingAirlineCode;
  final List<FlightSegment> segments;
  final List<PassengerFareBreakdown> passengerBreakdowns;
  final int totalStops;

  FlightItinerary({
    required this.fareSourceCode,
    required this.totalFareAmount,
    required this.validatingAirlineCode,
    required this.segments,
    required this.passengerBreakdowns,
    required this.totalStops,
  });

  factory FlightItinerary.fromJson(Map<String, dynamic> json) {
    final fareInfo = json['AirItineraryFareInfo'];
    final totalFares = fareInfo['ItinTotalFares']['TotalFare'];
    final segmentsJson =
        json['OriginDestinationOptions'][0]['OriginDestinationOption'] as List;
    final fareBreakdownsJson = fareInfo['FareBreakdown'] as List;

    final totalStops = json['OriginDestinationOptions'][0]['TotalStops'] as int;

    return FlightItinerary(
      fareSourceCode: fareInfo['FareSourceCode'],
      totalFareAmount: double.parse(totalFares['Amount']),
      validatingAirlineCode: json['ValidatingAirlineCode'],
      segments: segmentsJson
          .map((s) => FlightSegment.fromJson(s['FlightSegment']))
          .toList(),
      passengerBreakdowns: fareBreakdownsJson
          .map((b) => PassengerFareBreakdown.fromJson(b))
          .toList(),
      totalStops: totalStops,
    );
  }
}
