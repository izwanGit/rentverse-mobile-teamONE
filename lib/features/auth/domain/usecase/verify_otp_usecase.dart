import 'package:rentverse/core/resources/data_state.dart';
import 'package:rentverse/core/usecase/usecase.dart';
import 'package:rentverse/features/auth/domain/repository/auth_repository.dart';

class VerifyOtpParams {
  final String target;
  final String channel;
  final String code;

  VerifyOtpParams({
    required this.target,
    required this.channel,
    required this.code,
  });
}

class VerifyOtpUseCase implements UseCase<DataState<bool>, VerifyOtpParams> {
  final AuthRepository _authRepository;

  VerifyOtpUseCase(this._authRepository);

  @override
  Future<DataState<bool>> call({VerifyOtpParams? param}) {
    if (param == null) throw ArgumentError('param is required');
    return _authRepository.verifyOtp(
      target: param.target,
      channel: param.channel,
      code: param.code,
    );
  }
}
