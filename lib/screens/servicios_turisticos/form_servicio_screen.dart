import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart'; // Para generar IDs únicos para nuevos servicios
import '../../blocs/servicio_turistico_bloc/servicio_turistico_bloc.dart';
import '../../models/servicio_turistico.dart';

class FormServicioScreen extends StatefulWidget {
  final ServicioTuristico? servicio; // Servicio existente para editar, null para crear

  const FormServicioScreen({super.key, this.servicio});

  @override
  State<FormServicioScreen> createState() => _FormServicioScreenState();
}

class _FormServicioScreenState extends State<FormServicioScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _ubicacionController;
  late TextEditingController _precioController;
  late TextEditingController _imagenUrlController;
  late TextEditingController _horarioController;
  // Para diasDisponibles, podríamos usar un MultiSelectChipField o similar,
  // por simplicidad usaremos un TextField que espera strings separados por comas.
  late TextEditingController _diasDisponiblesController;
  late bool _disponible;

  bool get _isEditing => widget.servicio != null;
  final Uuid _uuid = const Uuid(); // Para generar IDs

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.servicio?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.servicio?.descripcion ?? '');
    _ubicacionController = TextEditingController(text: widget.servicio?.ubicacion ?? '');
    _precioController = TextEditingController(text: widget.servicio?.precio.toString() ?? '');
    _imagenUrlController = TextEditingController(text: widget.servicio?.imagenUrl ?? '');
    _horarioController = TextEditingController(text: widget.servicio?.horario ?? '');
    _diasDisponiblesController = TextEditingController(text: widget.servicio?.diasDisponibles.join(',') ?? '');
    _disponible = widget.servicio?.disponible ?? true; // Default a true para nuevos
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _ubicacionController.dispose();
    _precioController.dispose();
    _imagenUrlController.dispose();
    _horarioController.dispose();
    _diasDisponiblesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final descripcion = _descripcionController.text;
      final ubicacion = _ubicacionController.text;
      final precio = double.tryParse(_precioController.text) ?? 0.0;
      final imagenUrl = _imagenUrlController.text;
      final horario = _horarioController.text;
      final diasDisponibles = _diasDisponiblesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final servicioModel = ServicioTuristico(
        id: widget.servicio?.id ?? _uuid.v4(), // Usar ID existente o generar uno nuevo
        nombre: nombre,
        descripcion: descripcion,
        ubicacion: ubicacion,
        precio: precio,
        imagenUrl: imagenUrl,
        horario: horario,
        diasDisponibles: diasDisponibles,
        disponible: _disponible,
      );

      if (_isEditing) {
        context.read<ServicioTuristicoBloc>().add(UpdateServicioTuristico(servicioModel));
      } else {
        context.read<ServicioTuristicoBloc>().add(AddServicioTuristico(servicioModel));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Servicio' : 'Nuevo Servicio'),
      ),
      body: BlocListener<ServicioTuristicoBloc, ServicioTuristicoState>(
        listener: (context, state) {
          if (state is ServicioTuristicoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Operación exitosa')),
            );
            Navigator.of(context).pop(); // Regresar a la pantalla anterior
          } else if (state is ServicioTuristicoError) {
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
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingrese un nombre' : null,
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingrese una descripción' : null,
                ),
                TextFormField(
                  controller: _ubicacionController,
                  decoration: const InputDecoration(labelText: 'Ubicación'),
                   validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingrese una ubicación' : null,
                ),
                TextFormField(
                  controller: _precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor ingrese un precio';
                    if (double.tryParse(value) == null) return 'Ingrese un número válido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imagenUrlController,
                  decoration: const InputDecoration(labelText: 'URL de Imagen'),
                  keyboardType: TextInputType.url,
                ),
                TextFormField(
                  controller: _horarioController,
                  decoration: const InputDecoration(labelText: 'Horario (ej: 9am - 5pm)'),
                ),
                TextFormField(
                  controller: _diasDisponiblesController,
                  decoration: const InputDecoration(labelText: 'Días Disponibles (separados por coma)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingrese al menos un día';
                    return null;
                  }
                ),
                SwitchListTile(
                  title: const Text('Disponible'),
                  value: _disponible,
                  onChanged: (bool value) {
                    setState(() {
                      _disponible = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
