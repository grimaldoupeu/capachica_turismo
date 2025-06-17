import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../blocs/reserva_bloc/reserva_bloc.dart';
import '../../models/reserva.dart';

class FormReservaScreen extends StatefulWidget {
  final Reserva? reserva;

  const FormReservaScreen({super.key, this.reserva});

  @override
  State<FormReservaScreen> createState() => _FormReservaScreenState();
}

class _FormReservaScreenState extends State<FormReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  final Uuid _uuid = const Uuid();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  late TextEditingController _hospedajeIdController;
  late TextEditingController _usuarioIdController; // Asumimos que se obtiene de algún lugar (ej. auth)
  late TextEditingController _nombreHospedajeController;
  late TextEditingController _numeroHuespedesController;
  late TextEditingController _precioTotalController;
  late TextEditingController _estadoController;
  late TextEditingController _contactoEmailController;
  late TextEditingController _contactoTelefonoController;
  late TextEditingController _notasEspecialesController;

  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  bool get _isEditing => widget.reserva != null;

  @override
  void initState() {
    super.initState();
    _hospedajeIdController = TextEditingController(text: widget.reserva?.hospedajeId ?? '');
    _usuarioIdController = TextEditingController(text: widget.reserva?.usuarioId ?? 'USER_ID_PLACEHOLDER'); // Placeholder
    _nombreHospedajeController = TextEditingController(text: widget.reserva?.nombreHospedaje ?? '');
    _numeroHuespedesController = TextEditingController(text: widget.reserva?.numeroHuespedes.toString() ?? '1');
    _precioTotalController = TextEditingController(text: widget.reserva?.precioTotal.toString() ?? '0.0');
    _estadoController = TextEditingController(text: widget.reserva?.estado ?? 'Pendiente');
    _contactoEmailController = TextEditingController(text: widget.reserva?.datosContacto['email'] ?? '');
    _contactoTelefonoController = TextEditingController(text: widget.reserva?.datosContacto['telefono'] ?? '');
    _notasEspecialesController = TextEditingController(text: widget.reserva?.notasEspeciales ?? '');

    _fechaInicio = widget.reserva?.fechaInicio;
    _fechaFin = widget.reserva?.fechaFin;
  }

  @override
  void dispose() {
    _hospedajeIdController.dispose();
    _usuarioIdController.dispose();
    _nombreHospedajeController.dispose();
    _numeroHuespedesController.dispose();
    _precioTotalController.dispose();
    _estadoController.dispose();
    _contactoEmailController.dispose();
    _contactoTelefonoController.dispose();
    _notasEspecialesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = (isStartDate ? _fechaInicio : _fechaFin) ?? DateTime.now();
    final DateTime firstDate = DateTime.now().subtract(const Duration(days: 30)); // Allow past 30 days for editing old ones
    final DateTime lastDate = DateTime.now().add(const Duration(days: 365 * 2)); // Allow 2 years in future

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
          if (_fechaFin != null && _fechaFin!.isBefore(_fechaInicio!)) {
            _fechaFin = _fechaInicio!.add(const Duration(days: 1)); // Ensure end date is after start date
          }
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_fechaInicio == null || _fechaFin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione fecha de inicio y fin.')),
        );
        return;
      }
      if (_fechaFin!.isBefore(_fechaInicio!)) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La fecha de fin no puede ser anterior a la fecha de inicio.')),
        );
        return;
      }

      final reservaModel = Reserva(
        id: widget.reserva?.id ?? _uuid.v4(),
        hospedajeId: _hospedajeIdController.text,
        usuarioId: _usuarioIdController.text,
        nombreHospedaje: _nombreHospedajeController.text,
        fechaInicio: _fechaInicio!,
        fechaFin: _fechaFin!,
        numeroHuespedes: int.tryParse(_numeroHuespedesController.text) ?? 1,
        precioTotal: double.tryParse(_precioTotalController.text) ?? 0.0,
        estado: _estadoController.text, // El estado podría ser manejado por el backend
        fechaReserva: widget.reserva?.fechaReserva ?? DateTime.now(),
        datosContacto: {
          'email': _contactoEmailController.text,
          'telefono': _contactoTelefonoController.text,
        },
        notasEspeciales: _notasEspecialesController.text.isEmpty ? null : _notasEspecialesController.text,
      );

      if (_isEditing) {
        context.read<ReservaBloc>().add(UpdateReserva(reservaModel));
      } else {
        context.read<ReservaBloc>().add(AddReserva(reservaModel));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Reserva' : 'Nueva Reserva'),
      ),
      body: BlocListener<ReservaBloc, ReservaState>(
        listener: (context, state) {
          if (state is ReservaOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Operación exitosa')),
            );
            Navigator.of(context).pop();
          } else if (state is ReservaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(controller: _hospedajeIdController, decoration: const InputDecoration(labelText: 'ID Hospedaje'), validator: (v) => v!.isEmpty ? 'Ingrese ID Hospedaje' : null),
                TextFormField(controller: _nombreHospedajeController, decoration: const InputDecoration(labelText: 'Nombre del Hospedaje'), validator: (v) => v!.isEmpty ? 'Ingrese nombre del hospedaje' : null),
                TextFormField(controller: _usuarioIdController, decoration: const InputDecoration(labelText: 'ID Usuario (placeholder)'), enabled: false), // Podría no ser editable por el usuario

                const SizedBox(height: 10),
                Text('Fecha de Inicio:', style: Theme.of(context).textTheme.titleSmall),
                TextButton(onPressed: () => _selectDate(context, true), child: Text(_fechaInicio == null ? 'Seleccionar Fecha' : _dateFormat.format(_fechaInicio!))),

                const SizedBox(height: 10),
                Text('Fecha de Fin:', style: Theme.of(context).textTheme.titleSmall),
                TextButton(onPressed: () => _selectDate(context, false), child: Text(_fechaFin == null ? 'Seleccionar Fecha' : _dateFormat.format(_fechaFin!))),

                TextFormField(controller: _numeroHuespedesController, decoration: const InputDecoration(labelText: 'Número de Huéspedes'), keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || int.tryParse(v) == null || int.parse(v) < 1) ? 'Ingrese un número válido de huéspedes' : null),
                TextFormField(controller: _precioTotalController, decoration: const InputDecoration(labelText: 'Precio Total'), keyboardType: const TextInputType.numberWithOptions(decimal: true), validator: (v) => (v!.isEmpty || double.tryParse(v) == null) ? 'Ingrese precio válido' : null),
                TextFormField(controller: _estadoController, decoration: const InputDecoration(labelText: 'Estado (Ej: Pendiente)'), validator: (v) => v!.isEmpty ? 'Ingrese estado' : null), // Podría ser un Dropdown

                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text('Datos de Contacto', style: Theme.of(context).textTheme.titleLarge),
                ),
                TextFormField(controller: _contactoEmailController, decoration: const InputDecoration(labelText: 'Email de Contacto'), keyboardType: TextInputType.emailAddress),
                TextFormField(controller: _contactoTelefonoController, decoration: const InputDecoration(labelText: 'Teléfono de Contacto'), keyboardType: TextInputType.phone),

                TextFormField(controller: _notasEspecialesController, decoration: const InputDecoration(labelText: 'Notas Especiales (Opcional)'), maxLines: 3),

                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submitForm, child: Text(_isEditing ? 'Actualizar Reserva' : 'Crear Reserva')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
