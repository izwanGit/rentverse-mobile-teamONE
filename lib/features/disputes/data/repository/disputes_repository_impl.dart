import '../../domain/entity/dispute_entity.dart';
import '../../domain/repository/dispute_repository.dart';
import '../source/disputes_api_service.dart';

class DisputesRepositoryImpl implements DisputeRepository {
  final DisputesApiService _api;

  DisputesRepositoryImpl(this._api);

  @override
  Future<List<DisputeEntity>> getMyDisputes() async {
    final models = await _api.getMyDisputes();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<DisputeEntity> createDispute(
    String bookingId,
    String reason,
    String? description,
  ) async {
    final body = <String, dynamic>{'reason': reason};
    if (description != null) body['description'] = description;
    final model = await _api.createDispute(bookingId, body);
    return model.toEntity();
  }
}
