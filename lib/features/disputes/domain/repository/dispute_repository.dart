import '../entity/dispute_entity.dart';

abstract class DisputeRepository {
  Future<List<DisputeEntity>> getMyDisputes();

  /// Create a dispute for a booking id. Returns the created DisputeEntity.
  Future<DisputeEntity> createDispute(
    String bookingId,
    String reason,
    String? description,
  );
}
