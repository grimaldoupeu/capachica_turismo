import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/servicio_turistico_bloc/servicio_turistico_bloc.dart';
import '../../models/servicio_turistico.dart';
import '../../services/servicio_turistico_service.dart'; // Necesario para proveer el servicio al BLoC
import 'form_servicio_screen.dart';

class ListServiciosScreen extends StatelessWidget {
  const ListServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Importante: Debes proveer el ServicioTuristicoService a tu BLoC.
    // Esto usualmente se hace más arriba en el árbol de widgets, en tu main.dart o en un punto de entrada del feature.
    // Por ahora, lo instanciamos aquí para que el ejemplo sea autocontenido,
    // pero considera usar un sistema de inyección de dependencias como get_it o provider.
    final servicioTuristicoService = ServicioTuristicoService();

    return BlocProvider(
      create: (context) => ServicioTuristicoBloc(servicioTuristicoService)
        ..add(LoadServiciosTuristicos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Servicios Turísticos'),
              // actions: [
              //   IconButton(
              //     icon: const Icon(Icons.add),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (context) => FormServicioScreen(), // Navegar al formulario de creación
              //         ),
              //       );
              //       // print('Botón Añadir presionado - Implementar navegación');
              //     },
              //   ),
              // ],
        ),
        body: BlocBuilder<ServicioTuristicoBloc, ServicioTuristicoState>(
          builder: (context, state) {
            if (state is ServicioTuristicoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ServiciosTuristicosLoaded) {
              if (state.servicios.isEmpty) {
                return const Center(child: Text('No hay servicios turísticos disponibles.'));
              }
              return ListView.builder(
                itemCount: state.servicios.length,
                itemBuilder: (context, index) {
                  final servicio = state.servicios[index];
                  return ListTile(
                    leading: servicio.imagenUrl.isNotEmpty
                        ? Image.network(servicio.imagenUrl, width: 50, height: 50, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50))
                        : const Icon(Icons.business, size: 50), // Icono por defecto
                    title: Text(servicio.nombre),
                    subtitle: Text(servicio.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FormServicioScreen(servicio: servicio), // Navegar al formulario de edición
                                  ),
                                ).then((_) {
                                  // Opcional: Recargar como en el FAB.
                                });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, servicio, context.read<ServicioTuristicoBloc>());
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Podrías navegar a una pantalla de detalle aquí
                      print('Tap en servicio ${servicio.id}');
                    },
                  );
                },
              );
            } else if (state is ServicioTuristicoError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Iniciando...')); // Estado inicial o no manejado
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FormServicioScreen(), // Navegar al formulario de creación
                  ),
                ).then((_) {
                  // Opcional: Recargar la lista si se agregó algo y se regresó.
                  // El BLoC ya debería estar manejando esto si FormServicioScreen
                  // dispara un evento que lleva a LoadServiciosTuristicos.
                  // Pero si quieres forzar una recarga aquí:
                  // context.read<ServicioTuristicoBloc>().add(LoadServiciosTuristicos());
                });
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ServicioTuristico servicio, ServicioTuristicoBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar "${servicio.nombre}"?'),
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
                bloc.add(DeleteServicioTuristico(servicio.id));
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
