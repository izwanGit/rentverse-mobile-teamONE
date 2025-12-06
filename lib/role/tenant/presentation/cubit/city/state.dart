import 'package:equatable/equatable.dart';

class City extends Equatable {
  final int id;
  final String name;
  final int propertyCount;
  final String image;

  const City({
    required this.id,
    required this.name,
    required this.propertyCount,
    required this.image,
  });

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      propertyCount:
          map['propertuCOunt'] as int? ?? map['propertyCount'] as int? ?? 0,
      image: map['image'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, propertyCount, image];
}

class CityState extends Equatable {
  final List<City> cities;
  final int currentIndex;
  final bool isLoading;
  final String? error;

  const CityState({
    this.cities = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
  });

  CityState copyWith({
    List<City>? cities,
    int? currentIndex,
    bool? isLoading,
    String? error,
  }) {
    return CityState(
      cities: cities ?? this.cities,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [cities, currentIndex, isLoading, error];
}
