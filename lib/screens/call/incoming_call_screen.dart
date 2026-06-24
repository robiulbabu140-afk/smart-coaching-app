import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';
import 'in_call_screen.dart';

class IncomingCallScreen extends StatelessWidget {
  final Batch batch;
  const IncomingCallScreen({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.4),
            radius: 1.2,
            colors: [const Color(0xFF3B1D6E), AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 32),
              // Top info
              Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(.3)),
                  ),
                  child: Text('লাইভ ক্লাস',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent, letterSpacing: .08)),
                ),
                const SizedBox(height: 16),
                Text(batch.name,
                    style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.white)),
                const SizedBox(height: 6),
                Text('শিক্ষক আপনাকে কল করছেন',
                    style: GoogleFonts.outfit(fontSize: 13, color: AppColors.muted)),
              ]),

              // Avatar with rings
              Stack(alignment: Alignment.center, children: [
                _Ring(size: 160, opacity: .1),
                _Ring(size: 120, opacity: .2),
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryLight.withOpacity(.4), width: 2),
                  ),
                  child: Center(
                    child: Text(batch.name[0],
                        style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.white)),
                  ),
                ),
              ]),

              // Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _CallButton(
                    icon: Icons.call_end_rounded,
                    color: AppColors.danger,
                    label: 'বাতিল',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 56),
                  _CallButton(
                    icon: Icons.call_rounded,
                    color: AppColors.success,
                    label: 'রিসিভ করুন',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => InCallScreen(batch: batch, role: 'student')),
                    ),
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

class _Ring extends StatelessWidget {
  final double size;
  final double opacity;
  const _Ring({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withOpacity(opacity), width: 1.5),
        ),
      );
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _CallButton({required this.icon, required this.color, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.muted)),
        ]),
      );
}
