## KMonie Code Conventions

A concise, practical style guide for building maintainable Flutter code in this repository. Follow the existing architecture and patterns; prefer minimal, additive changes over refactors.

### Table of contents
1. Project structure
2. Naming conventions
3. Dart style and readability
4. Imports and exports
5. Widgets and UI
6. State management (BLoC)
7. Dependency injection (GetIt)
8. Networking (Dio/Retrofit)
9. Models, entities, and mapping (Freezed/Json)
10. Error handling and results
11. Async and streams
12. Performance tips
13. Theming and design system
14. Routing and navigation
15. Localization and accessibility
16. Testing
17. Logging and diagnostics
18. Do & Don’t checklists
19. Tips & tricks

---

### 1) Project structure
Use feature-first organization aligned with Clean Architecture:
```text
lib/
  core/              # base utilities: error, usecase base, navigator, logger
  entity/            # domain entities (immutable)
  data/              # DTOs, mappers, retrofit services, repositories impl
  domain/            # repositories (contracts), use cases
  application/       # BLoC / Cubit per feature
  presentation/      # widgets/screens per feature
  repository/        # (if present) shared repositories
```
Within each feature, add `exports.dart` to simplify imports.

---

### 2) Naming conventions
- Files/folders: snake_case (e.g. `expense_detail_page.dart`).
- Widgets: PascalCase (e.g. `ExpenseDetailPage`).
- BLoC: `FeatureBloc`, events `FeatureXxxRequested`, states `FeatureXxx`.
- Use plural for collections (e.g. `TextConstants`, `AppColors`).
- Domain-specific constants: suffix with `Constants` (e.g. `IncomeConstants`).
- Private members: leading underscore.
- Booleans read naturally: `isEnabled`, `hasError`, `canSubmit`.

---

### 3) Dart style and readability
- Prefer `final` for variables; use `late` sparingly and only when necessary.
- Prefer immutability; avoid mutable shared state.
- Avoid nesting beyond 2–3 levels; extract helpers/widgets.
- Prefer early returns over long `if-else` chains.
- Avoid unnecessary `try/catch`; handle only where you add value.
- Avoid `print`; use the project logger.
- Keep functions short and single-purpose; parameters > 3 → use objects.

---

### 4) Imports and exports
General rules:
- Relative imports for same feature/folder.
- `package:kmonie/...` for shared code or other features.
- Avoid deep `../../..`; use `exports.dart`.
- Group imports: Dart core → Flutter → third-party → project. Separate groups with one blank line, sort alphabetically.

Examples — correct:
```dart
// Inside auth_bloc.dart
import 'auth_event.dart';
import 'auth_state.dart';

import 'package:kmonie/constants/colors.dart';
import 'package:kmonie/application/user/exports.dart';
```

Examples — wrong:
```dart
import '../../constants/colors.dart';
import 'package:kmonie/application/auth/auth_event.dart'; // should be relative
```

Exports usage:
```dart
// Instead of multiple direct imports
import 'auth/exports.dart';
```

---

### 5) Widgets and UI
- Use `StatelessWidget` by default; lift state up; prefer composition.
- Keep widgets small; extract UI sections into private widgets.
- Mark constant subtrees with `const` whenever possible.
- Provide `Key`s for list items and stateful children that can reorder.
- Avoid business logic in widgets; delegate to BLoC/usecases.
- Use theming (`Theme.of(context)`) and shared styles (`AppColors`, text styles).
- Use `BlocBuilder` for UI, `BlocListener` for side-effects (snackbars, navigation). Combine with `BlocConsumer` when appropriate.

---

### 6) State management (BLoC)
- File naming per feature: `feature_bloc.dart`, `feature_event.dart`, `feature_state.dart`.
- Event naming: verb-first, intent-oriented (e.g. `LoadRequested`, `Submitted`).
- State naming: represent UI states (e.g. `Initial`, `Loading`, `Success`, `Failure`).
- Use Freezed for states/events if the project already uses it.
- Separate side-effects from UI state; use `BlocListener` for one-off effects.
- Do not call GetIt directly in widgets; inject repositories/usecases into the BLoC.
- Prefer small, focused BLoCs per screen/feature; avoid god BLoCs.

