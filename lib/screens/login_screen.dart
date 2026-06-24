import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    try {
      await auth.login(_phoneCtrl.text.trim(), _passCtrl.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Logo
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 20),
              Text('Smart Coaching',
                  style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.white)),
              const SizedBox(height: 6),
              Text('আপনার ফোন ও পাসওয়ার্ড দিয়ে লগইন করুন',
                  style: GoogleFonts.outfit(fontSize: 13, color: AppColors.muted),
                  textAlign: TextAlign.center),
              const SizedBox(height: 48),

              // Phone
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ফোন নম্বর', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 6),
                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: '01XXXXXXXXX',
                    prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.muted, size: 20),
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              // Password
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('পাসওয়ার্ড', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 6),
                TextField(
                  controller: _passCtrl,
                  obscureText: !_showPass,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.muted, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.muted, size: 20),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.loading ? null : _login,
                  child: auth.loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('লগইন করুন', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(.2)),
                ),
                child: Row(children: [
                  const Icon(Icons.lock_outline, color: AppColors.primaryLight, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('আপনার তথ্য সম্পূর্ণ নিরাপদ ও এনক্রিপ্টেড',
                        style: GoogleFonts.outfit(fontSize: 12, color: AppColors.primaryLight)),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
