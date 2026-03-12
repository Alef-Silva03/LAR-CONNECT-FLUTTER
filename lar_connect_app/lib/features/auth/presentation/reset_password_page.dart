import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';
import 'auth_ui.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.repository});

  final AuthRepository repository;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _token = TextEditingController();
  final _novaSenha = TextEditingController();
  final _confirmarSenha = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _token.dispose();
    _novaSenha.dispose();
    _confirmarSenha.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    setState(() => _loading = true);
    try {
      await widget.repository.redefinirSenha(
        token: _token.text.trim(),
        novaSenha: _novaSenha.text,
        confirmarSenha: _confirmarSenha.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
      context.go('/login');
    } on DioException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao redefinir senha')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'NOVA SENHA',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _token,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Token', icon: Icons.vpn_key),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _novaSenha,
            obscureText: true,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(
              hint: 'Nova senha',
              icon: Icons.lock,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmarSenha,
            obscureText: true,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(
              hint: 'Confirmar senha',
              icon: Icons.lock_outline,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: authPrimaryButtonStyle(),
            onPressed: _loading ? null : _salvar,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('SALVAR'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: authSecondaryButtonStyle(),
            onPressed: () => context.go('/login'),
            child: const Text('LOGIN'),
          ),
        ],
      ),
    );
  }
}
