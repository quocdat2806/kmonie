import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entity/user/user.dart';
import 'package:kmonie/entity/auth_response/token.dart';

part 'auth_data.freezed.dart';
part 'auth_data.g.dart';

@freezed
abstract class AuthData with _$AuthData {
  const factory AuthData({required User user, required Token token}) =
      _AuthData;

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);
}
