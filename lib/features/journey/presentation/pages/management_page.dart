import 'package:TBConsult/core/di/injection_container.dart';
import 'package:TBConsult/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:TBConsult/features/medication/presentation/cubit/medication_state.dart'; // Pastikan import state-nya
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';
import 'package:TBConsult/features/journey/domain/entities/achievement_entity.dart';
import 'package:TBConsult/features/journey/presentation/cubit/journey_cubit.dart';
import 'package:TBConsult/features/journey/presentation/cubit/journey_state.dart';
import 'package:TBConsult/features/journey/presentation/pages/adjust_journey_page.dart';
import 'package:TBConsult/features/journey/presentation/widgets/month_card.dart';
import 'package:TBConsult/features/journey/presentation/widgets/achievement_card.dart';
import 'package:TBConsult/features/medication/presentation/pages/log_medication_page.dart';

class ManagementPage extends StatefulWidget {
  final String journeyId;

  const ManagementPage({super.key, required this.journeyId});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final Color _bgColor = const Color(0xFFF7F9F9);

  // Inisialisasi Cubit khusus untuk menampung data Achievements di halaman ini
  late final MedicationCubit _medicationCubit;

  @override
  void initState() {
    super.initState();
    // Fetch detail journey
    context.read<JourneyCubit>().loadJourneyDetail(widget.journeyId);

    // Fetch achievements dari backend saat halaman dibuka
    _medicationCubit = sl<MedicationCubit>()..loadAchievements();
  }

