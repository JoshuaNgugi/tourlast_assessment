class Airline {
  final String code;
  final String name;
  final String logoUrl;

  Airline({required this.code, required this.name, required this.logoUrl});

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      code: json['AirLineCode'] as String,
      name: json['AirLineName'] as String,
      logoUrl: json['AirLineLogo'] as String,
    );
  }
}
