// Part of lib/screens/flight_list_screen.dart (or separate in lib/widgets)

import 'package:flutter/material.dart';
import 'package:tourlast_assessment/models/flight_itinerary.dart';

class FlightCard extends StatelessWidget {
  final FlightItinerary flight;

  const FlightCard({super.key, required this.flight});

  void _navigateToDetail(BuildContext context) {
    // TODO: implement navigation
  }

  @override
  Widget build(BuildContext context) {
    final segment = flight.segments.first;
    final airlineCode = flight.validatingAirlineCode;
    final totalPrice = flight.totalFareAmount.toStringAsFixed(2);
    final departureTime = TimeOfDay.fromDateTime(
      segment.departureTime,
    ).format(context);
    final arrivalTime = TimeOfDay.fromDateTime(
      segment.arrivalTime,
    ).format(context);
    final duration =
        '${(int.parse(segment.durationMinutes) / 60).floor()}h ${int.parse(segment.durationMinutes) % 60}m';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$totalPrice',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade200,
                    child: Center(child: Text(airlineCode)),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureTime,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        segment.departureAirportCode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          duration,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Icon(Icons.flight, size: 20, color: Colors.blue),
                        Text(
                          flight.totalStops == 0
                              ? 'Direct'
                              : '${flight.totalStops} Stop(s)',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: flight.totalStops == 0
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalTime,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        segment.arrivalAirportCode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.luggage, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Baggage included (Check detail)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
