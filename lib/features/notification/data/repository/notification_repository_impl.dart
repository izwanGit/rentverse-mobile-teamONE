import 'package:rentverse/features/notification/data/source/notification_api_service.dart';
import 'package:rentverse/features/notification/domain/entity/notification_response_entity.dart';
import 'package:rentverse/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._apiService);

  final NotificationApiService _apiService;

  @override
  Future<NotificationListEntity> getNotifications({
    int limit = 20,
    String? cursor,
  }) async {
    final res = await _apiService.getNotifications(
      limit: limit,
      cursor: cursor,
    );
    return res.toEntity();
  }

  @override
  Future<void> markAsRead(String id) => _apiService.markAsRead(id);

  @override
  Future<void> markAllAsRead() => _apiService.markAllAsRead();
}
