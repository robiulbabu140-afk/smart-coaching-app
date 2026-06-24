import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../services/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../call/incoming_call_screen.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});
  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
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
                    Text('স্বাগতম', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.muted, letterSpacing: .15)),
                    Text(user?.fullName ?? 'Student',
                        style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.white)),
                  ]),
                  _Avatar(name: user?.fullName ?? 'S'),
                ]),
              ),
            ),

            if (_loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              )
            else if (_batches.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text('কোনো ব্যাচে যুক্ত নেই।',
                      style: GoogleFonts.outfit(color: AppColors.muted)),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _BatchCard(batch: _batches[i]),
                    childCount: _batches.length,
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: _PrivacyNote(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _BatchCard extends StatelessWidget {
  final Batch batch;
  const _BatchCard({required this.batch});

  bool get isLive => batch.status == 'active';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLive
          ? () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => IncomingCallScreen(batch: batch)))
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isLive
              ? const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)])
              : null,
          color: isLive ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isLive ? Colors.transparent : AppColors.cardBorder),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(batch.name,
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white)),
                const SizedBox(height: 3),
                Text(batch.subject ?? 'বিষয় নেই',
                    style: GoogleFonts.outfit(fontSize: 12,
                        color: isLive ? Colors.white.withOpacity(.7) : AppColors.muted)),
              ]),
            ),
            if (isLive)
              _LivePill()
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ]),
          if (batch.scheduleDays.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 6, children: batch.scheduleDays.map((d) => _DayChip(day: d, live: isLive)).toList()),
          ],
          if (batch.scheduleTime != null) ...[
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.schedule_rounded, size: 13, color: isLive ? Colors.white54 : AppColors.muted),
              const SizedBox(width: 4),
              Text(batch.scheduleTime!,
                  style: GoogleFonts.outfit(fontSize: 11, color: isLive ? Colors.white54 : AppColors.muted)),
            ]),
          ],
        ]),
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 7, height: 7,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text('ক্লাস চলছে',
              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      );
}

class _DayChip extends StatelessWidget {
  final String day;
  final bool live;
  const _DayChip({required this.day, required this.live});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: live ? Colors.white.withOpacity(.15) : AppColors.primary.withOpacity(.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(day,
            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600,
                color: live ? Colors.white : AppColors.primaryLight)),
      );
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});
  @override
  Widget build(BuildContext context) => Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        child: Center(
          child: Text(name.isNotEmpty ? name[0] : 'S',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      );
}

class _PrivacyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          const Icon(Icons.lock_outline, color: AppColors.primaryLight, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text('আপনার পরিচয় কখনো শিক্ষকের সাথে শেয়ার হয় না',
                style: GoogleFonts.outfit(fontSize: 11, color: AppColors.primaryLight)),
          ),
        ]),
      );
}
