import 'package:flutter/material.dart';

/// Pantalla de registro exitoso (US1, FR-008).
class EmployeeSuccessPage extends StatelessWidget {
  const EmployeeSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 72, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                'Empleado registrado correctamente',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Regresar a empleados'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}