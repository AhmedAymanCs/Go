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
  final String? driverId;
  final double? driverLng;
  final double? driverHeading;
  final double? driverLat;
  final String? driverName;
  final String? driverPhone;
  final String? fcmToken;
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
    this.driverId,
    this.driverLng,
    this.driverLat,
    this.driverName,
    this.driverPhone,
    this.driverHeading,
    this.fcmToken,
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
      driverId: json['driver_id'] ?? '',
      driverLat: json['driver_lat'] != null
          ? (json['driver_lat'] as num).toDouble()
          : null,
      driverLng: json['driver_lng'] != null
          ? (json['driver_lng'] as num).toDouble()
          : null,
      driverName: json['driver_name'] ?? 'Not Found',
      driverPhone: json['driver_phone'] ?? 'Not Found',
      driverHeading: json['driver_heading'] ?? 0,
      fcmToken: json['fcm_token'] ?? '',
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
    String? driverId,
    double? driverLat,
    double? driverLng,
    double? driverHeading,
    String? driverName,
    String? driverPhone,
    String? fcmToken,
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
      driverId: driverId ?? this.driverId,
      driverLat: driverLat ?? this.driverLat,
      driverLng: driverLng ?? this.driverLng,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverHeading: driverHeading ?? this.driverHeading,
      fcmToken: fcmToken ?? this.fcmToken,
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
      'driver_id': driverId ?? '',
      'driver_lat': driverLat,
      'driver_lng': driverLng,
      'driver_name': driverName ?? 'Not Found',
      'driver_phone': driverPhone ?? 'Not Found',
      'driver_heading': driverHeading ?? 0,
      'fcm_token': fcmToken,
    };
  }
}
