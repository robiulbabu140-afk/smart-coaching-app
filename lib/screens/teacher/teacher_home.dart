import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../services/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../call/in_call_screen.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});
  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  List<Batch> _batches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    try {
      final data = await ApiService.getBatches();
      setState(() {
        _batches = data.map((b) => Batch.fromJson(b)).toList();
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadBatches,
          color: AppColors.primary,
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('আপনার ব্যাচ', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.muted, letterSpacing: .15)),
                    Text(user?.fullName ?? 'Teacher',
                        style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.white)),
                  ]),
                  _LogoutBtn(),
                ]),
              ),
            ),

            if (_loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _TeacherBatchCard(batch: _batches[i]),
                    childCount: _batches.length,
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(children: [
                    const Icon(Icons.lock_outline, color: AppColors.primaryLight, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('ছাত্রদের পরিচয় বা নম্বর আপনার কাছে দেখানো হবে না',
                          style: GoogleFonts.outfit(fontSize: 11, color: AppColors.primaryLight)),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _TeacherBatchCard extends StatelessWidget {
  final Batch batch;
  const _TeacherBatchCard({required this.batch});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(batch.name,
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white)),
                if (batch.subject != null)
                  Text(batch.subject!,
                      style: GoogleFonts.outfit(fontSize: 12, color: AppColors.muted)),
              ]),
            ),
            Row(children: [
              const Icon(Icons.people_outline_rounded, color: AppColors.muted, size: 16),
              const SizedBox(width: 4),
              Text('${batch.memberCount}',
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.muted)),
            ]),
          ]),
          if (batch.scheduleDays.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 6, children: batch.scheduleDays.map((d) =>
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(d, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryLight)),
              )
            ).toList()),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.call_rounded, size: 16),
              label: Text('ক্লাস শুরু করুন', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InCallScreen(batch: batch, role: 'teacher')),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ]),
      );
}

class _LogoutBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => context.read<AuthProvider>().logout(),
        icon: const Icon(Icons.logout_rounded, color: AppColors.muted),
        tooltip: 'লগআউট',
      );
}
