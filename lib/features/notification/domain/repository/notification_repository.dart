import 'package:rentverse/features/notification/domain/entity/notification_response_entity.dart';

abstract class NotificationRepository {
  Future<NotificationListEntity> getNotifications({int limit, String? cursor});
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}
