import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../models/user.dart'; // Para acceder al tipo User
// Importar las pantallas de listado que el admin también podría usar
import '../servicios_turisticos/list_servicios_screen.dart';
import '../hospedajes/list_hospedajes_screen.dart';
import '../reservas/list_reservas_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = (context.watch<AuthBloc>().state is Authenticated)
        ? (context.watch<AuthBloc>().state as Authenticated).user
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
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
                'Bienvenido, Admin ${currentUser.username}!',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            else
              Text(
                'Panel de Administración',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            const SizedBox(height: 24),
            Text(
              'Gestión de la Plataforma:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Secciones CRUD comunes (Admin también las usa)
            _buildNavigationCard(
              context,
              icon: Icons.room_service,
              title: 'Gestionar Servicios Turísticos',
              onTap: () => _navigateTo(context, const ListServiciosScreen()),
            ),
            const SizedBox(height: 12),
            _buildNavigationCard(
              context,
              icon: Icons.hotel,
              title: 'Gestionar Hospedajes',
              onTap: () => _navigateTo(context, const ListHospedajesScreen()),
            ),
            const SizedBox(height: 12),
            _buildNavigationCard(
              context,
              icon: Icons.calendar_today,
              title: 'Gestionar Reservas',
              onTap: () => _navigateTo(context, const ListReservasScreen()),
            ),
            const Divider(height: 32, thickness: 1),

            // Secciones específicas de Admin (Placeholders)
            Text(
              'Herramientas de Administrador:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              context,
              icon: Icons.people,
              title: 'Gestionar Usuarios',
              onTap: () {
                // TODO: Navegar a pantalla de gestión de usuarios
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pantalla de Gestión de Usuarios (Pendiente)')));
              },
            ),
            const SizedBox(height: 12),
            _buildNavigationCard(
              context,
              icon: Icons.bar_chart,
              title: 'Ver Reportes',
               onTap: () {
                // TODO: Navegar a pantalla de reportes
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pantalla de Reportes (Pendiente)')));
              },
            ),
             const SizedBox(height: 12),
            _buildNavigationCard(
              context,
              icon: Icons.settings,
              title: 'Configuración General',
               onTap: () {
                // TODO: Navegar a pantalla de configuración
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pantalla de Configuración (Pendiente)')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
