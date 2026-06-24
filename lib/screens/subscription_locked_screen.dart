import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SubscriptionLockedScreen extends StatelessWidget {
  const SubscriptionLockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline_rounded, color: AppColors.accent, size: 32),
              ),
              const SizedBox(height: 24),
              Text('সাবস্ক্রিপশনের মেয়াদ শেষ',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.white),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'ক্লাসে যুক্ত হতে আপনার সাবস্ক্রিপশন রিনিউ করুন।\nপ্রতি মাসে মাত্র ৫০০ টাকা।',
                style: GoogleFonts.outfit(fontSize: 14, color: AppColors.muted, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: const Color(0xFF1B0F2E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('এখনই পেমেন্ট করুন',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1B0F2E))),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('পরে করব', style: GoogleFonts.outfit(color: AppColors.muted, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
