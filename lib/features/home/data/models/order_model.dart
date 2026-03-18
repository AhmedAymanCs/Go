class OrderModel {
  final String? id;
  final String destination;
  final double distanceKm;
  final double durationMin;
  final double price;
  final double destinationLat;
  final double passengerLat;
  final double destinationLng;
  final double passengerLng;
  final String passengerId;
  final String? status;
  final String? passengerName;
  final String? passengerPhone;
  const OrderModel({
    this.id,
    required this.destination,
    required this.distanceKm,
    required this.durationMin,
    required this.price,
    required this.destinationLat,
    required this.destinationLng,
    required this.passengerId,
    this.status,
    required this.passengerLat,
    required this.passengerLng,
    this.passengerName,
    this.passengerPhone,
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
      status: json['status'] ?? 'pending',
      passengerLat: (json['passenger_lat'] as num).toDouble(),
      passengerLng: (json['passenger_lng'] as num).toDouble(),
      passengerName: json['passenger_name'] ?? 'Not Found',
      passengerPhone: json['passenger_phone'] ?? 'Not Found',
    );
  }
  OrderModel copyWith({
    String? id,
    String? destination,
    double? distanceKm,
    double? durationMin,
    double? price,
    double? destinationLat,
    double? destinationLng,
    String? passengerId,
    String? status,
    double? passengerLat,
    double? passengerLng,
    String? passengerName,
    String? passengerPhone,
  }) {
    return OrderModel(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMin: durationMin ?? this.durationMin,
      price: price ?? this.price,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      passengerId: passengerId ?? this.passengerId,
      status: status ?? this.status,
      passengerLat: passengerLat ?? this.passengerLat,
      passengerLng: passengerLng ?? this.passengerLng,
      passengerName: passengerName ?? this.passengerName,
      passengerPhone: passengerPhone ?? this.passengerPhone,
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
      'status': status ?? 'pending',
      'passenger_lat': passengerLat,
      'passenger_lng': passengerLng,
      'passenger_name': passengerName ?? 'Not Found',
      'passenger_phone': passengerPhone ?? 'Not Found',
    };
  }
}
