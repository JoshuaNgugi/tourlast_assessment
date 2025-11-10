import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tourlast_assessment/models/airline.dart';
import 'package:tourlast_assessment/models/flight_itinerary.dart';

class DataService {
  List<FlightItinerary> _allFlights = [];
  Map<String, Airline> _airlineMap = {};

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

    final airlineJsonString = await rootBundle.loadString(
      'assets/json-files/airline-list.json',
    );
    final List<dynamic> airlineList = json.decode(airlineJsonString);
    for (var json in airlineList) {
      final airline = Airline.fromJson(json);
      _airlineMap[airline.code] = airline;
    }
  }

  List<String> getUniqueAirlines() {
    return _allFlights
        .map((flight) => flight.validatingAirlineCode)
        .toSet()
        .toList();
  }

  Airline? getAirlineDetails(String code) {
    return _airlineMap[code];
  }
}
