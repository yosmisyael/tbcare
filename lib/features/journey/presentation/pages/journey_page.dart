import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/core/widgets/shared_sliver_app_bar.dart';
import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';
import 'package:TBConsult/features/journey/presentation/cubit/journey_cubit.dart';
import 'package:TBConsult/features/journey/presentation/cubit/journey_state.dart';
import 'package:TBConsult/features/journey/presentation/pages/add_plan_page.dart';
import 'package:TBConsult/features/journey/presentation/pages/management_page.dart';
import 'package:TBConsult/features/journey/presentation/widgets/plan_card.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key});

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  @override
  void initState() {
    super.initState();
    context.read<JourneyCubit>().loadJourneys();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<JourneyCubit>().refresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SharedSliverAppBar(
                pinned: true,
                floating: false,
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'My Journeys',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Active medication plans',
                                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: AppColors.primary),
                            onPressed: () => context.read<JourneyCubit>().refresh(),
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<JourneyCubit, JourneyState>(
                      listener: (context, state) {
                        if (state is JourneyError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is JourneyLoading) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 64.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is JourneyListLoaded) {
                          return _JourneyList(journeys: state.journeys);
                        }
                        if (state is JourneyError) {
                          return _ErrorView(
                            message: state.message,
                            onRetry: () =>
                                context.read<JourneyCubit>().loadJourneys(),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.only(top: 64.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(

              onPressed: () async {
                final journeyCubit = context.read<JourneyCubit>();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: journeyCubit,
                      child: const AddPlanPage(),
                    ),
                  ),
                );
                if (mounted) context.read<JourneyCubit>().refresh();
              },
              backgroundColor: const Color(0xFF005B4F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      );
  }
}

class _JourneyList extends StatelessWidget {
  final List<JourneyListItem> journeys;

  const _JourneyList({required this.journeys});

  @override
  Widget build(BuildContext context) {
    if (journeys.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 64.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.medication_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No active medication plans',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Press the + button to create one',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        final journeyCubit = context.read<JourneyCubit>();
        final item = journeys[index];
        return PlanCard(
          journey: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: journeyCubit,
                  child: ManagementPage(journeyId: item.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
