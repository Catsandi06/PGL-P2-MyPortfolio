import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

/// Botón que obtiene y muestra el mensaje de bienvenida de la API
class WelcomeMessageButton extends StatefulWidget {
  const WelcomeMessageButton({super.key});

  @override
  State<WelcomeMessageButton> createState() => _WelcomeMessageButtonState();
}

class _WelcomeMessageButtonState extends State<WelcomeMessageButton> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _showWelcomeMessage() async {
    final token = await _authService.getToken();
    if (token == null) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.getWelcomeMessage(token);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result['success']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mensaje de bienvenida'),
          content: Text(result['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(result['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _showWelcomeMessage,
        icon: _isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.mail_outline),
        label: const Text('Mensaje de bienvenida'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFC9502B),
          side: const BorderSide(
            color: Color(0xFFC9502B),
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}
