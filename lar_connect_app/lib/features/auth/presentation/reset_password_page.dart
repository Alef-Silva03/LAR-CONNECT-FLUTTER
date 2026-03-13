import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_repository.dart';
import 'auth_ui.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.repository,
    this.token,
  });

  final AuthRepository repository;
  final String? token;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _novaSenha = TextEditingController();
  final _confirmarSenha = TextEditingController();
  bool _loading = false;
  bool _validandoToken = true;
  bool _tokenValido = false;

  String get _token => (widget.token ?? '').trim();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _validarTokenInicial());
  }

  Future<void> _validarTokenInicial() async {
    if (!mounted) return;

    if (_token.isEmpty) {
      setState(() {
        _validandoToken = false;
        _tokenValido = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token inválido. Refaça a solicitação de redefinição.')),
      );
      context.go('/esqueci-senha');
      return;
    }

    try {
      final valido = await widget.repository.validarToken(_token);
      if (!mounted) return;
      setState(() {
        _tokenValido = valido;
        _validandoToken = false;
      });

      if (!valido) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token inválido ou expirado.')),
        );
        context.go('/esqueci-senha');
      }
    } on DioException {
      if (!mounted) return;
      setState(() {
        _tokenValido = false;
        _validandoToken = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao validar token. Solicite novamente.')),
      );
      context.go('/esqueci-senha');
    }
  }

  @override
  void dispose() {
    _novaSenha.dispose();
    _confirmarSenha.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_tokenValido || _token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token inválido. Refaça a solicitação de redefinição.')),
      );
      context.go('/esqueci-senha');
      return;
    }

    if (_novaSenha.text != _confirmarSenha.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await widget.repository.redefinirSenha(
        token: _token,
        novaSenha: _novaSenha.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
      context.go('/login');
    } on DioException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao redefinir senha')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_validandoToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AuthScaffold(
      title: 'NOVA SENHA',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _novaSenha,
            obscureText: true,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Nova senha', icon: Icons.lock),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmarSenha,
            obscureText: true,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Confirmar senha', icon: Icons.lock_outline),
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