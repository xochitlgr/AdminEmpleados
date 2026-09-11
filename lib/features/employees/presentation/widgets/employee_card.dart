import 'package:flutter/material.dart';

import '../../domain/entities/employee.dart';

/// Tarjeta de empleado con Switch de activo/inactivo (US2, FR-002/FR-003).
class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onToggleChanged,
  });

  final Employee employee;
  final ValueChanged<bool> onToggleChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactive = !employee.isActive;

    return Opacity(
      opacity: inactive ? 0.6 : 1,
      child: Card(
        color: inactive ? Colors.grey.shade300 : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.nombreCompleto,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${employee.puesto} · ${employee.area.label}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Switch(
                value: employee.isActive,
                onChanged: onToggleChanged,
              ),
              Text(
                inactive ? 'Inactivo' : 'Activo',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}