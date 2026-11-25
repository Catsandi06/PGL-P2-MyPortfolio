import 'dart:async';

import 'package:flutter/material.dart';

/// Diálogo de confirmación para borrar todas las playas.
/// Incluye un temporizador de seguridad que deshabilita el botón de confirmación
/// durante 10 segundos para evitar borrados accidentales.
class DeleteAllDialog extends StatefulWidget {
  const DeleteAllDialog({super.key});

  @override
  State<DeleteAllDialog> createState() => _DeleteAllDialogState();
}

class _DeleteAllDialogState extends State<DeleteAllDialog> {
  static const _waitDuration = 10;
  static const _orange = Color(0xFFC9502B);
  Timer? _timer;
  int _secondsRemaining = _waitDuration;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining <= 1) {
        _timer?.cancel();
        if (mounted) {
          setState(() => _secondsRemaining = 0);
        }
      } else if (mounted) {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _secondsRemaining == 0;

    return AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded, color: _orange, size: 42),
      title: const Text('¿Borrar todas las playas?'),
      content: Text(
        'Esta acción eliminará todas las playas guardadas y no se puede deshacer.\n\n'
        'Por seguridad, el botón se activará en $_secondsRemaining segundos.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: canDelete ? () => Navigator.of(context).pop(true) : null,
          icon: const Icon(Icons.delete_forever),
          label: Text(
            canDelete ? 'Borrar todo' : 'Esperar ($_secondsRemaining)',
          ),
          style: FilledButton.styleFrom(backgroundColor: _orange),
        ),
      ],
    );
  }
}
