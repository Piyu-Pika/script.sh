#!/bin/bash

# Colors for better visibility
GREEN="\033[0;32m"
BLUE="\033[0;34m"  # Fixed color code
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Exit on error
set -e

# Function to display banner
display_banner() {
    echo -e "
${BLUE}================================================${NC}"
    echo -e "${GREEN}          Project Structure Generator          ${NC}"
    echo -e "${BLUE}================================================${NC}
"
}

# Function to create Flutter project with Clean Architecture or MVVM
create_flutter_structure() {
    local project_name="$1"
    local org="$2"

    # Prompt for architecture type
    PS3=$'\n'$"Choose architecture type: "
    arch_options=("Clean Architecture" "MVVM")
    select arch_choice in "${arch_options[@]}"; do  # Fixed to use arch_options
        case $arch_choice in
            "Clean Architecture")
                architecture="clean"
                break
                ;;
            "MVVM")
                architecture="mvvm"
                break
                ;;
            *)
                echo -e "${RED}Invalid option!${NC}"
                continue
                ;;
        esac
    done

    # Prompt for state management
    PS3=$'\n'$"Choose state management solution: "
    options=("BLoC" "Riverpod" "GetX" "Provider" "None/Add later")
    select sm_choice in "${options[@]}"; do
        case $sm_choice in
            "BLoC")
                packages=("bloc: ^8.1.0" "flutter_bloc: ^8.1.0")
                state_dir="bloc"
                ;;
            "Riverpod")
                packages=("flutter_riverpod: ^2.3.0" "riverpod_annotation: ^2.2.0")
                state_dir="providers"
                ;;
            "GetX")
                packages=("get: ^4.6.5")
                state_dir="controllers"
                ;;
            "Provider")
                packages=("provider: ^6.1.1")
                state_dir="providers"
                ;;
            "None/Add later")
                echo -e "${YELLOW}No state management will be added${NC}"
                state_dir="none"
                packages=()
                ;;
            *)
                echo -e "${RED}Invalid option!${NC}"
                continue
                ;;
        esac
        break
    done

    echo -e "${GREEN}Creating Flutter project: ${BLUE}$project_name${NC}"

    # Run the Flutter create command with the organization parameter
    flutter create --org "$org" "$project_name"

    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create Flutter project. Make sure Flutter is installed correctly.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Flutter project created successfully. Setting up $arch_choice...${NC}"

    # Navigate to the project directory
    cd "$project_name"

    # Backup the main.dart file
    cp lib/main.dart lib/main.dart.bak

    # Create folder structure based on architecture
    if [ "$architecture" == "clean" ]; then
        echo -e "${GREEN}Creating Clean Architecture folder structure in ${BLUE}lib${NC}"
        mkdir -p "lib/core/constants"
        mkdir -p "lib/core/errors"
        mkdir -p "lib/core/network"
        mkdir -p "lib/core/usecases"
        mkdir -p "lib/core/utils"
        mkdir -p "lib/core/widgets"
        mkdir -p "lib/features"
        mkdir -p "lib/features/auth/data/datasources/local"
        mkdir -p "lib/features/auth/data/datasources/remote"
        mkdir -p "lib/features/auth/data/models"
        mkdir -p "lib/features/auth/data/repositories"
        mkdir -p "lib/features/auth/domain/entities"
        mkdir -p "lib/features/auth/domain/repositories"
        mkdir -p "lib/features/auth/domain/usecases"
        mkdir -p "lib/features/auth/presentation/pages"
        mkdir -p "lib/features/auth/presentation/widgets"
        mkdir -p "lib/config/routes"
        mkdir -p "lib/config/themes"
        mkdir -p "lib/di"
        mkdir -p "test/features/auth/data"
        mkdir -p "test/features/auth/domain"
        mkdir -p "test/features/auth/presentation"
        mkdir -p "test/core"
    else
        echo -e "${GREEN}Creating MVVM folder structure in ${BLUE}lib${NC}"
        mkdir -p "lib/models"
        mkdir -p "lib/view_models"
        mkdir -p "lib/views"
        mkdir -p "lib/utils"
        mkdir -p "lib/widgets"
        mkdir -p "lib/config/themes"
        mkdir -p "lib/config/routes"
        mkdir -p "test/models"
        mkdir -p "test/view_models"
        mkdir -p "test/views"
    fi

    # Create state management structure based on user choice
    if [[ "$state_dir" != "none" ]]; then
        if [ "$architecture" == "clean" ]; then
            case "$sm_choice" in
                "BLoC")
                    mkdir -p "lib/core/bloc"
                    mkdir -p "lib/features/auth/presentation/bloc"
                    ;;
                "Riverpod")
                    mkdir -p "lib/core/providers"
                    mkdir -p "lib/features/auth/presentation/providers"
                    ;;
                "GetX")
                    mkdir -p "lib/core/controllers"
                    mkdir -p "lib/features/auth/presentation/controllers"
                    ;;
                "Provider")
                    mkdir -p "lib/core/providers"
                    mkdir -p "lib/features/auth/presentation/providers"
                    ;;
            esac
        else
            case "$sm_choice" in
                "BLoC")
                    mkdir -p "lib/view_models/bloc"
                    ;;
                "Riverpod")
                    mkdir -p "lib/view_models/providers"
                    ;;
                "GetX")
                    mkdir -p "lib/view_models/controllers"
                    ;;
                "Provider")
                    mkdir -p "lib/view_models/providers"
                    ;;
            esac
        fi
    fi

    # Create files based on architecture
    if [ "$architecture" == "mvvm" ]; then
        # Create placeholder files for MVVM
        touch "lib/app.dart"
        touch "lib/models/user_model.dart"
        touch "lib/view_models/auth_view_model.dart"
        touch "lib/views/auth_view.dart"
        touch "lib/utils/app_constants.dart"
        touch "lib/config/themes/app_theme.dart"
        touch "lib/config/routes/app_routes.dart"

        # Create main.dart for MVVM
        cat > "lib/main.dart" << EOF
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}
EOF

        # Create app.dart for MVVM
        cat > "lib/app.dart" << EOF
