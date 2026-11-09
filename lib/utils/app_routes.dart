import 'package:flutter/material.dart';

import '../models/task.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/home_shell.dart';
import '../screens/tasks/task_form_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const addTask = '/tasks/new';
  static const editTask = '/tasks/edit';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute<RegisterResult>(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeShell(),
          settings: settings,
        );
      case addTask:
        return MaterialPageRoute<void>(
          builder: (_) => const TaskFormScreen(),
          settings: settings,
        );
      case editTask:
        final task = settings.arguments;
        if (task is Task) {
          return MaterialPageRoute<void>(
            builder: (_) => TaskFormScreen(task: task),
            settings: settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => const HomeShell(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
