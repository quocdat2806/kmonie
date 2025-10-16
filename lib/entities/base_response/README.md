# BaseResponse

## Mục đích
BaseResponse là class cơ sở cho tất cả API responses trong ứng dụng, đảm bảo format chuẩn cho mọi response từ server.

## Cấu trúc

### BaseResponse Class
```dart
@freezed
abstract class BaseResponse with _$BaseResponse {
  const factory BaseResponse({
    required dynamic data,    // Dữ liệu trả về (object hoặc array)
    required String message,  // Thông báo từ server
    required bool success,    // Trạng thái thành công/thất bại
  }) = _BaseResponse;
}
```

## Format chuẩn

Tất cả API response đều có format:
```json
{
  "data": "object hoặc array",
  "message": "thông báo từ server",
  "success": true/false
}
```

## Ví dụ sử dụng

### 1. API trả về object đơn
```json
{
  "data": {
    "id": 123,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "message": "User retrieved successfully",
  "success": true
}
```

### 2. API trả về array
```json
{
  "data": [
    {"id": 1, "name": "Item 1"},
    {"id": 2, "name": "Item 2"}
  ],
  "message": "Items retrieved successfully",
  "success": true
}
```

### 3. API trả về lỗi
```json
{
  "data": null,
  "message": "User not found",
  "success": false
}
```

## Cách sử dụng trong code

### 1. Parse response
```dart
final response = BaseResponse.fromJson(jsonData);

if (response.success) {
  // Xử lý dữ liệu thành công
  final data = response.data;
  // ...
} else {
  // Xử lý lỗi
  final errorMessage = response.message;
  // ...
}
```

### 2. Tạo response wrapper
```dart
class UserResponse {
  final User user;
  final String message;
  final bool success;

  UserResponse.fromBaseResponse(BaseResponse response) 
    : user = User.fromJson(response.data as Map<String, dynamic>),
      message = response.message,
      success = response.success;
}
```

### 3. Sử dụng với extension
```dart
extension BaseResponseExtension on BaseResponse {
  User toUser() {
    return User.fromJson(data as Map<String, dynamic>);
  }
  
  List<User> toUserList() {
    final List<dynamic> userList = data as List<dynamic>;
    return userList
        .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
        .toList();
  }
}
```

## Lợi ích

- ✅ **Consistency**: Tất cả API responses có format nhất quán
- ✅ **Error Handling**: Dễ dàng xử lý lỗi với success flag
- ✅ **Flexibility**: Data field có thể chứa bất kỳ kiểu dữ liệu nào
- ✅ **Maintainable**: Dễ dàng thay đổi format response
- ✅ **Type Safety**: Sử dụng Freezed cho type safety

## Best Practices

1. **Luôn check success flag** trước khi xử lý data
2. **Handle null data** khi success = false
3. **Sử dụng extension methods** để convert sang specific types
4. **Validate data type** trước khi cast
5. **Log error messages** để debug

## Integration với các modules khác

- **Authentication**: AuthResponse extends BaseResponse pattern
- **API Client**: Tất cả API calls trả về BaseResponse
- **Error Handling**: Centralized error handling với success flag
- **Repository**: Repository layer parse BaseResponse thành domain objects