import 'package:flutter/material.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$project_name',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to MVVM Architecture'),
        ),
      ),
    );
  }
}
EOF

        # Create user_model.dart
        cat > "lib/models/user_model.dart" << EOF
class UserModel {
  final String id;
  final String email;
  final String name;

  UserModel({required this.id, required this.email, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}
EOF

        # Create auth_view.dart (base template, updated later with state management)
        cat > "lib/views/auth_view.dart" << EOF
import 'package:flutter/material.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('MVVM Auth Screen'),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement login
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

        # Create app_theme.dart
        cat > "lib/config/themes/app_theme.dart" << EOF
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
EOF

        # Create app_routes.dart
        cat > "lib/config/routes/app_routes.dart" << EOF
class AppRoutes {
  static const String auth = '/auth';
}
EOF

        # Create app_constants.dart
        cat > "lib/utils/app_constants.dart" << EOF
class AppConstants {
  static const String appName = '$project_name';
}
EOF

        # Add state management for MVVM
        case "$sm_choice" in
            "BLoC")
                cat > "lib/view_models/auth_view_model.dart" << EOF
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthViewModel extends Bloc<AuthEvent, AuthState> {
  AuthViewModel() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(AuthSuccess(UserModel(id: "1", email: event.email, name: "User")));
    });
  }
}
EOF
                cat > "lib/view_models/auth_event.dart" << EOF
part of 'auth_view_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}
EOF
                cat > "lib/view_models/auth_state.dart" << EOF
part of 'auth_view_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
EOF
                cat > "lib/views/auth_view.dart" << EOF
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_models/auth_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocBuilder<AuthViewModel, AuthState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is AuthLoading)
                    const CircularProgressIndicator(),
                  if (state is AuthSuccess)
                    Text('Welcome, ${state.user.name}!'),
                  if (state is AuthError)
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthViewModel>().add(LoginEvent('test@example.com', 'password'));
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
EOF
                ;;
            "Riverpod")
                cat > "lib/view_models/auth_view_model.dart" << EOF
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, UserModel? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    state = state.copyWith(
      isLoading: false,
      user: UserModel(id: "1", email: email, name: "User"),
    );
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) => AuthViewModel());
EOF
                cat > "lib/views/auth_view.dart" << EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/auth_view_model.dart';

class AuthView extends ConsumerWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (authState.isLoading)
              const CircularProgressIndicator(),
            if (authState.user != null)
              Text('Welcome, ${authState.user!.name}!'),
            if (authState.error != null)
              Text(authState.error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () {
                ref.read(authViewModelProvider.notifier).login('test@example.com', 'password');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF
                ;;
            "GetX")
                cat > "lib/view_models/auth_view_model.dart" << EOF
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthViewModel extends GetxController {
  final isLoading = false.obs;
  final user = Rx<UserModel?>(null);
  final error = RxString('');

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    isLoading.value = false;
    user.value = UserModel(id: "1", email: email, name: "User");
  }
}
EOF
                cat > "lib/views/auth_view.dart" << EOF
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/auth_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthViewModel());

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Obx(() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.isLoading.value)
                  const CircularProgressIndicator(),
                if (controller.user.value != null)
                  Text('Welcome, ${controller.user.value!.name}!'),
                if (controller.error.value.isNotEmpty)
                  Text(controller.error.value, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: () {
                    controller.login('test@example.com', 'password');
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          )),
    );
  }
}
EOF
                ;;
            "Provider")
                cat > "lib/view_models/auth_view_model.dart" << EOF
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthViewModel with ChangeNotifier {
  bool _isLoading = false;
  UserModel? _user;
  String? _error;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    _isLoading = false;
    _user = UserModel(id: "1", email: email, name: "User");
    notifyListeners();
  }
}
EOF
                cat > "lib/views/auth_view.dart" << EOF
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.isLoading)
                    const CircularProgressIndicator(),
                  if (viewModel.user != null)
                    Text('Welcome, ${viewModel.user!.name}!'),
                  if (viewModel.error != null)
                    Text(viewModel.error!, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.login('test@example.com', 'password');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
EOF
                ;;
            "None/Add later")
                cat > "lib/view_models/auth_view_model.dart" << EOF
