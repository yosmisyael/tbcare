import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/treatment/domain/entities/dashboard_entity.dart';
import 'package:TBConsult/features/treatment/presentation/cubit/dashboard_cubit.dart';
import 'package:TBConsult/features/treatment/presentation/cubit/dashboard_state.dart';
import 'package:TBConsult/features/treatment/presentation/widgets/next_dose_card.dart';
import 'package:TBConsult/features/treatment/presentation/widgets/treatement_progress_card.dart';
import 'package:TBConsult/core/widgets/shared_sliver_app_bar.dart';

class TreatmentDashboardPage extends StatefulWidget {
  const TreatmentDashboardPage({super.key});

  @override
  State<TreatmentDashboardPage> createState() =>
      _TreatmentDashboardPageState();
}

class _TreatmentDashboardPageState extends State<TreatmentDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: _onStateChange,
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is DashboardError) {
          return _ErrorBody(
            message: state.message,
            onRetry: () => context.read<DashboardCubit>().load(),
          );
        }

        DashboardViewModel? vm;
        bool isSubmitting = false;

        if (state is DashboardLoaded) vm = state.viewModel;
        if (state is DashboardLogSubmitting) {
          vm = state.viewModel;
          isSubmitting = true;
        }

        if (vm == null) return const SizedBox.shrink();

        return _DashboardBody(
          viewModel: vm,
          isSubmitting: isSubmitting,
        );
      },
    );
  }

  void _onStateChange(BuildContext context, DashboardState state) {
    if (state is DashboardError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ));
    }
  }
}

// ── Main scrollable body ──────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  final DashboardViewModel viewModel;
  final bool isSubmitting;

  const _DashboardBody({
    required this.viewModel,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final greeting = _greeting();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<DashboardCubit>().refresh(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SharedSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Greeting ────────────────────────────────────
                Text(
                  '$greeting,\n${viewModel.userName}.',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // ── Streak badge ─────────────────────────────────
                if (viewModel.currentStreak > 0)
                  _StreakBadge(days: viewModel.currentStreak),

                const SizedBox(height: 28),

                // ── Progress cards (swipeable) ───────────────────
                TreatmentProgressCard(items: viewModel.journeyItems),

                const SizedBox(height: 24),

                // ── Section label ────────────────────────────────
                _SectionHeader(
                  title: viewModel.pendingToday.isEmpty
                      ? 'Status Hari Ini'
                      : 'Obat Belum Dicatat',
                  subtitle: viewModel.pendingToday.isEmpty
                      ? null
                      : '${viewModel.pendingToday.length} perjalanan perlu dicatat',
                ),
                const SizedBox(height: 12),

                // ── Dose reminder / all-done ─────────────────────
                NextDoseSection(
                  pendingItems: viewModel.pendingToday,
                  isSubmitting: isSubmitting,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}

// ── Subwidgets ────────────────────────────────────────────────────────────────

class _StreakBadge extends StatelessWidget {
  final int days;
  const _StreakBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.deepOrange, size: 18),
          const SizedBox(width: 8),
          Text(
            '$days-Day Streak',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary),
          ),
      ],
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
