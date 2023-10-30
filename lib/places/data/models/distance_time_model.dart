class DistanceTimeModel {
  final String distance, duration;

  DistanceTimeModel({
    required this.distance,
    required this.duration,
  });
  factory DistanceTimeModel.fromMap(Map<String, dynamic> map) =>
      DistanceTimeModel(
          distance: map['distance']['text'], duration: map['duration']['text']);
}