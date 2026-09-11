import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/employee.dart';
import '../cubits/employee_form/employee_form_cubit.dart';
import '../cubits/employee_form/employee_form_state.dart';

/// Formulario de registro de empleado (US1, FR-005/FR-006, Constitución V/VI).
class EmployeeFormPage extends StatelessWidget {
  const EmployeeFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EmployeeFormCubit>(),
      child: const _FormBody(),
    );
  }
}

class _FormBody extends StatefulWidget {
  const _FormBody();

  @override
  State<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<_FormBody> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _puestoController = TextEditingController();
  final _fechaEntradaController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();

  Area? _area;
  Genero? _genero;
  DateTime? _fechaEntrada;
  DateTime? _fechaNacimiento;

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    _nombreController.dispose();
    _puestoController.dispose();
    _fechaEntradaController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime? current,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final ahora = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? ahora,
      firstDate: DateTime(1900),
      lastDate: ahora,
    );
    if (picked == null) return;
    onPicked(picked);
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    final employee = Employee(
      id: 0,
      nombreCompleto: _nombreController.text.trim(),
      area: _area!,
      puesto: _puestoController.text.trim(),
      genero: _genero!,
      fechaEntrada: _fechaEntrada!,
      fechaNacimiento: _fechaNacimiento,
    );
    await context.read<EmployeeFormCubit>().submit(employee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar empleado')),
      body: BlocListener<EmployeeFormCubit, EmployeeFormState>(
        listener: (context, state) {
          switch (state) {
            case EmployeeFormSuccess():
              Navigator.of(context).pushNamed('/success');
            case EmployeeFormError(:final message):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            default:
              break;
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre completo'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el nombre completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Area>(
                  initialValue: _area,
                  decoration: const InputDecoration(labelText: 'Área'),
                  items: [
                    for (final area in Area.values)
                      DropdownMenuItem(value: area, child: Text(area.label)),
                  ],
                  onChanged: (value) => setState(() => _area = value),
                  validator: (value) {
                    if (value == null) return 'Selecciona un área';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fechaEntradaController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de entrada',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(
                    current: _fechaEntrada,
                    onPicked: (date) => setState(() {
                      _fechaEntrada = date;
                      _fechaEntradaController.text = _dateFormat.format(date);
                    }),
                  ),
                  validator: (_) {
                    if (_fechaEntrada == null) {
                      return 'Selecciona la fecha de entrada';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _puestoController,
                  decoration: const InputDecoration(labelText: 'Puesto'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el puesto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Genero>(
                  initialValue: _genero,
                  decoration: const InputDecoration(labelText: 'Género'),
                  items: [
                    for (final genero in Genero.values)
                      DropdownMenuItem(value: genero, child: Text(genero.label)),
                  ],
                  onChanged: (value) => setState(() => _genero = value),
                  validator: (value) {
                    if (value == null) return 'Selecciona un género';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fechaNacimientoController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento (opcional)',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(
                    current: _fechaNacimiento,
                    onPicked: (date) => setState(() {
                      _fechaNacimiento = date;
                      _fechaNacimientoController.text = _dateFormat.format(date);
                    }),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _registrar,
                    child: const Text('Registrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}