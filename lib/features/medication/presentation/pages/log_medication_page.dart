import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';
import 'package:TBConsult/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:TBConsult/features/medication/presentation/cubit/medication_state.dart';

class LogMedicationPage extends StatefulWidget {
  final Journey journey;
  const LogMedicationPage({super.key, required this.journey});

  @override
  State<LogMedicationPage> createState() => _LogMedicationPageState();
}

class _LogMedicationPageState extends State<LogMedicationPage> {
  final _notesCtrl = TextEditingController();
  DateTime _timeTaken = DateTime.now();

  /// dose id → taken status
  late final Map<String, bool> _takenMap;

  @override
  void initState() {
    super.initState();
    _takenMap = {
      for (final d in widget.journey.prescribedDoses.where((d) => d.isActive))
        d.id: true, // default all checked
    };
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _timeTaken,
      firstDate: now.subtract(const Duration(days: 7)),
      lastDate: now,
    );
    if (!mounted || pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_timeTaken),
    );
    if (!mounted || pickedTime == null) return;

    setState(() {
      _timeTaken = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (_takenMap.isEmpty) return;

    final entries = _takenMap.entries
        .map((e) => {'prescribed_dose_id': e.key, 'taken': e.value})
        .toList();

    await context.read<MedicationCubit>().submitLog(
      journeyId: widget.journey.id,
      timeTaken: _timeTaken,
      entries: entries,
      notes:
      _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeDoses =
    widget.journey.prescribedDoses.where((d) => d.isActive).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Catat Konsumsi Obat')),
      body: BlocListener<MedicationCubit, MedicationState>(
        listener: (context, state) {
          if (state is MedicationLogSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Konsumsi obat berhasil dicatat!')),
            );
            Navigator.pop(context);
          }
          if (state is MedicationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Time picker ────────────────────────────────────────
            InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Waktu Konsumsi',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(_formatDateTime(_timeTaken)),
              ),
            ),
            const SizedBox(height: 20),

            // ── Dose checklist ─────────────────────────────────────
            Text('Dosis', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (activeDoses.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Tidak ada dosis aktif pada perjalanan ini.'),
                ),
              )
            else
              ...activeDoses.map((dose) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  title: Text(dose.medicationName),
                  subtitle: Text(
                    '${dose.dosageMg} mg · ${dose.pillCount} tablet',
                  ),
                  value: _takenMap[dose.id] ?? false,
                  onChanged: (v) =>
                      setState(() => _takenMap[dose.id] = v ?? false),
                  secondary: CircleAvatar(
                    backgroundColor:
                    (_takenMap[dose.id] ?? false)
                        ? Colors.green
                        : Colors.grey.shade300,
                    child: Icon(
                      (_takenMap[dose.id] ?? false)
                          ? Icons.check
                          : Icons.medication,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              )),

            const SizedBox(height: 16),

            // ── Notes ──────────────────────────────────────────────
            TextField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                hintText: 'Efek samping, kondisi tubuh, dll.',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            BlocBuilder<MedicationCubit, MedicationState>(
              builder: (context, state) {
                final loading = state is MedicationLoading;
                return ElevatedButton(
                  onPressed:
                  (loading || activeDoses.isEmpty) ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child:
                    CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Konfirmasi Konsumsi'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$date $hour:$minute';
  }
}
