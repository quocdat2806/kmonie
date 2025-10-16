# Entity Structure

## Cấu trúc mới

### BaseResponse
Tất cả API response đều có format chuẩn:
```json
{
  "data": "object hoặc array",
  "message": "thông báo",
  "success": true/false
}
```

### User Entity
- **Vị trí**: `lib/entity/user/user.dart`
- **Cấu trúc**:
  ```dart
  User({
    required int id,
    required String username,
    required String avatar,
  })
  ```

### Auth Response Entities
- **Vị trí**: `lib/entity/auth_response/`
- **Các class**:
  - `Tokens`: chứa accessToken và refreshToken
  - `AuthData`: chứa User và Tokens
  - `AuthResponse`: response cho đăng nhập/đăng ký

### Cách sử dụng

#### 1. Auth API Response
```dart
// Server trả về
{
  "data": {
    "user": {
      "id": 123,
      "username": "quocdat",
      "avatar": "https://cdn.example.com/avatars/u123.png"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "b7f0c9ae-5e9b-4a3e-8f3d-2d6bb6f4901f"
    }
  },
  "message": "User registered successfully",
  "success": true
}

// Parse trong code
final baseResponse = BaseResponse.fromJson(json);
final authResponse = baseResponse.toAuthResponse();
```

#### 2. API khác
```dart
// Ví dụ API trả về danh sách users
{
  "data": [
    {"id": 1, "username": "user1", "avatar": "url1"},
    {"id": 2, "username": "user2", "avatar": "url2"}
  ],
  "message": "Users retrieved successfully",
  "success": true
}

// Parse
final baseResponse = BaseResponse.fromJson(json);
final userListResponse = UserListResponse.fromBaseResponse(baseResponse);
```

#### 3. API trả về object đơn
```dart
// Ví dụ API trả về thông tin user
{
  "data": {"id": 123, "username": "quocdat", "avatar": "url"},
  "message": "User found",
  "success": true
}

// Parse
final baseResponse = BaseResponse.fromJson(json);
final userResponse = UserResponse.fromBaseResponse(baseResponse);
```

## Migration Guide

### Import Changes
```dart
// Cũ
import 'package:kmonie/entity/user.dart';
import 'package:kmonie/entity/auth_response.dart';

// Mới
import 'package:kmonie/entity/user/user.dart';
import 'package:kmonie/entities/auth_response/auth_response.dart';
```

### Sử dụng BaseResponse
```dart
// Thay vì tạo response class riêng, sử dụng BaseResponse
final response = BaseResponse.fromJson(jsonData);
if (response.success) {
  // Xử lý response.data
} else {
  // Xử lý lỗi response.message
}
```
