import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

@freezed
abstract class BaseResponse with _$BaseResponse {
  const factory BaseResponse({
    required dynamic data,
    required String message,
    required bool success,
  }) = _BaseResponse;

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
}