import '../models/user_model.dart';

class AuthViewModel {
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return UserModel(id: "1", email: email, name: "User");
  }
}
EOF
                cat > "lib/views/auth_view.dart" << EOF
import 'package:flutter/material.dart';
import '../view_models/auth_view_model.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _viewModel = AuthViewModel();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () async {
                setState(() => _isLoading = true);
                final user = await _viewModel.login('test@example.com', 'password');
                setState(() => _isLoading = false);
                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Welcome, ${user.name}!')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF
                ;;
        esac
    else
        # Clean Architecture files
        touch "lib/app.dart"
        touch "lib/di/injection_container.dart"
        touch "lib/core/constants/app_constants.dart"
        touch "lib/core/errors/failures.dart"
        touch "lib/core/errors/exceptions.dart"
        touch "lib/core/network/network_info.dart"
        touch "lib/core/usecases/usecase.dart"
        touch "lib/config/routes/app_routes.dart"
        touch "lib/config/themes/app_theme.dart"

        cat > "lib/main.dart" << EOF
import 'package:flutter/material.dart';
import 'app.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
EOF

        cat > "lib/app.dart" << EOF
import 'package:flutter/material.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$project_name',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Clean Architecture'),
        ),
      ),
    );
  }
}
EOF

        cat > "lib/di/injection_container.dart" << EOF
// This file will contain the dependency injection setup
// using get_it or any other DI solution

Future<void> init() async {
  // Features
  // Core
  // External
  // State Management
EOF

        # Add state management for Clean Architecture
        case "$sm_choice" in
            "BLoC")
                cat >> "lib/di/injection_container.dart" << EOF
  // BLoC dependencies
  // example: sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
EOF
                cat > "lib/features/auth/presentation/bloc/auth_bloc.dart" << EOF
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(event.params);
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (success) => emit(AuthSuccess()),
      );
    });
  }
}
EOF
                cat > "lib/features/auth/presentation/bloc/auth_event.dart" << EOF
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final dynamic params;
  LoginEvent(this.params);
}
EOF
                cat > "lib/features/auth/presentation/bloc/auth_state.dart" << EOF
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
EOF
                ;;
            "Riverpod")
                cat >> "lib/di/injection_container.dart" << 'EOF'
  // Riverpod setup
  // example: final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
EOF
                cat > "lib/features/auth/presentation/providers/auth_provider.dart" << EOF
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  @override
  List<Object?> get props => [isLoading, error, isAuthenticated];
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;

  AuthNotifier(this.loginUseCase) : super(const AuthState());

  Future<void> login(dynamic params) async {
    state = state.copyWith(isLoading: true);
    final result = await loginUseCase(params);
    result.fold(
      (failure) => state = state.copyWith(error: failure.toString()),
      (success) => state = state.copyWith(isAuthenticated: true),
    );
    state = state.copyWith(isLoading: false);
  }

  void resetError() => state = state.copyWith(error: null);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(loginUseCaseProvider));
});
EOF
                ;;
            "GetX")
                cat >> "lib/di/injection_container.dart" << EOF
  // GetX controllers
  // example: Get.put(AuthController());
EOF
                cat > "lib/features/auth/presentation/controllers/auth_controller.dart" << EOF
import 'package:get/get.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;

  AuthController({required this.loginUseCase});

  final isLoading = false.obs;
  final error = RxString('');
  final isAuthenticated = false.obs;

  Future<void> login(dynamic params) async {
    isLoading.value = true;
    final result = await loginUseCase(params);
    result.fold(
      (failure) => error.value = failure.toString(),
      (success) => isAuthenticated.value = true,
    );
    isLoading.value = false;
  }

  void resetError() => error.value = '';
}
EOF
                ;;
            "Provider")
                cat >> "lib/di/injection_container.dart" << EOF
  // Provider setup
  // example: sl.registerFactory(() => AuthProvider(sl()));
EOF
                cat > "lib/features/auth/presentation/providers/auth_provider.dart" << EOF
import 'package:flutter/foundation.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthProvider({required this.loginUseCase});

  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(dynamic params) async {
    _isLoading = true;
    notifyListeners();

    final result = await loginUseCase(params);
    result.fold(
      (failure) => _error = failure.toString(),
      (success) => _isAuthenticated = true,
    );

    _isLoading = false;
    notifyListeners();
  }

  void resetError() {
    _error = null;
    notifyListeners();
  }
}
EOF
                ;;
        esac

        cat >> "lib/di/injection_container.dart" << EOF
}

