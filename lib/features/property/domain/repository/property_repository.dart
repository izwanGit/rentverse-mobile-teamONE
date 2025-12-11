import '../entity/list_property_entity.dart';
import '../entity/list_property_by_owner.dart';
import '../entity/create_property_params.dart';

abstract class PropertyRepository {
  Future<ListPropertyByOwnerEntity> getLandlordProperties({
    int? limit,
    String? cursor,
  });
  Future<ListPropertyEntity> getProperties({int? limit, String? cursor});
  Future<PropertyEntity> getPropertyDetail(String id);
  Future<PropertyEntity> createProperty(CreatePropertyParams params);
  Future<PropertyEntity> updateProperty(String id, Map<String, dynamic> fields);
}
