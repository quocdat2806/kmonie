import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entity/base_response/base_response.dart';
import 'package:kmonie/entity/auth_response/auth_data.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required AuthData data,
    required String message,
    required bool success,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

// Extension để convert từ BaseResponse sang AuthResponse
extension AuthResponseExtension on BaseResponse {
  AuthResponse toAuthResponse() {
    return AuthResponse(
      data: AuthData.fromJson(data as Map<String, dynamic>),
      message: message,
      success: success,
    );
  }
}
