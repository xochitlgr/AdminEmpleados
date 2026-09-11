import 'package:equatable/equatable.dart';

/// Área a la que pertenece un empleado (lista cerrada, FR-005).
enum Area {
  tecnologia('Tecnología'),
  recursosHumanos('Recursos Humanos'),
  finanzas('Finanzas'),
  operaciones('Operaciones'),
  ventas('Ventas'),
  administracion('Administración');

  const Area(this.label);

  /// Etiqueta visible en la interfaz (español).
  final String label;
}

/// Género del empleado (FR-005).
enum Genero {
  masculino('Masculino'),
  femenino('Femenino'),
  otro('Otro');

  const Genero(this.label);

  /// Etiqueta visible en la interfaz (español).
  final String label;
}

/// Entidad de dominio: empleado de la organización.
///
/// Dart puro (sin imports de Flutter). El `id` lo asigna el origen de datos;
/// para nuevos registros se usa el valor centinela `0`.
class Employee extends Equatable {
  const Employee({
    required this.id,
    required this.nombreCompleto,
    required this.area,
    required this.puesto,
    required this.genero,
    required this.fechaEntrada,
    this.fechaNacimiento,
    this.isActive = true,
  });

  final int id;
  final String nombreCompleto;
  final Area area;
  final String puesto;
  final Genero genero;
  final DateTime fechaEntrada;
  final DateTime? fechaNacimiento;
  final bool isActive;

  @override
  List<Object?> get props => [
        id,
        nombreCompleto,
        area,
        puesto,
        genero,
        fechaEntrada,
        fechaNacimiento,
        isActive,
      ];
}