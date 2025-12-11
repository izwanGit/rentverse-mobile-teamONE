import '../../domain/entity/dispute_entity.dart';

class DisputeModel {
  final String id;
  final String bookingId;
  final String initiatorId;
  final String reason;
  final String? description;
  final String status;
  final String? resolution;
  final String? adminNotes;
  final String createdAt;
  final String updatedAt;
  final BookingModel? booking;

  DisputeModel({
    required this.id,
    required this.bookingId,
    required this.initiatorId,
    required this.reason,
    this.description,
    required this.status,
    this.resolution,
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
    this.booking,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      initiatorId: json['initiatorId'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      resolution: json['resolution'] as String?,
      adminNotes: json['adminNotes'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      booking: json['booking'] != null
          ? BookingModel.fromJson(json['booking'] as Map<String, dynamic>)
          : null,
    );
  }

  DisputeEntity toEntity() {
    return DisputeEntity(
      id: id,
      bookingId: bookingId,
      initiatorId: initiatorId,
      reason: reason,
      description: description,
      status: status,
      resolution: resolution,
      adminNotes: adminNotes,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      booking: booking?.toEntity(),
    );
  }
}

class BookingModel {
  final String id;
  final String status;
  final String startDate;
  final String endDate;
  final PropertyModel property;

  BookingModel({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.property,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      status: json['status'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      property: PropertyModel.fromJson(
        json['property'] as Map<String, dynamic>,
      ),
    );
  }

  BookingPreview toEntity() {
    return BookingPreview(
      id: id,
      status: status,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      property: property.toEntity(),
    );
  }
}

class PropertyModel {
  final String title;
  final String city;

  PropertyModel({required this.title, required this.city});

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      title: json['title'] as String,
      city: json['city'] as String,
    );
  }

  PropertyPreview toEntity() => PropertyPreview(title: title, city: city);
}
