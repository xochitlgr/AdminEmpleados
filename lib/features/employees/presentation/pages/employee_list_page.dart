import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/routes.dart';
import '../cubits/employee_list/employee_list_cubit.dart';
import '../cubits/employee_list/employee_list_state.dart';
import '../widgets/employee_card.dart';

/// Lista de empleados (US2, FR-001/FR-003). Ruta raíz `AppRoutes.root`.
class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EmployeeListCubit>(),
      child: const _ListBody(),
    );
  }
}

class _ListBody extends StatefulWidget {
  const _ListBody();

  @override
  State<_ListBody> createState() => _ListBodyState();
}

class _ListBodyState extends State<_ListBody> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeListCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empleados')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.form),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EmployeeListCubit, EmployeeListState>(
        builder: (context, state) {
          switch (state) {
            case EmployeeListLoading():
              return const Center(child: CircularProgressIndicator());
            case EmployeeListError(:final message):
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<EmployeeListCubit>().load(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            case EmployeeListLoaded(:final employees):
              if (employees.isEmpty) {
                return const Center(
                  child: Text('No hay empleados registrados'),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<EmployeeListCubit>().load(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: employees.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return EmployeeCard(
                      employee: employee,
                      onToggleChanged: (value) => context
                          .read<EmployeeListCubit>()
                          .toggle(employee, isActive: value),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}