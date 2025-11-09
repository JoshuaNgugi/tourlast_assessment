import 'package:flutter/material.dart';
import 'package:tourlast_assessment/screens/flight_list_screen.dart';

void main() {
  runApp(const TourlastApp());
}

class TourlastApp extends StatefulWidget {
  const TourlastApp({super.key});

  @override
  TourlastAppState createState() => TourlastAppState();
}

class TourlastAppState extends State<TourlastApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tourlast',
      initialRoute: FlightListScreen.routeName,
      routes: {
        FlightListScreen.routeName: (context) => const FlightListScreen(),
      },
    );
  }
}
