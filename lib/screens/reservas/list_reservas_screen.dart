import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../../blocs/reserva_bloc/reserva_bloc.dart';
import '../../models/reserva.dart';
import '../../services/reserva_service.dart';
import 'form_reserva_screen.dart';

class ListReservasScreen extends StatelessWidget {
  const ListReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservaService = ReservaService(); // Idealmente inyectado

    return BlocProvider(
      create: (context) => ReservaBloc(reservaService)
        ..add(LoadReservas()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Reservas'),
        ),
        body: BlocBuilder<ReservaBloc, ReservaState>(
          builder: (context, state) {
            if (state is ReservaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReservasLoaded) {
              if (state.reservas.isEmpty) {
                return const Center(child: Text('No tienes reservas aún.'));
              }
              return ListView.builder(
                itemCount: state.reservas.length,
                itemBuilder: (context, index) {
                  final reserva = state.reservas[index];
                  final dateFormat = DateFormat('dd/MM/yyyy');
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text('Reserva para: ${reserva.nombreHospedaje}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cliente ID: ${reserva.usuarioId}'),
                          Text('Fechas: ${dateFormat.format(reserva.fechaInicio)} - ${dateFormat.format(reserva.fechaFin)}'),
                          Text('Huéspedes: ${reserva.numeroHuespedes}'),
                          Text('Precio Total: S/.${reserva.precioTotal.toStringAsFixed(2)}'),
                          Text('Estado: ${reserva.estado}', style: TextStyle(fontWeight: FontWeight.bold, color: _getEstadoColor(reserva.estado))),
                          if (reserva.notasEspeciales != null && reserva.notasEspeciales!.isNotEmpty)
                            Text('Notas: ${reserva.notasEspeciales}', style: const TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                               // Solo permitir editar si la reserva está en estado 'Pendiente' o similar
                              if (reserva.estado.toLowerCase() == 'pendiente') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<ReservaBloc>(context),
                                      child: FormReservaScreen(reserva: reserva),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Solo se pueden editar reservas pendientes.'))
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel_outlined, color: Colors.orange[700]),
                            onPressed: () {
                              // Lógica para cancelar reserva (cambiar estado)
                              if (reserva.estado.toLowerCase() == 'pendiente' || reserva.estado.toLowerCase() == 'confirmada') {
                                 _showCancelConfirmationDialog(context, reserva, context.read<ReservaBloc>());
                              } else {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('La reserva ya está ${reserva.estado.toLowerCase()} o completada.'))
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Pantalla de detalle de reserva
                        print('Tap en reserva ${reserva.id}');
                      },
                    ),
                  );
                },
              );
            } else if (state is ReservaError) {
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
                 builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<ReservaBloc>(context),
                    child: const FormReservaScreen(),
                  ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'confirmada':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'cancelada':
        return Colors.red;
      case 'completada':
        return Colors.blueGrey;
      default:
        return Colors.black;
    }
  }

  void _showCancelConfirmationDialog(BuildContext context, Reserva reserva, ReservaBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Cancelación'),
          content: Text('¿Estás seguro de que deseas cancelar la reserva para "${reserva.nombreHospedaje}"?'),
          actions: <Widget>[
            TextButton(child: const Text('No'), onPressed: () => Navigator.of(ctx).pop()),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sí, Cancelar'),
              onPressed: () {
                // Crear una copia de la reserva con el nuevo estado
                Reserva reservaCancelada = reserva.copyWith(estado: 'Cancelada');
                bloc.add(UpdateReserva(reservaCancelada)); // Usar el evento UpdateReserva
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
