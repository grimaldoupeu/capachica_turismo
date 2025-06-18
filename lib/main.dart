import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoCs
import 'blocs/auth_bloc/auth_bloc.dart';
// Importa otros BLoCs que quieras proveer globalmente si es necesario
// import 'blocs/servicio_turistico_bloc/servicio_turistico_bloc.dart';
// import 'blocs/hospedaje_bloc/hospedaje_bloc.dart';
// import 'blocs/reserva_bloc/reserva_bloc.dart';

// Services
import 'services/auth_service.dart';
// Importa otros Services si los BLoCs los necesitan instanciados aquí
// import 'services/servicio_turistico_service.dart';
// import 'services/hospedaje_service.dart';
// import 'services/reserva_service.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() {
  // Aquí podrías inicializar servicios globales si es necesario (ej. GetIt)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instanciar servicios que se pasarán a los BLoCs
    final authService = AuthService();
    // final servicioTuristicoService = ServicioTuristicoService(); // Ejemplo
    // final hospedajeService = HospedajeService(); // Ejemplo
    // final reservaService = ReservaService(); // Ejemplo

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService)..add(AuthAppStarted()),
        ),
        // Aquí podrías proveer otros BLoCs si fueran necesarios a nivel global
        // o si prefieres instanciarlos aquí en lugar de en cada pantalla de listado.
        // Ejemplo:
        // BlocProvider<ServicioTuristicoBloc>(
        //   create: (context) => ServicioTuristicoBloc(servicioTuristicoService),
        // ),
        // BlocProvider<HospedajeBloc>(
        //   create: (context) => HospedajeBloc(hospedajeService),
        // ),
        // BlocProvider<ReservaBloc>(
        //   create: (context) => ReservaBloc(reservaService),
        // ),
      ],
      child: MaterialApp(
        title: 'Capachica Turismo',
        theme: ThemeData(
          primarySwatch: Colors.blue, // Puedes personalizar tu tema
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(), // Widget que decide la pantalla inicial
        // Podrías definir rutas aquí si usas navegación con nombre:
        // routes: {
        //   '/login': (context) => const LoginScreen(),
        //   '/home': (context) => const HomeScreen(),
        //   '/admin': (context) => const AdminDashboardScreen(),
        //   // ... otras rutas
        // },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Podrías manejar efectos secundarios aquí si es necesario,
        // como mostrar SnackBars globales para ciertos cambios de estado de Auth.
      },
      builder: (context, state) {
        if (state is Authenticated) {
          if (state.user.isAdmin) {
            return const AdminDashboardScreen();
          }
          return const HomeScreen();
        }
        if (state is Unauthenticated || state is AuthFailure) {
          return const LoginScreen();
        }
        // AuthInitial, AuthLoading
        return const SplashScreen(); // Pantalla de carga inicial
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Cargando aplicación...'),
          ],
        ),
      ),
    );
  }
}
