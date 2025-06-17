import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/hospedaje_bloc/hospedaje_bloc.dart';
import '../../models/hospedaje.dart';
import '../../services/hospedaje_service.dart'; // Necesario para proveer el servicio al BLoC
import 'form_hospedaje_screen.dart'; // Se creará después

class ListHospedajesScreen extends StatelessWidget {
  const ListHospedajesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTA: El HospedajeService y HospedajeBloc idealmente se proveen
    // más arriba en el árbol de widgets (ej. main.dart o un widget raíz del feature).
    // Aquí se instancia el servicio para simplicidad del ejemplo.
    final hospedajeService = HospedajeService();

    return BlocProvider(
      create: (context) => HospedajeBloc(hospedajeService)
        ..add(LoadHospedajes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hospedajes'),
        ),
        body: BlocBuilder<HospedajeBloc, HospedajeState>(
          builder: (context, state) {
            if (state is HospedajeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HospedajesLoaded) {
              if (state.hospedajes.isEmpty) {
                return const Center(child: Text('No hay hospedajes disponibles.'));
              }
              return ListView.builder(
                itemCount: state.hospedajes.length,
                itemBuilder: (context, index) {
                  final hospedaje = state.hospedajes[index];
                  return ListTile(
                    leading: (hospedaje.imagenes.isNotEmpty && hospedaje.imagenes.first.isNotEmpty)
                        ? Image.network(
                            hospedaje.imagenes.first, // Mostrar la primera imagen
                            width: 60, height: 60, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.hotel, size: 40))
                        : const Icon(Icons.hotel, size: 40), // Icono por defecto
                    title: Text(hospedaje.nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hospedaje.tipoAlojamiento, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(hospedaje.ubicacion, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('Precio: S/.${hospedaje.precio.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryColor)),
                        Text('Calificación: ${hospedaje.calificacion} (${hospedaje.numeroReviews} reviews)', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    isThreeLine: true, // Ajustar si el subtítulo es muy largo
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value( // Pasar el BLoC existente
                                  value: BlocProvider.of<HospedajeBloc>(context),
                                  child: FormHospedajeScreen(hospedaje: hospedaje),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, hospedaje, context.read<HospedajeBloc>());
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Podrías navegar a una pantalla de detalle aquí
                      print('Tap en hospedaje ${hospedaje.id}');
                    },
                  );
                },
              );
            } else if (state is HospedajeError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Iniciando...'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                 builder: (_) => BlocProvider.value( // Pasar el BLoC existente
                    value: BlocProvider.of<HospedajeBloc>(context),
                    child: const FormHospedajeScreen(),
                  ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Hospedaje hospedaje, HospedajeBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar "${hospedaje.nombre}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                bloc.add(DeleteHospedaje(hospedaje.id));
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
