import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../models/user.dart'; // Para acceder al tipo User
// Importar las pantallas de listado
import '../servicios_turisticos/list_servicios_screen.dart';
import '../hospedajes/list_hospedajes_screen.dart';
import '../reservas/list_reservas_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario del AuthBloc para personalizar el saludo
    // Es importante asegurarse que AuthBloc esté disponible y en estado Authenticated
    // cuando se navega a esta pantalla.
    final User? currentUser = (context.watch<AuthBloc>().state is Authenticated)
        ? (context.watch<AuthBloc>().state as Authenticated).user
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capachica Turismo - Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              // Disparar evento de logout
              context.read<AuthBloc>().add(AuthLogoutRequested());
              // La navegación a LoginScreen será manejada por el listener principal en main.dart
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (currentUser != null)
              Text(
                '¡Bienvenido, ${currentUser.username}!',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            else
              Text(
                '¡Bienvenido!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            const SizedBox(height: 24),
            Text(
              'Explora y gestiona tu viaje:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              context,
              icon: Icons.room_service,
              title: 'Servicios Turísticos',
              subtitle: 'Ver y gestionar actividades',
              onTap: () => _navigateTo(context, const ListServiciosScreen()),
            ),
            const SizedBox(height: 12),
            _buildNavigationCard(
              context,
              icon: Icons.hotel,
              title: 'Hospedajes',
              subtitle: 'Explorar y administrar hospedajes',
              onTap: () => _navigateTo(context, const ListHospedajesScreen()),
            ),
            const SizedBox(height: 12),
            _buildNavigationCard(
              context,
              icon: Icons.calendar_today,
              title: 'Mis Reservas',
              subtitle: 'Consultar y administrar tus reservas',
              onTap: () => _navigateTo(context, const ListReservasScreen()),
            ),
            // Aquí podrías añadir más opciones de navegación o información.
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
