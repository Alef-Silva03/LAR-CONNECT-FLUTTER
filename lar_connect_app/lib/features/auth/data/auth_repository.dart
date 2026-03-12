import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: {'email': email, 'senha': senha},
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String cpf,
    required String telefone,
    required String perfil,
  }) async {
    await _dio.post(
      '/usuarios/salvar',
      data: {
        'nome': nome,
        'email': email,
        'senha': senha,
        'cpf': cpf,
        'telefone': telefone,
        'perfil': perfil,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  Future<String> solicitarRedefinicao(String email) async {
    final response = await _dio.post('/api/redefinir-senha', data: {'email': email});
    return (response.data['token'] ?? '') as String;
  }

  Future<void> redefinirSenha({
    required String token,
    required String novaSenha,
    required String confirmarSenha,
  }) async {
    await _dio.post(
      '/api/nova-senha',
      data: {
        'token': token,
        'novaSenha': novaSenha,
        'confirmarSenha': confirmarSenha,
      },
    );
  }

  Future<bool> validarToken(String token) async {
    final response = await _dio.get('/api/validar-token/$token');
    return response.data['valido'] == true;
  }
}