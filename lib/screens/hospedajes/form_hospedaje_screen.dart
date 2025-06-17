import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../blocs/hospedaje_bloc/hospedaje_bloc.dart';
import '../../models/hospedaje.dart';

class FormHospedajeScreen extends StatefulWidget {
  final Hospedaje? hospedaje;

  const FormHospedajeScreen({super.key, this.hospedaje});

  @override
  State<FormHospedajeScreen> createState() => _FormHospedajeScreenState();
}

class _FormHospedajeScreenState extends State<FormHospedajeScreen> {
  final _formKey = GlobalKey<FormState>();
  final Uuid _uuid = const Uuid();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _ubicacionController;
  late TextEditingController _precioController;
  late TextEditingController _imagenesController; // Comma-separated URLs
  late TextEditingController _serviciosController; // Comma-separated services
  late TextEditingController _capacidadMaximaController;
  late TextEditingController _calificacionController;
  late TextEditingController _numeroReviewsController;
  late TextEditingController _tipoAlojamientoController;
  late TextEditingController _coordLatController;
  late TextEditingController _coordLngController;
  late bool _disponible;

  bool get _isEditing => widget.hospedaje != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.hospedaje?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.hospedaje?.descripcion ?? '');
    _ubicacionController = TextEditingController(text: widget.hospedaje?.ubicacion ?? '');
    _precioController = TextEditingController(text: widget.hospedaje?.precio.toString() ?? '');
    _imagenesController = TextEditingController(text: widget.hospedaje?.imagenes.join(',') ?? '');
    _serviciosController = TextEditingController(text: widget.hospedaje?.servicios.join(',') ?? '');
    _capacidadMaximaController = TextEditingController(text: widget.hospedaje?.capacidadMaxima.toString() ?? '');
    _calificacionController = TextEditingController(text: widget.hospedaje?.calificacion.toString() ?? '0.0');
    _numeroReviewsController = TextEditingController(text: widget.hospedaje?.numeroReviews.toString() ?? '0');
    _tipoAlojamientoController = TextEditingController(text: widget.hospedaje?.tipoAlojamiento ?? '');
    _coordLatController = TextEditingController(text: widget.hospedaje?.coordenadas['lat']?.toString() ?? '');
    _coordLngController = TextEditingController(text: widget.hospedaje?.coordenadas['lng']?.toString() ?? '');
    _disponible = widget.hospedaje?.disponible ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _ubicacionController.dispose();
    _precioController.dispose();
    _imagenesController.dispose();
    _serviciosController.dispose();
    _capacidadMaximaController.dispose();
    _calificacionController.dispose();
    _numeroReviewsController.dispose();
    _tipoAlojamientoController.dispose();
    _coordLatController.dispose();
    _coordLngController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final imagenesList = _imagenesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final serviciosList = _serviciosController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final hospedajeModel = Hospedaje(
        id: widget.hospedaje?.id ?? _uuid.v4(),
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        ubicacion: _ubicacionController.text,
        precio: double.tryParse(_precioController.text) ?? 0.0,
        imagenes: imagenesList,
        servicios: serviciosList,
        capacidadMaxima: int.tryParse(_capacidadMaximaController.text) ?? 0,
        calificacion: double.tryParse(_calificacionController.text) ?? 0.0,
        numeroReviews: int.tryParse(_numeroReviewsController.text) ?? 0,
        tipoAlojamiento: _tipoAlojamientoController.text,
        coordenadas: {
          'lat': double.tryParse(_coordLatController.text),
          'lng': double.tryParse(_coordLngController.text),
        },
        disponible: _disponible,
      );

      if (_isEditing) {
        context.read<HospedajeBloc>().add(UpdateHospedaje(hospedajeModel));
      } else {
        context.read<HospedajeBloc>().add(AddHospedaje(hospedajeModel));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Hospedaje' : 'Nuevo Hospedaje'),
      ),
      body: BlocListener<HospedajeBloc, HospedajeState>(
        listener: (context, state) {
          if (state is HospedajeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Operación exitosa')),
            );
            Navigator.of(context).pop();
          } else if (state is HospedajeError) {
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
                TextFormField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre'), validator: (v) => v!.isEmpty ? 'Ingrese nombre' : null),
                TextFormField(controller: _descripcionController, decoration: const InputDecoration(labelText: 'Descripción'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Ingrese descripción' : null),
                TextFormField(controller: _ubicacionController, decoration: const InputDecoration(labelText: 'Ubicación (Dirección)'), validator: (v) => v!.isEmpty ? 'Ingrese ubicación' : null),
                TextFormField(controller: _precioController, decoration: const InputDecoration(labelText: 'Precio por noche'), keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || double.tryParse(v) == null) ? 'Ingrese precio válido' : null),
                TextFormField(controller: _imagenesController, decoration: const InputDecoration(labelText: 'URLs de Imágenes (separadas por coma)')),
                TextFormField(controller: _serviciosController, decoration: const InputDecoration(labelText: 'Servicios (separados por coma)')),
                TextFormField(controller: _capacidadMaximaController, decoration: const InputDecoration(labelText: 'Capacidad Máxima'), keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || int.tryParse(v) == null) ? 'Ingrese capacidad válida' : null),
                TextFormField(controller: _calificacionController, decoration: const InputDecoration(labelText: 'Calificación (ej: 4.5)'), keyboardType: const TextInputType.numberWithOptions(decimal: true), validator: (v) => (v!.isEmpty || double.tryParse(v) == null) ? 'Ingrese calificación válida' : null),
                TextFormField(controller: _numeroReviewsController, decoration: const InputDecoration(labelText: 'Número de Reviews'), keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || int.tryParse(v) == null) ? 'Ingrese número válido' : null),
                TextFormField(controller: _tipoAlojamientoController, decoration: const InputDecoration(labelText: 'Tipo de Alojamiento (Hotel, Hostal, etc.)'), validator: (v) => v!.isEmpty ? 'Ingrese tipo' : null),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _coordLatController, decoration: const InputDecoration(labelText: 'Latitud'), keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true))),
                    const SizedBox(width: 8),
                    Expanded(child: TextFormField(controller: _coordLngController, decoration: const InputDecoration(labelText: 'Longitud'), keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true))),
                  ],
                ),
                SwitchListTile(title: const Text('Disponible'), value: _disponible, onChanged: (bool value) => setState(() => _disponible = value)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submitForm, child: Text(_isEditing ? 'Actualizar' : 'Guardar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
