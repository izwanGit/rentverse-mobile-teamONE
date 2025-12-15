import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rentverse/core/utils/error_utils.dart';
import '../../domain/entity/dispute_entity.dart';
import '../../domain/usecase/get_my_disputes_usecase.dart';
import '../../domain/usecase/create_dispute_usecase.dart';

part 'disputes_state.dart';

class DisputesCubit extends Cubit<DisputesState> {
  final GetMyDisputesUseCase _getMyDisputes;
  final CreateDisputeUseCase _createDispute;

  DisputesCubit(this._getMyDisputes, this._createDispute)
    : super(const DisputesState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: DisputesStatus.loading));
    try {
      final list = await _getMyDisputes();
      emit(state.copyWith(status: DisputesStatus.success, disputes: list));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: DisputesStatus.failure,
          error: resolveApiErrorMessage(e),
        ),
      );
    }
  }

  Future<void> create(
    String bookingId,
    String reason,
    String? description,
  ) async {
    emit(state.copyWith(status: DisputesStatus.loading));
    try {
      final param = CreateDisputeParams(
        bookingId: bookingId,
        reason: reason,
        description: description,
      );
      final dispute = await _createDispute(param: param);
      final newList = List<DisputeEntity>.from(state.disputes)
        ..insert(0, dispute);
      emit(state.copyWith(status: DisputesStatus.success, disputes: newList));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: DisputesStatus.failure,
          error: resolveApiErrorMessage(e),
        ),
      );
    }
  }
}
