import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:rentverse/features/notification/domain/usecase/mark_notification_read_usecase.dart';
import 'package:rentverse/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:rentverse/features/notification/domain/usecase/mark_notification_read_usecase.dart';
import 'package:rentverse/features/notification/domain/usecase/mark_all_notifications_read_usecase.dart';
import 'package:rentverse/features/notification/presentation/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(
    this._getNotifications,
    this._markNotificationRead,
    this._markAllNotificationsRead,
  ) : super(const NotificationState());

  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationReadUseCase _markNotificationRead;
  final MarkAllNotificationsReadUseCase _markAllNotificationsRead;

  Future<void> load({int limit = 20}) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final res = await _getNotifications(
        param: GetNotificationsParams(limit: limit),
      );
      emit(
        state.copyWith(
          isLoading: false,
          items: res.items,
          hasMore: res.meta.hasMore,
          nextCursor: res.meta.nextCursor,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadMore({int limit = 20}) async {
    if (state.isLoadingMore || !state.hasMore || state.nextCursor == null) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true, error: null));
    try {
      final res = await _getNotifications(
        param: GetNotificationsParams(limit: limit, cursor: state.nextCursor),
      );
      emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...res.items],
          hasMore: res.meta.hasMore,
          nextCursor: res.meta.nextCursor,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  Future<void> markRead(String id) async {
    final alreadyRead = state.items.any((n) => n.id == id && n.isRead);
    if (state.markingIds.contains(id) || alreadyRead) return;
    emit(state.copyWith(markingIds: {...state.markingIds, id}, error: null));
    try {
      await _markNotificationRead(param: id);
      final updated = state.items
          .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
          .toList();
      emit(
        state.copyWith(
          items: updated,
          markingIds: {...state.markingIds}..remove(id),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          markingIds: {...state.markingIds}..remove(id),
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> markAllRead() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _markAllNotificationsRead();
      final updated = state.items.map((item) => item.copyWith(isRead: true)).toList();
      emit(state.copyWith(isLoading: false, items: updated));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
