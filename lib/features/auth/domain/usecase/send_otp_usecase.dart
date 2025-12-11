import 'package:rentverse/core/resources/data_state.dart';
import 'package:rentverse/core/usecase/usecase.dart';
import 'package:rentverse/features/auth/domain/repository/auth_repository.dart';

class SendOtpParams {
  final String target;
  final String channel;

  SendOtpParams({required this.target, required this.channel});
}

class SendOtpUseCase implements UseCase<DataState<bool>, SendOtpParams> {
  final AuthRepository _authRepository;

  SendOtpUseCase(this._authRepository);

  @override
  Future<DataState<bool>> call({SendOtpParams? param}) {
    if (param == null) throw ArgumentError('param is required');
    return _authRepository.sendOtp(
      target: param.target,
      channel: param.channel,
    );
  }
}
