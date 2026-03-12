import 'package:go_router/go_router.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/forgot_password_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/reset_password_page.dart';
import '../features/auth/presentation/signup_page.dart';

GoRouter buildRouter(AuthRepository repository) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(repository: repository),
      ),
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => SignupPage(repository: repository),
      ),
      GoRoute(
        path: '/esqueci-senha',
        builder: (context, state) => ForgotPasswordPage(repository: repository),
      ),
      GoRoute(
        path: '/nova-senha',
        builder: (context, state) => ResetPasswordPage(repository: repository),
      ),
    ],
  );
}