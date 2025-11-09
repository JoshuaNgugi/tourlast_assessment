import 'package:flutter/material.dart';
import 'package:tourlast_assessment/models/flight_itinerary.dart';
import 'package:tourlast_assessment/services/data_service.dart';
import 'package:tourlast_assessment/widgets/flight_card.dart';

class FlightListScreen extends StatefulWidget {
  static const String routeName = '/flights';

  const FlightListScreen({super.key});

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  final DataService _dataService = DataService();
  List<FlightItinerary> _flights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    await _dataService.loadData();
    setState(() {
      _flights = _dataService.allFlights;
      _isLoading = false;
    });
  }

  void _applyFilters() {
    // TODO: implement filtering logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Filtering logic executed.')));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Options',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text('Price Range Filter Placeholder'),
              const Text('Airline Filter Placeholder'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
            tooltip: 'Filter Flights',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flights.isEmpty
          ? const Center(child: Text('No flights found.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _flights.length,
                    itemBuilder: (context, index) {
                      final flight = _flights[index];
                      return FlightCard(flight: flight);
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
    );
  }
}
