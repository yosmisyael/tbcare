import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final Color _bgColor = const Color(0xFFF7F9F9);

  @override
  void initState() {
    super.initState();
    context.read<JourneyCubit>().loadJourneys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        toolbarHeight: 0, // Sembunyikan appBar default, kita pake custom text
      ),
      floatingActionButton: FloatingActionButton(
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Journeys',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Active medication plans',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.black54),
                    onPressed: () => context.read<JourneyCubit>().refresh(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<JourneyCubit, JourneyState>(
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
                  if (state is JourneyLoading)
                    return const Center(child: CircularProgressIndicator());
                  if (state is JourneyListLoaded)
                    return _JourneyList(journeys: state.journeys);
                  if (state is JourneyError)
                    return _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<JourneyCubit>().loadJourneys(),
                    );
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyList extends StatelessWidget {
  final List<JourneyListItem> journeys;

  const _JourneyList({required this.journeys});

  @override
  Widget build(BuildContext context) {
    if (journeys.isEmpty) {
      return Center(
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
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<JourneyCubit>().loadJourneys(),
      child: ListView.builder(
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
      ),
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
