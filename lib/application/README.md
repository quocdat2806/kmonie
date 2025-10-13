# Application Layer

## Cấu trúc

### Authentication Module
- **Vị trí**: `lib/application/authentication/`
- **Mục đích**: Quản lý authentication logic (đăng nhập, đăng ký, session)
- **Classes**:
  - `AuthBloc`: Business logic cho authentication
  - `AuthEvent`: Events cho authentication
  - `AuthState`: State cho authentication

### User Module (Tương lai)
- **Vị trí**: `lib/application/user/`
- **Mục đích**: Quản lý user profile và settings

## Naming Convention

### Tránh Conflict
- `application/authentication/` - Authentication business logic
- `presentation/bloc/auth/` - UI state cho auth page

### Import Pattern
```dart
// Authentication business logic
import 'package:kmonie/application/authentication/authentication.dart';

// UI auth bloc (với alias để tránh conflict)
import 'package:kmonie/presentation/bloc/auth/auth.dart' as ui_auth;
```

## Usage Examples

### 1. Authentication Bloc
```dart
// Trong main.dart
final AuthBloc authBloc = AuthBloc(
  di.sl<SecureStorageService>(),
  di.sl<AuthRepository>(),
)..add(const AuthAppStarted());

// Trong widget
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    return state.when(
      loading: () => CircularProgressIndicator(),
      authenticated: (user) => HomePage(user: user),
      unauthenticated: () => LoginPage(),
      error: (message) => ErrorWidget(message),
    );
  },
)
```

### 2. UI Auth Bloc
```dart
// Trong auth page
BlocProvider(
  create: (context) => ui_auth.AuthBloc(),
  child: BlocSelector<ui_auth.AuthBloc, ui_auth.AuthState, bool>(
    selector: (state) => state.isPasswordObscured,
    builder: (context, isPasswordObscured) {
      return TextField(
        obscureText: isPasswordObscured,
        // ...
      );
    },
  ),
)
```

## Architecture Benefits

### ✅ Clear Separation
- Business logic (authentication) vs UI state (auth page)
- No naming conflicts
- Easy to understand and maintain

### ✅ Scalable
- Easy to add new modules (user, settings, etc.)
- Consistent naming pattern
- Clear module boundaries

### ✅ Testable
- Each module can be tested independently
- Clear dependencies
- Easy to mock and isolate
