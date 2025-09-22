📂 Folder & File Naming

Use snake_case for all folder and file names.

If a folder contains multiple files, create an exports.dart to group and re-export them.

Example:

lib/
  constants/
    color.dart
    text.dart
    income.dart
    exports.dart
  application/
    auth/
      auth_bloc.dart
      auth_event.dart
      auth_state.dart
      exports.dart

📝 Constants

In the constants/ folder, file names should be short and clear.

✅ color.dart, text.dart, income.dart

❌ colors_constants.dart, text_constants.dart

Class Naming Rules:

Use plural form for collections.

class TextConstants {
  static const welcome = "Welcome";
  static const logout = "Logout";
}



For domain-specific constants → add suffix Constants.

class IncomeConstants {
  static const defaultValue = 0;
  static const maxLimit = 1000000;
}

📦 Exports Usage

Create an exports.dart file to re-export multiple files inside a folder.

This makes imports cleaner and easier to maintain.

Example (auth/exports.dart):

export 'auth_bloc.dart';
export 'auth_event.dart';
export 'auth_state.dart';


Usage in other files:

import 'application/auth/exports.dart';

✅ Quick Checklist

 Folder & file → snake_case

 Multiple files in folder → exports.dart

 Constants → short filenames (colors.dart, texts.dart, …)

 Class naming → plural form (Texts), App prefix if conflict (AppColors), Constants suffix if domain-specific (IncomeConstants)

 Always prefer exports.dart for clean imports

 🔄 BLoC Convention
File Naming

Use snake_case with suffix _bloc.dart, _event.dart, _state.dart.

auth_bloc.dart
auth_event.dart
auth_state.dart

Class Naming

Bloc: PascalCase + Bloc

class AuthBloc extends Bloc<AuthEvent, AuthState> { ... }


Event: PascalCase + Event

abstract class AuthEvent {}
class AuthLoginRequested extends AuthEvent {}
class AuthLogoutRequested extends AuthEvent {}


State: PascalCase + State

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnauthenticated extends AuthState {}

Folder Structure
application/
  auth/
    auth_bloc.dart
    auth_event.dart
    auth_state.dart
    exports.dart

Exports

Always create exports.dart inside each Bloc folder.

Example:

export 'auth_bloc.dart';
export 'auth_event.dart';
export 'auth_state.dart';

📦 Import Convention

This section defines the rules for importing files in the KMonie Flutter project.

📌 General Rules

Always use relative imports (../) for files inside the same feature/folder.

Always use package imports (package:kmonie/...) for files from other features or shared code.

Avoid mixing both styles in the same file.

Avoid importing with ../.. too nhiều cấp → dùng exports.dart để gom.

📌 Examples
✅ Correct Usage
// Inside auth_bloc.dart
import 'auth_event.dart';   // relative import (same folder)
import 'auth_state.dart';   // relative import (same folder)

// Importing shared constants
import 'package:kmonie/constants/colors.dart';  

// Importing another feature
import 'package:kmonie/application/user/exports.dart';

❌ Wrong Usage
import '../../constants/colors.dart';   // avoid long relative paths
import 'package:kmonie/application/auth/auth_event.dart'; // should use relative import (same folder)

📌 Exports Usage

Use exports.dart to simplify imports.

In other files, always import from exports.dart instead of multiple direct imports.

Example:

// Instead of:
import 'auth/auth_bloc.dart';
import 'auth/auth_event.dart';
import 'auth/auth_state.dart';

// Do this:
import 'auth/exports.dart';

📌 Third-party Packages

Group third-party imports before project imports.

Separate groups with an empty line.

Example:

// Flutter SDK
import 'package:flutter/material.dart';

// Third-party packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports
import 'package:kmonie/constants/colors.dart';
import 'package:kmonie/application/auth/exports.dart';

📌 Import Ordering

Follow this order for readability:

Dart core libraries (dart:async, dart:convert, …)

Flutter SDK (package:flutter/...)

Third-party packages (package:bloc/..., …)

Project imports (package:kmonie/... or relative)
📦 Import Convention

This section defines the rules for importing files in the KMonie Flutter project.

📌 Import Ordering

Dart core libraries
(dart:async, dart:convert, dart:io, …)

Flutter SDK
(package:flutter/material.dart, package:flutter/widgets.dart, …)

Third-party packages
(package:go_router/go_router.dart, package:flutter_bloc/flutter_bloc.dart, …)

Project imports
(package:kmonie/... hoặc relative imports ../)

📌 Example
// Dart core
import 'dart:async';
import 'dart:convert';

// Flutter SDK
import 'package:flutter/material.dart';

// Third-party packages
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports
import 'package:kmonie/core/navigation/exports.dart';
import 'package:kmonie/entities/exports.dart';
import '../widgets/custom_button.dart';

📌 Rules

Always import external packages before your app’s internal folders.

Separate each group with one empty line.

Within each group:

Sort alphabetically for consistency.

Prefer package:kmonie/... over deep relative imports like ../../core/....

Use exports.dart whenever possible to avoid long import lists.