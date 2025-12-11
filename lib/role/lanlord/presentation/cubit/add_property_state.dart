import 'package:equatable/equatable.dart';

enum AddPropertyStatus { initial, loading, success, failure }

class AddPropertyState extends Equatable {
  final AddPropertyStatus status;
  final String? error;

  final bool basicCompleted;
  final bool pricingCompleted;

  final List<String> imagePaths;
  final String title;
  final String description;
  final int propertyTypeId;
  final int listingTypeId;
  final String projectName;
  final String address;
  final String city;
  final String country;
  final double? latitude;
  final double? longitude;
  final String size;
  final int bedrooms;
  final int bathrooms;

  final String furnishing;
  final List<String> features;
  final List<String> facilities;
  final List<String> views;
  final List<int> billingPeriodIds;
  final String price;

  const AddPropertyState({
    this.status = AddPropertyStatus.initial,
    this.error,
    this.basicCompleted = false,
    this.pricingCompleted = false,
    this.imagePaths = const [],
    this.title = '',
    this.description = '',
    this.propertyTypeId = 1,
    this.listingTypeId = 1,
    this.projectName = '',
    this.address = '',
    this.city = '',
    this.country = 'Indonesia',
    this.latitude,
    this.longitude,
    this.size = '',
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.furnishing = 'Unfurnished',
    this.features = const [],
    this.facilities = const [],
    this.views = const [],
    this.billingPeriodIds = const [1],
    this.price = '',
  });

  AddPropertyState copyWith({
    AddPropertyStatus? status,
    String? error,
    bool? basicCompleted,
    bool? pricingCompleted,
    List<String>? imagePaths,
    String? title,
    String? description,
    int? propertyTypeId,
    int? listingTypeId,
    String? projectName,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? size,
    int? bedrooms,
    int? bathrooms,
    String? furnishing,
    List<String>? features,
    List<String>? facilities,
    List<String>? views,
    List<int>? billingPeriodIds,
    String? price,
  }) {
    return AddPropertyState(
      status: status ?? this.status,
      error: error,
      basicCompleted: basicCompleted ?? this.basicCompleted,
      pricingCompleted: pricingCompleted ?? this.pricingCompleted,
      imagePaths: imagePaths ?? this.imagePaths,
      title: title ?? this.title,
      description: description ?? this.description,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      listingTypeId: listingTypeId ?? this.listingTypeId,
      projectName: projectName ?? this.projectName,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      size: size ?? this.size,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      furnishing: furnishing ?? this.furnishing,
      features: features ?? this.features,
      facilities: facilities ?? this.facilities,
      views: views ?? this.views,
      billingPeriodIds: billingPeriodIds ?? this.billingPeriodIds,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    basicCompleted,
    pricingCompleted,
    imagePaths,
    title,
    description,
    propertyTypeId,
    listingTypeId,
    projectName,
    address,
    city,
    country,
    latitude,
    longitude,
    size,
    bedrooms,
    bathrooms,
    furnishing,
    features,
    facilities,
    views,
    billingPeriodIds,
    price,
  ];
}
