class OrderModel {
  final String? id;
  final String destination;
  final double distanceKm;
  final double durationMin;
  final double price;
  final double destinationLat;
  final double destinationLng;
  final String passengerId;

  const OrderModel({
    this.id,
    required this.destination,
    required this.distanceKm,
    required this.durationMin,
    required this.price,
    required this.destinationLat,
    required this.destinationLng,
    required this.passengerId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      destination: json['destination'] ?? "Not Found",
      distanceKm: (json['distance_km'] as num).toDouble(),
      durationMin: (json['duration_min'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      destinationLat: (json['destination_lat'] as num).toDouble(),
      destinationLng: (json['destination_lng'] as num).toDouble(),
      passengerId: json['passenger_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'distance_km': distanceKm,
      'duration_min': durationMin,
      'price': price,
      'destination_lat': destinationLat,
      'destination_lng': destinationLng,
      'passenger_id': passengerId,
    };
  }
}
