class DisputeEntity {
  final String id;
  final String bookingId;
  final String initiatorId;
  final String reason;
  final String? description;
  final String status;
  final String? resolution;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BookingPreview? booking;

  DisputeEntity({
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
}

class BookingPreview {
  final String id;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final PropertyPreview property;

  BookingPreview({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.property,
  });
}

class PropertyPreview {
  final String title;
  final String city;

  PropertyPreview({required this.title, required this.city});
}
