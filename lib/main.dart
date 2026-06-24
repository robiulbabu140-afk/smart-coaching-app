import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_provider.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/student/student_home.dart';
import 'screens/teacher/teacher_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..fetchMe(),
      child: const SmartCoachingApp(),
    ),
  );
}

class SmartCoachingApp extends StatelessWidget {
  const SmartCoachingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Coaching',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _RootRouter(),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (!auth.isLoggedIn) return const LoginScreen();

    final role = auth.user?.role ?? '';
    if (role == 'teacher') return const TeacherHome();
    if (role == 'student') return const StudentHome();

    // Admin → redirect to admin panel notice
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primaryLight, size: 56),
          const SizedBox(height: 16),
          Text('Admin account',
              style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Admin panel ব্যবহার করুন:\nsmart-coaching-admin.onrender.com/admin',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.read<AuthProvider>().logout(),
            child: Text('লগআউট', style: TextStyle(color: AppColors.danger)),
          ),
        ]),
      ),
    );
  }
}
