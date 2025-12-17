import 'package:rentverse/features/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationRepository _repository;

  MarkAllNotificationsReadUseCase(this._repository);

  Future<void> call() async {
    return _repository.markAllAsRead();
  }
}
