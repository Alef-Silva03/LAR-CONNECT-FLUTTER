import 'package:flutter/material.dart';

class AuthColors {
  static const bgStart = Color(0xFF1B263B);
  static const bgEnd = Color(0xFF0D1B2A);
  static const card = Color(0xFF0D1B2A);
  static const field = Color(0xFF1B263B);
  static const text = Color(0xFFE0E1DD);
  static const accent = Color(0xFF778DA9);
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [AuthColors.bgStart, AuthColors.bgEnd],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AuthColors.card,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 40,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/imagem/LogoSemNome.png',
                            width: 84,
                            height: 108,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.apartment_rounded,
                              color: AuthColors.text,
                              size: 60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AuthColors.text,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration authInputDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white70),
    prefixIcon: Icon(icon, color: AuthColors.text),
    filled: true,
    fillColor: AuthColors.field,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: AuthColors.accent),
    ),
  );
}

ButtonStyle authPrimaryButtonStyle() {
  return ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(52),
    backgroundColor: AuthColors.accent.withOpacity(0.22),
    foregroundColor: AuthColors.text,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
  );
}

ButtonStyle authSecondaryButtonStyle() {
  return OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(52),
    foregroundColor: AuthColors.text,
    side: const BorderSide(color: Colors.white24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
  );
}
