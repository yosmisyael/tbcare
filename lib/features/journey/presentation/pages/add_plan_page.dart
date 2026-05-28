import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TBConsult/features/journey/presentation/cubit/journey_cubit.dart';
import 'package:TBConsult/features/journey/presentation/cubit/journey_state.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({super.key});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  final List<_DoseFormData> _doses = [];

  final Color _primaryColor = const Color(0xFF005B4F);
  final Color _bgColor = const Color(0xFFF7F9F9);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: _primaryColor)),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  void _addDose() {
    setState(() => _doses.add(_DoseFormData()));
  }

  void _removeDose(int index) {
    setState(() => _doses.removeAt(index));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_doses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal satu dosis')),
      );
      return;
    }

    final doses = _doses
        .map(
          (d) => {
            'medication_name': d.nameCtrl.text.trim(),
            'dosage_mg': double.parse(d.dosageCtrl.text.trim()),
            'pill_count': int.parse(d.pillCtrl.text.trim()),
            'frequency': d.frequency,
            if (d.instrCtrl.text.trim().isNotEmpty)
              'instructions': d.instrCtrl.text.trim(),
          },
        )
        .toList();

    await context.read<JourneyCubit>().createJourney(
      name: _nameCtrl.text.trim(),
      startDate: _startDate,
      clinicalNotes: _notesCtrl.text.trim().isEmpty
          ? null
          : _notesCtrl.text.trim(),
      prescribedDoses: doses,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Set Up Medication Plan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: BlocListener<JourneyCubit, JourneyState>(
        listener: (context, state) {
          if (state is JourneyCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rencana berhasil dibuat!')),
            );
            Navigator.pop(context);
          }
          if (state is JourneyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildInfoBanner(),
              const SizedBox(height: 24),
              _buildCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('JOURNEY NAME'),
                    _buildTextField(
                      controller: _nameCtrl,
                      hint: 'e.g., Rifampicin & Isoniazid',
                      validator: true,
                    ),
                    const SizedBox(height: 16),
                    _buildFormLabel('CLINICAL NOTES (OPTIONAL)'),
                    _buildTextField(
                      controller: _notesCtrl,
                      hint: 'Special instructions...',
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Prescribed Doses',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton.icon(
                    onPressed: _addDose,
                    icon: Icon(Icons.add, color: _primaryColor, size: 18),
                    label: Text(
                      'Add Dose',
                      style: TextStyle(color: _primaryColor),
                    ),
                  ),
                ],
              ),
              ..._doses.asMap().entries.map((entry) {
                return _DoseFormCard(
                  index: entry.key,
                  data: entry.value,
                  onRemove: () => _removeDose(entry.key),
                  primaryColor: _primaryColor,
                );
              }),
              const SizedBox(height: 24),
              _buildDurationCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF67E5CE),
            child: Icon(Icons.info_outline, size: 16, color: _primaryColor),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consistency Matters',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 4),
                Text(
                  "Taking your medication at the exact same time every day prevents drug resistance. Let's set a schedule.",
                  style: TextStyle(
                    color: Colors.black54,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormLabel('START DATE'),
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: _buildTextField(
                controller: TextEditingController(
                  text: _formatDate(_startDate),
                ),
                hint: '',
                icon: Icons.calendar_today_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BlocBuilder<JourneyCubit, JourneyState>(
          builder: (context, state) {
            final loading = state is JourneyLoading;
            return ElevatedButton.icon(
              onPressed: loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: loading
                  ? const SizedBox.shrink()
                  : const Icon(Icons.save_outlined, color: Colors.white),
              label: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save Medication Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: child,
    );
  }

  Widget _buildFormLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool validator = false,
    int maxLines = 1,
    TextInputType? type,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      validator: validator
          ? (v) => v == null || v.trim().isEmpty ? 'Required' : null
          : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
}

class _DoseFormData {
  final nameCtrl = TextEditingController();
  final dosageCtrl = TextEditingController();
  final pillCtrl = TextEditingController();
  final instrCtrl = TextEditingController();
  String frequency = 'Once Daily';
}

class _DoseFormCard extends StatefulWidget {
  final int index;
  final _DoseFormData data;
  final VoidCallback onRemove;
  final Color primaryColor;

  const _DoseFormCard({
    required this.index,
    required this.data,
    required this.onRemove,
    required this.primaryColor,
  });

  @override
  State<_DoseFormCard> createState() => _DoseFormCardState();
}

class _DoseFormCardState extends State<_DoseFormCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              _buildFormLabel('DRUG NAME'),
              GestureDetector(
                onTap: widget.onRemove,
                child: const Icon(Icons.close, size: 18, color: Colors.red),
              ),
            ],
          ),
          _buildTextField(
            controller: widget.data.nameCtrl,
            hint: 'Rifampicin',
            icon: Icons.search,
            validator: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('DOSAGE (MG)'),
                    _buildTextField(
                      controller: widget.data.dosageCtrl,
                      hint: '600',
                      icon: Icons.science_outlined,
                      type: TextInputType.number,
                      validator: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('PILL COUNT'),
                    _buildTextField(
                      controller: widget.data.pillCtrl,
                      hint: '2',
                      icon: Icons.medication_outlined,
                      type: TextInputType.number,
                      validator: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormLabel('FREQUENCY'),
          Row(
            children: [
              Expanded(child: _buildSegmentButton('Once Daily')),
              const SizedBox(width: 12),
              Expanded(child: _buildSegmentButton('Twice Daily')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text) {
    bool isSelected = widget.data.frequency == text;
    return GestureDetector(
      onTap: () => setState(() => widget.data.frequency = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? widget.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? widget.primaryColor : Colors.grey[300]!,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool validator = false,
    TextInputType? type,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator
          ? (v) => v == null || v.trim().isEmpty ? 'Required' : null
          : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.primaryColor),
        ),
      ),
    );
  }
}