Example scaffold:
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc({required FeatureUseCase featureUseCase}) : _useCase = featureUseCase, super(const FeatureState.initial()) {
    on<FeatureLoadRequested>(_onLoadRequested);
    on<FeatureSubmitted>(_onSubmitted);
  }

  final FeatureUseCase _useCase;
}
```

---

### 7) Dependency injection (GetIt)
- Register types in a centralized DI file (service locator).
- Use the project’s existing registration pattern (singleton/factory) consistently.
- Inject dependencies into BLoC constructors via providers; do not resolve in widgets.
- Keep DI wiring close to app startup and feature entry points.

---

### 8) Networking (Dio/Retrofit)
- Define Retrofit services with clear method names and DTOs.
- Centralize interceptors (auth headers, logging) and error mapping.
- Do not leak Dio/Retrofit types into domain/presentation.
- Timeouts and retries should be sensible and consistent across services.

---

### 9) Models, entities, and mapping (Freezed/Json)
- DTOs (data layer) mirror API responses; Entities (domain) are UI-friendly and validation-safe.
- Use `json_serializable` for DTOs; use `freezed` for immutable models with unions when helpful.
- Keep mappers isolated and tested; avoid mapping in widgets or BLoC.
- After editing models/freezed/retrofit files, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### 10) Error handling and results
- Convert network/infra errors to domain `Failure` types in repositories.
- Use `Either<Failure, T>` (or equivalent) from usecases to BLoC.
- Map failures to user-friendly messages close to the UI layer.
- Avoid throwing from domain/usecases; prefer typed results.

---

### 11) Async and streams
- Prefer `Future` for one-shot operations, `Stream` for ongoing updates.
- Cancel subscriptions in `close()` for BLoC or `dispose()` for controllers.
- Debounce/throttle user-triggered events where needed (search, typing).
- Avoid `unawaited` futures unless intentionally fire-and-forget (document why).

---

### 12) Performance tips
- Use `const` constructors and literals aggressively.
- Use `ListView.builder`/`GridView.builder` for large lists.
- Provide stable `Key`s to preserve element state during reorders.
- Memoize expensive computations; avoid heavy work in `build()`.
- Use `BlocSelector` to rebuild only when specific fields change.
- Cache images and use proper sizing/`const SizedBox` over `Container` where possible.

---

### 13) Theming and design system
- Centralize colors, text styles, and spacing in shared constants.
- Do not hardcode colors; use `ThemeData` and app-level tokens.
- Keep spacing consistent (e.g., multiples of 4/8).
- Respect dark mode and text scale factors.

---

### 14) Routing and navigation
- Use the project’s router consistently (e.g., `GoRouter` or equivalent).
- Keep routes typed and centralized; avoid stringly-typed routes sprinkled across code.
- Navigate from listeners/effects, not from inside `build()`.

---

### 15) Localization and accessibility
- All user-facing strings must be in l10n; avoid inline literals.
- Provide semantics for icons and tappable widgets.
- Ensure minimum touch target sizes and contrast ratios.

---

### 16) Testing
- Unit test: mappers, usecases, repositories (with mocks).
- Widget test: rendering, interactions, basic flows.
- BLoC test: events → expected states; test side-effects via mocks.
- Keep tests deterministic; avoid real network or timers.

---

### 17) Logging and diagnostics
- Use the shared logger; do not use `print`.
- Log at boundaries (network request/response, critical decisions), not everywhere.
- Never log sensitive information (tokens, PII).

---

### 18) Do & Don’t checklists

Do:
- Keep functions small and focused; extract private helpers.
- Use `exports.dart` to keep imports clean.
- Prefer `final` and immutability.
- Handle errors once; convert to domain failures early.
- Write tests for business logic and critical flows.

Don’t:
- Don’t resolve DI inside widgets.
- Don’t put networking or persistence code in BLoC/UI.
- Don’t overuse single giant BLoCs for multiple screens.
- Don’t leak DTOs beyond data layer.
- Don’t add new packages unless strictly necessary.

---

### 19) Tips & tricks
- Use `BlocListener` for one-shot effects (snackbar, dialog, navigation).
- Prefer `SizedBox` over `Container` for simple spacing.
- Use `copyWith` from `freezed` models to update immutable state.
- For forms, keep a single source of truth in BLoC; debounce input.
- When in doubt about imports, create/extend `exports.dart` in the feature.

---

Appendix: constants and exports patterns

Constants example:
```dart
class TextConstants {
  static const welcome = "Welcome";
  static const logout = "Logout";
}

class IncomeConstants {
  static const defaultValue = 0;
  static const maxLimit = 1000000;
}
```

Exports example:
```dart
// application/auth/exports.dart
export 'auth_bloc.dart';
export 'auth_event.dart';
export 'auth_state.dart';
```

