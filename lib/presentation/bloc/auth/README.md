# AuthBloc (UI)

## Mục đích
AuthBloc quản lý UI state của AuthPage, thay thế việc sử dụng setState.

## Cấu trúc

### Events
- `TogglePasswordVisibility`: Toggle hiển thị/ẩn password
- `UpdateUsername`: Cập nhật username từ TextField
- `UpdatePassword`: Cập nhật password từ TextField  
- `ClearFields`: Xóa tất cả fields

### State
- `isPasswordObscured`: Trạng thái hiển thị password (true = ẩn, false = hiển thị)
- `username`: Giá trị username hiện tại
- `password`: Giá trị password hiện tại

## Cách sử dụng

### 1. Import với alias để tránh conflict
```dart
import 'package:kmonie/application/auth/auth.dart';
import 'package:kmonie/presentation/bloc/auth/auth.dart' as ui_auth;
```

### 2. Tối ưu hóa với BlocSelector
```dart
// Chỉ rebuild khi isPasswordObscured thay đổi
BlocSelector<ui_auth.AuthBloc, ui_auth.AuthState, bool>(
  selector: (state) => state.isPasswordObscured,
  builder: (context, isPasswordObscured) {
    return TextField(
      obscureText: isPasswordObscured,
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordObscured
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: () {
          context.read<ui_auth.AuthBloc>().add(
            const ui_auth.AuthEvent.togglePasswordVisibility(),
          );
        },
      ),
    );
  },
)
```

### 3. TextField không cần BlocBuilder
```dart
// Username field không cần rebuild, chỉ cần onChanged
AppTextField(
  controller: _userName,
  onChanged: (value) {
    context.read<ui_auth.AuthBloc>().add(
      ui_auth.AuthEvent.updateUsername(value),
    );
  },
)
```

## Lợi ích của BlocSelector
- ✅ **Performance**: Chỉ rebuild khi selector value thay đổi
- ✅ **Precision**: Tránh rebuild không cần thiết
- ✅ **Clean**: Code rõ ràng, dễ hiểu

## So sánh với BlocBuilder
```dart
// BlocBuilder - rebuild toàn bộ khi state thay đổi
BlocBuilder<ui_auth.AuthBloc, ui_auth.AuthState>(
  builder: (context, state) {
    return TextField(
      obscureText: state.isPasswordObscured, // Chỉ cần field này
      // Nhưng rebuild cả widget khi username/password thay đổi
    );
  },
)

// BlocSelector - chỉ rebuild khi isPasswordObscured thay đổi
BlocSelector<ui_auth.AuthBloc, ui_auth.AuthState, bool>(
  selector: (state) => state.isPasswordObscured,
  builder: (context, isPasswordObscured) {
    return TextField(
      obscureText: isPasswordObscured,
      // Chỉ rebuild khi isPasswordObscured thay đổi
    );
  },
)
```
