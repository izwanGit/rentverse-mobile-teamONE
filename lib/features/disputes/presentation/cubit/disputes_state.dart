part of 'disputes_cubit.dart';

enum DisputesStatus { initial, loading, success, failure }

class DisputesState extends Equatable {
  final DisputesStatus status;
  final List<DisputeEntity> disputes;
  final String? error;

  const DisputesState._({
    required this.status,
    required this.disputes,
    this.error,
  });

  const DisputesState.initial()
    : this._(status: DisputesStatus.initial, disputes: const [], error: null);

  DisputesState copyWith({
    DisputesStatus? status,
    List<DisputeEntity>? disputes,
    String? error,
  }) {
    return DisputesState._(
      status: status ?? this.status,
      disputes: disputes ?? this.disputes,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, disputes, error];
}
