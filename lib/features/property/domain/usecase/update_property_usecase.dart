import '../entity/list_property_entity.dart';
import '../repository/property_repository.dart';

class UpdatePropertyUseCase {
  final PropertyRepository _repository;

  UpdatePropertyUseCase(this._repository);

  Future<PropertyEntity> call(String id, Map<String, dynamic> fields) {
    return _repository.updateProperty(id, fields);
  }
}
