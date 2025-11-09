import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tourlast_assessment/models/flight_itinerary.dart';

class DataService {
  List<FlightItinerary> _allFlights = [];

  List<FlightItinerary> get allFlights => _allFlights;

  Future<void> loadData() async {
    final flightJsonString = await rootBundle.loadString(
      'assets/json-files/flights.json',
    );
    final Map<String, dynamic> jsonData = json.decode(flightJsonString);

    final List<dynamic> flightList =
        jsonData["AirSearchResponse"]["AirSearchResult"]["FareItineraries"];

    _allFlights = flightList
        .map((item) => FlightItinerary.fromJson(item["FareItinerary"]))
        .toList();
  }

  List<String> getUniqueAirlines() {
    return _allFlights.map((f) => f.validatingAirlineCode).toSet().toList();
  }
}
