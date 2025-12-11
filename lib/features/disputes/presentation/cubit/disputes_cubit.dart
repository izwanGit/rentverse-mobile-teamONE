import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    } catch (e) {
      emit(state.copyWith(status: DisputesStatus.failure, error: e.toString()));
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
    } catch (e) {
      emit(state.copyWith(status: DisputesStatus.failure, error: e.toString()));
    }
  }
}
