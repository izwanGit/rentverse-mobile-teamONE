import '../../../../core/usecase/usecase.dart';
import '../entity/dispute_entity.dart';
import '../repository/dispute_repository.dart';

class CreateDisputeParams {
  final String bookingId;
  final String reason;
  final String? description;

  CreateDisputeParams({
    required this.bookingId,
    required this.reason,
    this.description,
  });
}

class CreateDisputeUseCase
    implements UseCase<DisputeEntity, CreateDisputeParams> {
  final DisputeRepository _repository;

  CreateDisputeUseCase(this._repository);

  @override
  Future<DisputeEntity> call({CreateDisputeParams? param}) async {
    if (param == null) throw ArgumentError('param required');
    return _repository.createDispute(
      param.bookingId,
      param.reason,
      param.description,
    );
  }
}
