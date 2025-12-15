import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:rentverse/core/network/dio_client.dart';
import 'package:rentverse/core/utils/error_utils.dart';
import '../models/dispute_model.dart';

abstract class DisputesApiService {
  Future<List<DisputeModel>> getMyDisputes();
  Future<DisputeModel> createDispute(
    String bookingId,
    Map<String, dynamic> body,
  );
}

class DisputesApiServiceImpl implements DisputesApiService {
  final DioClient _dio;
  final Logger _logger;

  DisputesApiServiceImpl(this._dio, this._logger);

  @override
  Future<List<DisputeModel>> getMyDisputes() async {
    try {
      final resp = await _dio.get('/disputes');
      _logger.i('GET /disputes -> ${resp.data}');
      final data = resp.data as Map<String, dynamic>;
      final items = (data['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      return items.map((e) => DisputeModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _logger.e('Failed GET /disputes', error: e);
      throw Exception(resolveApiErrorMessage(e));
    }
  }

  @override
  Future<DisputeModel> createDispute(
    String bookingId,
    Map<String, dynamic> body,
  ) async {
    try {
      final resp = await _dio.post('/bookings/$bookingId/dispute', data: body);
      _logger.i('POST /bookings/$bookingId/dispute -> ${resp.data}');
      return DisputeModel.fromJson(resp.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.e('Failed POST dispute', error: e);
      throw Exception(resolveApiErrorMessage(e));
    }
  }
}
