import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tourlast_assessment/models/flight_itinerary.dart';
import 'package:tourlast_assessment/models/flight_segment.dart';
import 'package:tourlast_assessment/models/passenger_fare_breakdown.dart';
import 'package:tourlast_assessment/services/data_service.dart';

class FlightDetailScreen extends StatelessWidget {
  static const String routeName = '/flight-details';

  final FlightItinerary flight;

  const FlightDetailScreen({required this.flight, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flight Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and Total Price
            _buildHeaderCard(context),
            const SizedBox(height: 20),
            // Flight Segments/Itinerary
            _buildSectionTitle(
              context,
              Icons.connecting_airports,
              'Itinerary & Route',
            ),
            ...flight.segments
                .map((s) => _buildSegmentTile(context, s))
                .toList(),
            // Price Breakdown
            const SizedBox(height: 20),
            _buildSectionTitle(context, Icons.price_change, 'Price Breakdown'),
            _buildPriceBreakdown(context, flight.passengerBreakdowns),
            // Additional Information
            const SizedBox(height: 20),
            _buildSectionTitle(
              context,
              Icons.info_outline,
              'Ticket & Service Info',
            ),
            _buildServiceDetails(context),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proceed to Booking...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  'Book this Flight for \$${flight.totalFareAmount.toStringAsFixed(2)}',
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final dataService = Provider.of<DataService>(context);

    final airline = dataService.getAirlineDetails(flight.validatingAirlineCode);
    final airlineName = airline?.name ?? flight.validatingAirlineCode;
    final logoUrl = airline?.logoUrl;

    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: logoUrl != null
                    ? Image.network(
                        logoUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(flight.validatingAirlineCode),
                          );
                        },
                      )
                    : Center(child: Text(flight.validatingAirlineCode)),
              ),
            ),

            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airlineName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total Price: \$${flight.totalFareAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ticket Type: ${flight.totalStops == 0 ? 'Direct' : '${flight.totalStops} Stop(s)'}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentTile(BuildContext context, FlightSegment segment) {
    final deptDate = DateFormat('d MMM yyyy').format(segment.departureTime);
    final depTime = TimeOfDay.fromDateTime(
      segment.departureTime,
    ).format(context);
    final arrDate = DateFormat('d MMM yyyy').format(segment.arrivalTime);
    final arrTime = TimeOfDay.fromDateTime(segment.arrivalTime).format(context);
    final duration =
        '${(int.parse(segment.durationMinutes) / 60).floor()}h ${int.parse(segment.durationMinutes) % 60}m';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${segment.marketingAirlineName} (${segment.flightNumber})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo(
                  deptDate,
                  depTime,
                  segment.departureAirportCode,
                  true,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(duration, style: const TextStyle(fontSize: 12)),
                ),
                _buildTimeInfo(
                  arrDate,
                  arrTime,
                  segment.arrivalAirportCode,
                  false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(
    String date,
    String time,
    String code,
    bool isDeparture,
  ) {
    return Column(
      crossAxisAlignment: isDeparture
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(code, style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 4),
        Text(date, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildPriceBreakdown(
    BuildContext context,
    List<PassengerFareBreakdown> breakdowns,
  ) {
    return Column(
      children: breakdowns
          .map(
            (b) => ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text('${b.passengerType} x ${b.quantity}'),
              trailing: Text(
                '\$${b.totalFare.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildServiceDetails(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.luggage_outlined),
          title: const Text('Checked Baggage Policy'),
          subtitle: const Text(
            '2 pieces (23kg each) - Refer to trip-details.json',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.restaurant_menu),
          title: const Text('Meals and Refreshments'),
          subtitle: const Text(
            'Available for purchase - Refer to extra-services.json',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.cancel_outlined),
          title: const Text('Cancellation Policy'),
          subtitle: const Text('Non-Refundable (See PenaltyDetails)'),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