  @override
  void dispose() {
    _medicationCubit.close();
    super.dispose();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Perjalanan?'),
        content: const Text('Apakah Anda yakin ingin menghapus rencana pengobatan ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<JourneyCubit>().deleteJourney(widget.journeyId);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap Scaffold dengan BlocProvider MedicationCubit agar bisa diakses oleh anak-anaknya
    return BlocProvider.value(
      value: _medicationCubit,
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _bgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Journey Details',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _confirmDelete,
              tooltip: 'Hapus Rencana',
            ),
          ],
        ),
        body: BlocConsumer<JourneyCubit, JourneyState>(
          listener: (context, state) {
            if (state is JourneyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
            if (state is JourneyResetSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Journey adjusted successfully')),
              );
              context.read<JourneyCubit>().loadJourneyDetail(state.result.newJourney.id);
            }
            if (state is JourneyDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is JourneyLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is JourneyDetailLoaded) {
              return _DetailBody(
                journey: state.journey,
                stats: state.stats,
                onLogMedication: () async {
                  final journeyCubit = context.read<JourneyCubit>();
                  final medicationCubit = context.read<MedicationCubit>(); // Ambil dari Provider

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: journeyCubit),
                          BlocProvider.value(value: medicationCubit), // Reuse Cubit yang sama
                        ],
                        child: LogMedicationPage(journey: state.journey),
                      ),
                    ),
                  );
                  // Refresh Journey & Achievements saat kembali dari halaman log
                  if (context.mounted) {
                    journeyCubit.loadJourneyDetail(state.journey.id);
                    medicationCubit.loadAchievements();
                  }
                },
                onAdjust: () {
                  final journeyCubit = context.read<JourneyCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: journeyCubit,
                        child: AdjustJourneyPage(journey: state.journey),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is JourneyError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<JourneyCubit>().loadJourneyDetail(widget.journeyId),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Journey journey;
  final JourneyStats? stats;
  final VoidCallback onLogMedication;
  final VoidCallback onAdjust;

  const _DetailBody({
    required this.journey,
    required this.onLogMedication,
    required this.onAdjust,
    this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = const Color(0xFF005B4F);

    final bool isActive = journey.status.toLowerCase() == 'active';

    bool isTodayCompleted = false;
    if (stats != null) {
      final today = DateTime.now();
      isTodayCompleted = stats!.completedDates.any((d) =>
      d.year == today.year && d.month == today.month && d.day == today.day);
    }

    final bool canLog = isActive && !isTodayCompleted;

    // ── LOGIC KALENDER DINAMIS ─────────────────────────────────────────
    final DateTime start = journey.startDate;
    final DateTime end = journey.endDate ?? DateTime.now();

    int totalMonths = (end.year - start.year) * 12 + end.month - start.month + 1;
    if (totalMonths <= 0) totalMonths = 1;

    List<Widget> calendarWidgets = [];
    for (int i = 0; i < totalMonths; i++) {
      int targetMonth = start.month + i;
      int year = start.year + (targetMonth - 1) ~/ 12;
      int month = (targetMonth - 1) % 12 + 1;

      List<int> takenDays = stats?.completedDates
          .where((d) => d.year == year && d.month == month)
          .map((d) => d.day)
          .toList() ?? [];

      calendarWidgets.add(
        MonthCard(
          monthTitle: 'Month ${i + 1}',
          takenDays: takenDays,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Journey header card ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        journey.name,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _StatusChip(status: journey.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      '${_formatDate(journey.startDate)} - ${journey.endDate != null ? _formatDate(journey.endDate!) : "Ongoing"}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (journey.clinicalNotes != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            journey.clinicalNotes!,
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Stats card ───────────────────────────────────────────────
          if (stats != null) ...[
            const Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _StatRow(
                    label: 'Adherence',
                    value: '${stats!.adherencePercent.toStringAsFixed(1)}%',
                    icon: Icons.check_circle_outline,
                    color: stats!.onTrack ? primaryColor : Colors.orange,
                  ),
                  Divider(height: 24, color: Colors.grey[200]),
                  _StatRow(
                    label: 'Current Streak',
                    value: '${stats!.currentStreak} days',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                  Divider(height: 24, color: Colors.grey[200]),
                  _StatRow(
                    label: 'Longest Streak',
                    value: '${stats!.longestStreak} days',
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                  Divider(height: 24, color: Colors.grey[200]),
                  Row(
                    children: [
                      Expanded(child: _MiniStat(label: 'Taken', value: '${stats!.totalDosesTaken}', color: primaryColor)),
                      Expanded(child: _MiniStat(label: 'Missed', value: '${stats!.totalDosesMissed}', color: Colors.red)),
                      Expanded(child: _MiniStat(label: 'Days', value: '${stats!.daysElapsed}', color: Colors.blue)),
                    ],
                  ),
                  if (stats!.interrupted) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Treatment interrupted${stats!.daysSinceLastLog != null ? ' (${stats!.daysSinceLastLog} days ago)' : ''}. Consider adjusting your plan.',
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // ── ACTION BUTTONS ───────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canLog ? onLogMedication : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    isTodayCompleted ? Icons.check_circle : Icons.add_task,
                    color: canLog ? Colors.white : Colors.grey[500],
                  ),
                  label: Text(
                    isTodayCompleted ? 'Completed Today' : 'Log Medication',
                    style: TextStyle(
                      color: canLog ? Colors.white : Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isActive ? onAdjust : null,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: isActive ? Colors.grey[300]! : Colors.grey[200]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.tune,
                    color: isActive ? Colors.black87 : Colors.grey[400],
                  ),
                  label: Text(
                    'Adjust',
                    style: TextStyle(
                      color: isActive ? Colors.black87 : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── Treatment Calendar ───────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Treatment Calendar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text('Dose Taken', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...calendarWidgets,
          const SizedBox(height: 24),

          // ── Achievements (DINAMIS VIA BLOCBUILDER) ───────────────────
          const Text(
            'Achievements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          BlocBuilder<MedicationCubit, MedicationState>(
            builder: (context, medState) {
              if (medState is MedicationLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (medState is AchievementsLoaded) {
                final userAchievements = medState.achievements;

                if (userAchievements.isEmpty) {
                  return const Center(child: Text('Belum ada data pencapaian.'));
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: userAchievements.map((userAch) {
                    return AchievementCard(
                      achievement: AchievementEntity(
                        title: userAch.achievement.title,
                        description: userAch.achievement.description,
                        isLocked: !userAch.unlocked,
                        iconType: userAch.achievement.icon ?? 'medal',
                      ),
                    );
                  }).toList(),
                );
              }

              if (medState is MedicationError) {
                return Center(
                  child: Text(
                    'Gagal memuat achievements: ${medState.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // State Initial
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 24),

          // ── Prescribed doses ─────────────────────────────────────────
          if (journey.prescribedDoses.isNotEmpty) ...[
            const Text(
              'Prescribed Doses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...journey.prescribedDoses
                .where((d) => d.isActive)
                .map(
                  (dose) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE0F7FA),
                    child: Icon(Icons.medication, color: primaryColor),
                  ),
                  title: Text(
                    dose.medicationName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${dose.dosageMg} mg · ${dose.pillCount} pills · ${dose.frequency}',
                  ),
                  trailing: dose.instructions != null
                      ? Tooltip(
                    message: dose.instructions!,
                    child: Icon(Icons.info_outline, color: Colors.grey[400]),
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
}

// ... [SISA KODE _StatusChip, _StatRow, _MiniStat SAMA SEPERTI SEBELUMNYA] ...

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status.toLowerCase()) {
      'active' => const Color(0xFF67E5CE),
      'completed' => Colors.blue[100],
      'reset' => Colors.orange[100],
      _ => Colors.grey[200],
    };
    final textColor = switch (status.toLowerCase()) {
      'active' => const Color(0xFF005B4F),
      'completed' => Colors.blue[800],
      'reset' => Colors.orange[800],
      _ => Colors.grey[800],
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}