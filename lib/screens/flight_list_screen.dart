import 'dart:math';

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
  List<FlightItinerary> _displayedFlights = [];
  List<FlightItinerary> _allFlightsCache = [];
  bool _isLoading = true;

  // Filter State Variables
  Set<String> _selectedAirlines = {};
  RangeValues _priceRange = const RangeValues(0.0, 1000.0);
  bool _showDirectOnly = false;
  double _absoluteMaxPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    await _dataService.loadData();
    setState(() {
      _allFlightsCache = _dataService.allFlights;
      _displayedFlights = _allFlightsCache;

      // Initialize price range based on actual data
      _absoluteMaxPrice = _allFlightsCache
          .map((f) => f.totalFareAmount)
          .reduce(max)
          .ceilToDouble();

      _priceRange = RangeValues(0.0, _absoluteMaxPrice);

      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<FlightItinerary> results = _allFlightsCache;

    // Apply Airline Filter
    if (_selectedAirlines.isNotEmpty) {
      results = results.where((flight) {
        return _selectedAirlines.contains(flight.validatingAirlineCode);
      }).toList();
    }

    // Apply Price Range Filter
    results = results.where((flight) {
      final price = flight.totalFareAmount;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    // Apply Direct Flight Filter i.e., Stops
    if (_showDirectOnly) {
      results = results.where((flight) {
        return flight.totalStops == 0;
      }).toList();
    }

    // Update the display list
    setState(() {
      _displayedFlights = results;
    });
  }

  void _showFilterSheet() {
    final List<String> availableAirlines = _dataService.getUniqueAirlines();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _FilterBottomSheet(
          initialAirlines: _selectedAirlines,
          initialPriceRange: _priceRange,
          initialDirectOnly: _showDirectOnly,
          availableAirlines: availableAirlines,
          maxPrice: _absoluteMaxPrice,

          onApply: (newAirlines, newPriceRange, newDirectOnly) {
            setState(() {
              _selectedAirlines = newAirlines;
              _priceRange = newPriceRange;
              _showDirectOnly = newDirectOnly;
            });
            _applyFilters();
          },
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
          : _displayedFlights.isEmpty
          ? const Center(child: Text('No flights found.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _displayedFlights.length,
                    itemBuilder: (context, index) {
                      final flight = _displayedFlights[index];
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

class _FilterBottomSheet extends StatefulWidget {
  final Set<String> initialAirlines;
  final RangeValues initialPriceRange;
  final bool initialDirectOnly;
  final List<String> availableAirlines;
  final double maxPrice;
  final Function(Set<String>, RangeValues, bool) onApply;

  const _FilterBottomSheet({
    required this.initialAirlines,
    required this.initialPriceRange,
    required this.initialDirectOnly,
    required this.availableAirlines,
    required this.maxPrice,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late Set<String> currentAirlines;
  late RangeValues currentPriceRange;
  late bool currentDirectOnly;

  @override
  void initState() {
    super.initState();
    currentAirlines = Set.from(widget.initialAirlines);
    currentPriceRange = widget.initialPriceRange;
    currentDirectOnly = widget.initialDirectOnly;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Filter Flights',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Divider(height: 20),
            // Price Filter
            Text(
              'Price Range: \$${currentPriceRange.start.round()} - \$${currentPriceRange.end.round()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RangeSlider(
              values: currentPriceRange,
              min: 0,
              max: widget.maxPrice,
              divisions: (widget.maxPrice / 10).round(),
              labels: RangeLabels(
                '\$${currentPriceRange.start.round()}',
                '\$${currentPriceRange.end.round()}',
              ),
              onChanged: (RangeValues newValues) {
                setState(() {
                  currentPriceRange = newValues;
                });
              },
            ),
            // Show Direct Flights Only Filter
            SwitchListTile(
              title: const Text('Show Direct Flights Only (0 Stops)'),
              value: currentDirectOnly,
              onChanged: (bool newValue) {
                setState(() {
                  currentDirectOnly = newValue;
                });
              },
            ),
            // Airline Filter
            const SizedBox(height: 10),
            Text('Airlines', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: widget.availableAirlines.map((airlineCode) {
                return FilterChip(
                  label: Text(airlineCode),
                  selected: currentAirlines.contains(airlineCode),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        currentAirlines.add(airlineCode);
                      } else {
                        currentAirlines.remove(airlineCode);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    currentAirlines,
                    currentPriceRange,
                    currentDirectOnly,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
