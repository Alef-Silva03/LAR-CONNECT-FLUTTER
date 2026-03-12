import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';
import 'auth_ui.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.repository});

  final AuthRepository repository;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _solicitar() async {
    setState(() => _loading = true);
    try {
      final token = await widget.repository.solicitarRedefinicao(_email.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token recebido: $token')),
      );
      context.go('/nova-senha');
    } on DioException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao solicitar redefinição')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'REDEFINIR SENHA',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _email,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Email', icon: Icons.alternate_email),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: authPrimaryButtonStyle(),
            onPressed: _loading ? null : _solicitar,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('ENVIAR'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: authSecondaryButtonStyle(),
            onPressed: () => context.go('/login'),
            child: const Text('VOLTAR AO LOGIN'),
          ),
        ],
      ),
    );
  }
}