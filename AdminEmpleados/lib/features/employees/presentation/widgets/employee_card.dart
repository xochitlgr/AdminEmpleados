import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/employee.dart';

/// Tarjeta de empleado con Switch de activo/inactivo (US2, FR-001/FR-002/FR-003).
class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onToggleChanged,
  });

  final Employee employee;
  final ValueChanged<bool> onToggleChanged;

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactive = !employee.isActive;
    final baseColor =
        inactive ? Colors.grey.shade400 : theme.colorScheme.secondaryContainer;

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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.nombreCompleto,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(inactive ? 'Inactivo' : 'Activo'),
                          labelStyle: theme.textTheme.labelSmall,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: baseColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${employee.puesto} · ${employee.area.label}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${employee.genero.label} · ${_dateFormat.format(employee.fechaEntrada)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: employee.isActive,
                onChanged: onToggleChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}