import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';
import 'auth_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.repository});

  final AuthRepository repository;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    setState(() => _loading = true);
    try {
      final user = await widget.repository.login(
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bem-vindo, ${user['nome'] ?? 'usuário'}!')),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = e.response?.statusCode == 401
          ? 'Email ou senha inválidos'
          : 'Erro ao fazer login';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'ACESSE O SISTEMA',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'E-mail', icon: Icons.person),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _senhaController,
            obscureText: true,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Senha', icon: Icons.lock),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: authPrimaryButtonStyle(),
            onPressed: _loading ? null : _entrar,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('ENTRAR'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: authPrimaryButtonStyle(),
            onPressed: () => context.go('/esqueci-senha'),
            child: const Text('ESQUECI MINHA SENHA'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: authSecondaryButtonStyle(),
            onPressed: () => context.go('/cadastro'),
            child: const Text('NÃO TEM CONTA? CADASTRE-SE!'),
          ),
        ],
      ),
    );
  }
}
