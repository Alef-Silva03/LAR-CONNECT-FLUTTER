import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_repository.dart';
import 'auth_ui.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.repository});

  final AuthRepository repository;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _cpf = TextEditingController();
  final _telefone = TextEditingController();
  String _perfil = 'PROPRIETARIO';
  bool _loading = false;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _cpf.dispose();
    _telefone.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    setState(() => _loading = true);
    try {
      await widget.repository.cadastrar(
        nome: _nome.text,
        email: _email.text,
        senha: _senha.text,
        cpf: _cpf.text,
        telefone: _telefone.text,
        perfil: _perfil,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      context.go('/login');
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = e.response?.statusCode == 409
          ? 'Email já cadastrado'
          : 'Erro ao cadastrar';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'CADASTRO',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            dropdownColor: AuthColors.field,
            value: _perfil,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(
              hint: 'Selecione seu perfil',
              icon: Icons.badge,
            ),
            items: const [
              DropdownMenuItem(value: 'PROPRIETARIO', child: Text('Proprietário')),
              DropdownMenuItem(value: 'INQUILINO', child: Text('Inquilino')),
              DropdownMenuItem(value: 'SINDICO', child: Text('Síndico')),
              DropdownMenuItem(value: 'FUNCIONARIO', child: Text('Funcionário')),
            ],
            onChanged: (v) => setState(() => _perfil = v ?? 'PROPRIETARIO'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nome,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Nome', icon: Icons.person),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Email', icon: Icons.alternate_email),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _senha,
            obscureText: true,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Senha', icon: Icons.lock),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cpf,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'CPF', icon: Icons.badge_outlined),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _telefone,
            style: const TextStyle(color: AuthColors.text),
            decoration: authInputDecoration(hint: 'Telefone', icon: Icons.phone),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: authPrimaryButtonStyle(),
            onPressed: _loading ? null : _cadastrar,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('CADASTRE-SE'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: authSecondaryButtonStyle(),
            onPressed: () => context.go('/login'),
            child: const Text('JÁ TENHO CONTA (LOGIN)'),
          )
        ],
      ),
    );
  }
}