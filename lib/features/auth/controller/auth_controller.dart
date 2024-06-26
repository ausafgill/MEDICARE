import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController {
  AuthController({required this.authRepository});
  final AuthRepository authRepository;

  Future creatingUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await authRepository.creatingUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future signingInUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await authRepository.signingInUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future resetPassword({required String email}) async {
    await authRepository.resetPassword(email: email);
  }

  Future signOutUser() async {
    await authRepository.signingOut();
  }
}
