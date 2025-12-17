import 'package:rentverse/core/network/dio_client.dart';
import 'package:rentverse/features/notification/data/models/notification_model.dart';

abstract class NotificationApiService {
  Future<NotificationListModel> getNotifications({int limit, String? cursor});
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationApiServiceImpl implements NotificationApiService {
  NotificationApiServiceImpl(this._client);

  final DioClient _client;

  @override
  Future<NotificationListModel> getNotifications({
    int limit = 20,
    String? cursor,
  }) async {
    final response = await _client.get(
      '/notifications',
      queryParameters: {'limit': limit, if (cursor != null) 'cursor': cursor},
    );

    final data = response.data as Map<String, dynamic>;
    return NotificationListModel.fromJson(data);
  }

  @override
  Future<void> markAsRead(String id) async {
    await _client.patch('/notifications/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _client.patch('/notifications/read-all');
  }
}
