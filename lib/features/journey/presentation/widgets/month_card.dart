import 'package:flutter/material.dart';

class MonthCard extends StatefulWidget {
  final String monthTitle;
  final List<int> takenDays;

  const MonthCard({
    super.key,
    required this.monthTitle,
    required this.takenDays,
  });

  @override
  State<MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<MonthCard> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isCollapsed = !_isCollapsed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.monthTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  _isCollapsed
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.grey[400],
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedCrossFade(
              firstChild: _buildCalendarGrid(isFullMonth: true),
              secondChild: _buildCalendarGrid(isFullMonth: false),
              crossFadeState: _isCollapsed
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid({required bool isFullMonth}) {
    const List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final List<int> allDays = List.generate(31, (index) => index + 1);
    final List<int> displayDays = isFullMonth ? allDays : allDays.sublist(0, 7);

    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          children: weekDays
              .map(
                (day) => Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            int day = displayDays[index];
            bool isTaken = widget.takenDays.contains(day);

            return Column(
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isTaken ? Colors.black87 : Colors.grey[400],
                    fontWeight: isTaken ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isTaken
                        ? const Color(0xFF005B4F)
                        : Colors.transparent,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
