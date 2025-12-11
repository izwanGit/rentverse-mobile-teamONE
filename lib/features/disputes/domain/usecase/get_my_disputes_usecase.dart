import '../../../../core/usecase/usecase.dart';
import '../entity/dispute_entity.dart';
import '../repository/dispute_repository.dart';

class GetMyDisputesUseCase implements UseCase<List<DisputeEntity>, NoParams> {
  final DisputeRepository _repository;

  GetMyDisputesUseCase(this._repository);

  @override
  Future<List<DisputeEntity>> call({NoParams? param}) async {
    return _repository.getMyDisputes();
  }
}
