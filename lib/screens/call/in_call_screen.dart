import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user.dart';
import '../../theme/app_theme.dart';

class InCallScreen extends StatefulWidget {
  final Batch batch;
  final String role;
  const InCallScreen({super.key, required this.batch, required this.role});
  @override
  State<InCallScreen> createState() => _InCallScreenState();
}

class _InCallScreenState extends State<InCallScreen> {
  bool _muted = false;
  bool _videoOff = false;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  List<String> get _tiles => widget.role == 'student'
      ? ['আপনি', 'শিক্ষক']
      : ['আপনি', 'ছাত্র #১', 'ছাত্র #২', 'ছাত্র #৩'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0817),
      body: SafeArea(
        child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Container(width: 7, height: 7,
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('লাইভ $_timerLabel',
                      style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent)),
                ]),
              ),
              Text(widget.batch.name,
                  style: GoogleFonts.outfit(fontSize: 12, color: AppColors.muted)),
            ]),
          ),

          // Video tiles
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: _tiles.map((label) => _VideoTile(
                  label: label,
                  isMe: label == 'আপনি',
                  videoOff: label == 'আপনি' && _videoOff,
                )).toList(),
              ),
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _ControlBtn(
                icon: _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                active: _muted,
                onTap: () => setState(() => _muted = !_muted),
                tooltip: 'মাইক',
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 64, height: 64,
                  decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                  child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: 20),
              _ControlBtn(
                icon: _videoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                active: _videoOff,
                onTap: () => setState(() => _videoOff = !_videoOff),
                tooltip: 'ক্যামেরা',
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final String label;
  final bool isMe;
  final bool videoOff;
  const _VideoTile({required this.label, this.isMe = false, this.videoOff = false});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: isMe ? AppColors.surface : const Color(0xFF1F1335),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Center(
          child: videoOff
              ? const Icon(Icons.videocam_off_rounded, color: AppColors.muted, size: 28)
              : Text(label, style: GoogleFonts.outfit(fontSize: 13, color: AppColors.muted)),
        ),
      );
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final String tooltip;
  const _ControlBtn({required this.icon, required this.active, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white.withOpacity(.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      );
}