// GetIt dependency container
final sl = GetIt.instance;
EOF

        # Create sample login usecase and repository
        if [[ "$state_dir" != "none" ]]; then
            cat > "lib/features/auth/domain/usecases/login_usecase.dart" << EOF
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, bool>> call(params) async {
    return await repository.login(params);
  }
}
EOF

            cat > "lib/features/auth/data/repositories/auth_repository_impl.dart" << EOF
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> login(params) async {
    try {
      final result = await remoteDataSource.login(params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
EOF

            cat > "lib/features/auth/data/datasources/remote/auth_remote_datasource.dart" << EOF
abstract class AuthRemoteDataSource {
  Future<bool> login(params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> login(params) async {
    // API call implementation
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
EOF
        fi

        cat > "lib/config/themes/app_theme.dart" << EOF
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
EOF

        cat > "lib/core/usecases/usecase.dart" << EOF
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class Params {}

class NoParams extends Params {}

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
EOF

        cat > "lib/core/errors/failures.dart" << EOF
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}
class CacheFailure extends Failure {}
class NetworkFailure extends Failure {}
EOF
    fi

    # Create README
    if [ "$architecture" == "mvvm" ]; then
        cat > "README.md" << EOF
# $project_name

A Flutter project using MVVM architecture, suitable for small to medium-sized projects.

## Project Structure

The project follows MVVM (Model-View-ViewModel) architecture:
- \`lib/models/\`: Data models
- \`lib/view_models/\`: Business logic and state management
- \`lib/views/\`: UI screens
- \`lib/utils/\`: Utility functions
- \`lib/widgets/\`: Reusable widgets
- \`lib/config/\`: App configuration (themes, routes)

State management: $sm_choice
Located in: \`lib/view_models/$state_dir\`

## Getting Started

Added dependencies:
${packages[@]}

1. Run \`flutter pub get\` to install dependencies.
2. Start the app with \`flutter run\`.
EOF
    else
        cat > "README.md" << EOF
# $project_name

A Flutter project using Clean Architecture.

## Project Structure

The project includes:
${sm_choice} state management in:
\`lib/features/**/presentation/$state_dir\`

## Getting Started

Added dependencies:
${packages[@]}
EOF
    fi

    # Update pubspec.yaml
    echo -e "${YELLOW}Updating pubspec.yaml with required dependencies...${NC}"
    if [ "$architecture" == "mvvm" ]; then
        packages=("${packages[@]}" "equatable: ^2.0.5" "http: ^0.13.5" "shared_preferences: ^2.0.15")
    else
        packages=("${packages[@]}" "dartz: ^0.10.1" "equatable: ^2.0.5" "http: ^0.13.5" "shared_preferences: ^2.0.15")
    fi

    cat >> "pubspec.yaml" << EOF

dependencies:
  flutter:
    sdk: flutter
  # Core Dependencies
${packages[@]/#/  }
EOF

    cd ..

    echo -e "\n${GREEN}Flutter project with $arch_choice created successfully!${NC}"
    echo -e "${YELLOW}Don't forget to run 'flutter pub get' to install the additional dependencies.${NC}"
}


# Function to create Go project structure
create_go_structure() {
    local project_name="$1"
    
    echo -e "${GREEN}Creating Go project structure for ${BLUE}$project_name${NC}"

    # Create project root directory
    mkdir -p "${project_name}"

    # Create directory structure
    mkdir -p "${project_name}/cmd/${project_name}" \
             "${project_name}/internal/config" \
             "${project_name}/internal/handlers" \
             "${project_name}/internal/models" \
             "${project_name}/internal/services" \
             "${project_name}/pkg/utils" \
             "${project_name}/api" \
             "${project_name}/web" \
             "${project_name}/configs" \
             "${project_name}/scripts" \
             "${project_name}/test" \
             "${project_name}/docs"

    # Create main.go entry point
    touch "${project_name}/cmd/${project_name}/main.go"

    # Initialize Go module
    (cd "${project_name}" && go mod init "$project_name" 2>/dev/null)

    # Create README.md
    cat > "${project_name}/README.md" << EOF
# ${project_name}

A Go project with a clean and organized structure.

## Project Structure

\`\`\`
${project_name}/
├── api/                # API definitions (like proto files, OpenAPI specs)
├── cmd/                # Main applications
│   └── ${project_name}/    # Main application entry point
├── configs/            # Configuration files
├── docs/               # Documentation files
├── internal/           # Private application code
│   ├── config/         # Internal configuration
│   ├── handlers/       # HTTP handlers
│   ├── models/         # Data models
│   └── services/       # Business logic
├── pkg/                # Public library code
│   └── utils/          # Utility functions
├── scripts/            # Scripts for development, CI, etc.
├── test/               # Additional test files
└── web/                # Web assets
\`\`\`

## Getting Started

\`\`\`bash
# Run the application
go run cmd/${project_name}/main.go
\`\`\`
EOF

    # Create .gitignore
    cat > "${project_name}/.gitignore" << EOF
# Binaries for programs and plugins
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with go test -c
*.test

# Output of the go coverage tool
*.out

# Go workspace file
go.work

# Binary output
bin/

# IDE specific files
.idea/
.vscode/
*.swp
*.swo

# OS specific files
.DS_Store
EOF

    echo -e "\n${GREEN}Go project structure created successfully!${NC}"
}

# Function to create Node.js project structure
create_nodejs_structure() {
    local project_name="$1"
    
    echo -e "\n${GREEN}Creating Node.js project structure for:${NC} ${BLUE}$project_name${NC}\n"

    # Create the project directory
    mkdir -p "$project_name"
    cd "$project_name"

    # Function to create directory and print status
    create_dir() {
        mkdir -p "$1"
        echo -e "${GREEN}Created:${NC} $1"
    }

    # Function to create a simple file with content
    create_file() {
        local file_path="$1"
        local content="$2"
        
        # Create the directory if it doesn't exist
        local dir_path=$(dirname "$file_path")
        mkdir -p "$dir_path"
        
        # Create the file with content
        echo -e "$content" > "$file_path"
        echo -e "${BLUE}Created file:${NC} $file_path"
    }

    # Create standard directories
    create_dir "src/api/controllers"
    create_dir "src/api/middlewares"
    create_dir "src/api/routes"
    create_dir "src/api/services"
    create_dir "src/api/validators"
    create_dir "src/config"
    create_dir "src/db/models"
    create_dir "src/db/migrations"
    create_dir "src/db/seeders"
    create_dir "src/utils"
    create_dir "src/helpers"
    create_dir "public/assets/images"
    create_dir "public/assets/css"
    create_dir "public/assets/js"
    create_dir "views"
    create_dir "tests/unit"
    create_dir "tests/integration"
    create_dir "scripts"
    create_dir "logs"

    # Create initial package.json
    create_file "package.json" '{
  "name": "'$project_name'",
  "version": "1.0.0",
  "description": "A Node.js application",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1",
    "winston": "^3.10.0"
  },
  "devDependencies": {
    "eslint": "^8.47.0",
    "jest": "^29.6.2",
    "nodemon": "^3.0.1"
  }
}'

    # Create main app file
    create_file "src/index.js" "const express = require('express');
const path = require('path');
const config = require('./config');
const logger = require('./utils/logger');
const routes = require('./api/routes');

// Initialize express app
const app = express();

// Middleware setup
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '../public')));

// Routes
app.use('/api', routes);

// Default route
app.get('/', (req, res) => {
  res.send('Welcome to $project_name API');
});

// Error handler
app.use((err, req, res, next) => {
  logger.error(err.stack);
  res.status(500).send('Something broke!');
});

// Start server
const PORT = config.port || 3000;
app.listen(PORT, () => {
  logger.info(\`Server is running on port \${PORT}\`);
});

module.exports = app; // For testing
"

    # Create config file
    create_file "src/config/index.js" "require('dotenv').config();

module.exports = {
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  dbConfig: {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || '$project_name',
    username: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres'
  },
  jwtSecret: process.env.JWT_SECRET || 'your-secret-key',
  // Add other configuration as needed
};
"

    # Create logger utility
    create_file "src/utils/logger.js" "const winston = require('winston');
const path = require('path');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  defaultMeta: { service: '$project_name' },
  transports: [
    // Write all logs to console
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    }),
    // Write all logs to file
    new winston.transports.File({
      filename: path.join(__dirname, '../../logs/error.log'),
      level: 'error',
    }),
    new winston.transports.File({
      filename: path.join(__dirname, '../../logs/combined.log'),
    }),
  ],
});

module.exports = logger;
"

    # Create routes index
    create_file "src/api/routes/index.js" "const express = require('express');
const router = express.Router();

// Import route modules
// const userRoutes = require('./user.routes');
// const authRoutes = require('./auth.routes');

// Define routes
// router.use('/users', userRoutes);
// router.use('/auth', authRoutes);

// Health check route
router.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Server is healthy' });
});

module.exports = router;
"

    # Create a sample controller
    create_file "src/api/controllers/sample.controller.js" "/**
 * Sample controller with CRUD operations
 */

// Get all items
exports.getAll = async (req, res, next) => {
  try {
    // Logic to get all items
    res.status(200).json({ message: 'Get all items' });
  } catch (error) {
    next(error);
  }
};

// Get item by ID
exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Logic to get item by ID
    res.status(200).json({ message: \`Get item with ID \${id}\` });
  } catch (error) {
    next(error);
  }
};

// Create a new item
exports.create = async (req, res, next) => {
  try {
    const data = req.body;
    // Logic to create a new item
    res.status(201).json({ message: 'Item created successfully', data });
  } catch (error) {
    next(error);
  }
};

// Update an item
exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const data = req.body;
    // Logic to update the item
    res.status(200).json({ message: \`Item \${id} updated successfully\`, data });
  } catch (error) {
    next(error);
  }
};

// Delete an item
exports.delete = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Logic to delete the item
    res.status(200).json({ message: \`Item \${id} deleted successfully\` });
  } catch (error) {
    next(error);
  }
};
"

    # Create a sample service
    create_file "src/api/services/sample.service.js" "/**
 * Sample service with business logic
 */

// Get all items
exports.findAll = async () => {
  try {
    // Database query or other logic
    return [
      { id: 1, name: 'Item 1' },
      { id: 2, name: 'Item 2' }
    ];
  } catch (error) {
    throw error;
  }
};

// Get item by ID
exports.findById = async (id) => {
  try {
    // Database query or other logic
    return { id, name: \`Item \${id}\` };
  } catch (error) {
    throw error;
  }
};

// Create a new item
exports.create = async (data) => {
  try {
    // Database insert or other logic
    return { id: Date.now(), ...data };
  } catch (error) {
    throw error;
  }
};

// Update an item
exports.update = async (id, data) => {
  try {
    // Database update or other logic
    return { id, ...data };
  } catch (error) {
    throw error;
  }
};

// Delete an item
exports.delete = async (id) => {
  try {
    // Database delete or other logic
    return true;
  } catch (error) {
    throw error;
  }
};
"

    # Create a sample middleware
    create_file "src/api/middlewares/auth.middleware.js" "/**
 * Authentication middleware
 */

exports.authenticate = (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Authentication required' });
    }
    
    const token = authHeader.split(' ')[1];
    
    // Verify token (implement your token verification logic)
    // const decoded = jwt.verify(token, config.jwtSecret);
    // req.user = decoded;
    
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Invalid token' });
  }
};

exports.authorize = (roles = []) => {
  return (req, res, next) => {
    // Ensure user exists after authentication
    if (!req.user) {
      return res.status(401).json({ message: 'Authentication required' });
    }
    
    // Check if user role is permitted
    if (roles.length && !roles.includes(req.user.role)) {
      return res.status(403).json({ message: 'Forbidden: insufficient permissions' });
    }
    
    next();
  };
};
"

    # Create .env file
    create_file ".env" "# Server Configuration
NODE_ENV=development
PORT=3000

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=$project_name
DB_USER=postgres
DB_PASSWORD=postgres

# JWT Configuration
JWT_SECRET=your-secret-key

# Logging
LOG_LEVEL=info
"

    # Create .env.example file
    create_file ".env.example" "# Server Configuration
NODE_ENV=development
PORT=3000

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=dbname
DB_USER=username
DB_PASSWORD=password

# JWT Configuration
JWT_SECRET=your-secret-key

# Logging
LOG_LEVEL=info
"

    # Create .gitignore file
    create_file ".gitignore" "# Dependencies
node_modules/
npm-debug.log
yarn-debug.log
yarn-error.log

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/

# Logs
logs/
*.log

# Coverage directory used by tools like istanbul
coverage/

# Editor directories and files
.idea/
.vscode/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
"

    # Create README.md
    create_file "README.md" "# $project_name

A Node.js application with an organized and scalable structure.

## Project Structure

\`\`\`
$project_name/
├── src/                    # Source files
│   ├── api/                # API related files
│   │   ├── controllers/    # Request handlers
│   │   ├── middlewares/    # Express middlewares
│   │   ├── routes/         # Route definitions
│   │   ├── services/       # Business logic
│   │   └── validators/     # Input validation
│   ├── config/             # Configuration files
│   ├── db/                 # Database related files
│   │   ├── models/         # Database models
│   │   ├── migrations/     # Database migrations
│   │   └── seeders/        # Database seeders
│   ├── utils/              # Utility functions
│   ├── helpers/            # Helper functions
│   └── index.js            # Application entry point
├── public/                 # Static files
│   └── assets/             # Asset files (images, css, js)
├── views/                  # View templates (if using a view engine)
├── tests/                  # Test files
│   ├── unit/               # Unit tests
│   └── integration/        # Integration tests
├── scripts/                # Scripts for deployment, etc.
├── logs/                   # Log files
├── package.json            # Project metadata and dependencies
├── .env                    # Environment variables
├── .env.example            # Example environment variables
├── .gitignore              # Git ignore rules
└── README.md               # Project documentation
\`\`\`

## Installation

\`\`\`bash
# Clone the repository
git clone <repository-url>
cd $project_name

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env
# Edit .env to match your environment

# Start the server
npm start
\`\`\`

## Development

\`\`\`bash
# Run in development mode with hot reload
npm run dev

# Run tests
npm test

# Lint code
npm run lint

# Fix linting issues
npm run lint:fix
\`\`\`

## API Endpoints

- GET /api/health - Health check endpoint
- Additional endpoints will be documented here

## License

ISC
"

    # Create a basic Jest config for testing
    create_file "jest.config.js" "module.exports = {
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/index.js',
  ],
  testMatch: [
    '**/tests/**/*.test.js',
  ],
};
"

    # Create a sample test file
    create_file "tests/unit/sample.test.js" "describe('Sample Test Suite', () => {
  test('should pass a simple test', () => {
    expect(1 + 1).toBe(2);
  });
});
"

    # Create a basic ESLint config
    create_file ".eslintrc.js" "module.exports = {
  env: {
    node: true,
    commonjs: true,
    es2021: true,
    jest: true,
  },
  extends: 'eslint:recommended',
  parserOptions: {
    ecmaVersion: 12,
  },
  rules: {
    'no-console': 'warn',
    'no-unused-vars': ['error', { argsIgnorePattern: 'next' }],
  },
};
"

    # Initialize git repository
    git init > /dev/null 2>&1
    echo -e "${BLUE}Initialized Git repository${NC}"

    # Return to the parent directory
    cd ..

    echo -e "\n${GREEN}Node.js project structure created successfully!${NC}"
}

# Function to create FastAPI project structure
create_fastapi_structure() {
    local project_name="$1"
    echo -e "${GREEN}Creating FastAPI project structure for ${BLUE}$project_name${NC}"
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name"

    echo -e "${GREEN}Creating project structure...${NC}"

    # Create main directories
    mkdir -p app/{api,core,db,models,schemas,services,utils}
    mkdir -p tests/{api,services,utils}

    # Create API structure
    mkdir -p app/api/{endpoints,dependencies}
    touch app/api/__init__.py
    touch app/api/endpoints/__init__.py
    touch app/api/dependencies/__init__.py

    # Create core components
    touch app/core/__init__.py
    touch app/core/config.py
    touch app/core/security.py

    # Create database components
    touch app/db/__init__.py
    touch app/db/base.py
    touch app/db/session.py

    # Create models
    touch app/models/__init__.py
    touch app/models/base.py

    # Create schemas
    touch app/schemas/__init__.py
    touch app/schemas/base.py

    # Create services
    touch app/services/__init__.py

    # Create utils
    touch app/utils/__init__.py

    # Create main application files
    touch app/__init__.py
    touch app/main.py

    # Create test files
    touch tests/__init__.py
    touch tests/conftest.py

    # Create requirements files
    touch requirements.txt
    touch requirements-dev.txt

    # Create README and .gitignore
    touch README.md
    touch .gitignore

    # Create docker files
    touch Dockerfile
    touch docker-compose.yml

    # Populate .gitignore
    cat > .gitignore << EOL
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
ENV/
.env

# IDE
.idea/
.vscode/
*.swp
*.swo

# Logs
logs/
*.log

# Local development
.DS_Store
EOL

    # Populate requirements.txt
    cat > requirements.txt << EOL
fastapi>=0.100.0
uvicorn>=0.22.0
pydantic>=2.0.0
sqlalchemy>=2.0.0
alembic>=1.11.0
python-dotenv>=1.0.0
httpx>=0.24.0
pytest>=7.3.0
EOL

    # Populate requirements-dev.txt
    cat > requirements-dev.txt << EOL
-r requirements.txt
black>=23.3.0
isort>=5.12.0
flake8>=6.0.0
mypy>=1.3.0
pytest-cov>=4.1.0
EOL

    # Populate config.py
    cat > app/core/config.py << EOL
from pydantic import ConfigDict
from pydantic_settings import BaseSettings
from typing import List, Optional, Dict, Any
import os

class Settings(BaseSettings):
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "$project_name"
    
    # CORS
    BACKEND_CORS_ORIGINS: List[str] = ["http://localhost:8000", "http://localhost:3000"]
    
    # Database
    DATABASE_URL: str = "sqlite:///./app.db"
    
    # Security
    SECRET_KEY: str = "your-secret-key-here"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 days
    
    model_config = ConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
    )

settings = Settings()
EOL

    # Populate main.py
    cat > app/main.py << EOL
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.api.endpoints import api_router

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
)

# Set all CORS enabled origins
if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/")
def root():
    return {"message": "Welcome to $project_name API"}

if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
EOL

    # Populate api_router
    cat > app/api/__init__.py << EOL
from fastapi import APIRouter

from app.api.endpoints import items, users

api_router = APIRouter()
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(items.router, prefix="/items", tags=["items"])
EOL

    # Create sample endpoint files
    mkdir -p app/api/endpoints
    cat > app/api/endpoints/__init__.py << EOL
from fastapi import APIRouter

api_router = APIRouter()
EOL

    # Users endpoint
    cat > app/api/endpoints/users.py << EOL
from fastapi import APIRouter, HTTPException

router = APIRouter()

@router.get("/")
async def get_users():
    return {"message": "List of users"}

@router.get("/{user_id}")
async def get_user(user_id: int):
    return {"message": f"User {user_id}"}

@router.post("/")
async def create_user():
    return {"message": "User created"}
EOL

    # Items endpoint
    cat > app/api/endpoints/items.py << EOL
from fastapi import APIRouter, HTTPException

router = APIRouter()

@router.get("/")
async def get_items():
    return {"message": "List of items"}

@router.get("/{item_id}")
async def get_item(item_id: int):
    return {"message": f"Item {item_id}"}

@router.post("/")
async def create_item():
    return {"message": "Item created"}
EOL

    # Create sample test
    mkdir -p tests/api
    cat > tests/conftest.py << EOL
import pytest
from fastapi.testclient import TestClient

from app.main import app

@pytest.fixture
def client():
    with TestClient(app) as test_client:
        yield test_client
EOL

    cat > tests/api/test_users.py << EOL
from fastapi.testclient import TestClient

def test_get_users(client: TestClient):
    response = client.get("/api/v1/users/")
    assert response.status_code == 200
    assert "message" in response.json()
EOL

    # Create Dockerfile
    cat > Dockerfile << EOL
FROM python:3.11-slim

WORKDIR /app/

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOL

    # Create docker-compose.yml
    cat > docker-compose.yml << EOL
version: '3'

services:
  api:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
    environment:
      - DATABASE_URL=sqlite:///./app.db
EOL

    # Create README.md
    cat > README.md << EOL
# $project_name

A FastAPI project with a structured layout.

## Project Structure

\`\`\`
$project_name/
├── app/
│   ├── api/
│   │   ├── dependencies/
│   │   └── endpoints/
│   ├── core/
│   ├── db/
│   ├── models/
│   ├── schemas/
│   ├── services/
│   └── utils/
├── tests/
├── .gitignore
├── requirements.txt
├── requirements-dev.txt
├── Dockerfile
└── docker-compose.yml
\`\`\`

## Getting Started

### Local Development

1. Create a virtual environment:
   \`\`\`
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\\Scripts\\activate
   \`\`\`

2. Install dependencies:
   \`\`\`
   pip install -r requirements.txt
   pip install -r requirements-dev.txt  # For development
   \`\`\`

3. Run the application:
   \`\`\`
   uvicorn app.main:app --reload
   \`\`\`

4. Visit the API documentation at http://localhost:8000/docs

### Docker Development

1. Build and run with Docker Compose:
   \`\`\`
   docker-compose up --build
   \`\`\`

2. Visit the API documentation at http://localhost:8000/docs

## Running Tests

\`\`\`
pytest
\`\`\`

## License

[MIT](LICENSE)
EOL

    cd ..
    echo -e "
${GREEN}FastAPI project structure created successfully!${NC}"
    echo -e "${BLUE}Project location:${NC} $(pwd)/${project_name}"
    echo -e "${YELLOW}Happy coding!${NC}"
}


# Main script starts here
display_banner

# Display project type options
echo -e "Please select the type of project structure to create:"
echo -e "${BLUE}1)${NC} Flutter (Clean Architecture or MVVM)"
echo -e "${BLUE}2)${NC} Go"
echo -e "${BLUE}3)${NC} Node.js"
echo -e "${BLUE}4)${NC} FastAPI"
echo -e "${BLUE}q)${NC} Quit"

# Get user choice
read -p "Enter your choice (1/2/3/4/q): " project_choice
case $project_choice in
    q|Q)
        echo -e "${YELLOW}Exiting...${NC}"
        exit 0
        ;;
    1|2|3|4)
        # Valid choice, continue
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting...${NC}"
        exit 1
        ;;
esac

# For Flutter, get both project name and organization identifier
if [ "$project_choice" == "1" ]; then
    read -p "Enter Flutter project name: " project_name
    if [ -z "$project_name" ]; then
        echo -e "${RED}Project name cannot be empty. Exiting...${NC}"
        exit 1
    fi
    read -p "Enter organization identifier (e.g., com.example): " org_identifier
    if [ -z "$org_identifier" ]; then
        echo -e "${YELLOW}Using default organization: com.example${NC}"
        org_identifier="com.example"
    fi
else
    read -p "Enter project name: " project_name
    if [ -z "$project_name" ]; then
        echo -e "${RED}Project name cannot be empty. Exiting...${NC}"
        exit 1
    fi
fi

# Create the selected project structure
case $project_choice in
    1)
        create_flutter_structure "$project_name" "$org_identifier"
        ;;
    2)
        create_go_structure "$project_name"
        ;;
    3)
        create_nodejs_structure "$project_name"
        ;;
    4)
        create_fastapi_structure "$project_name"
        ;;
esac

# Display completion message
echo -e "
${GREEN}Project setup completed!${NC}"
echo -e "${BLUE}Project location:${NC} $(pwd)/${project_name}"
echo -e "${YELLOW}Happy coding!${NC}
"