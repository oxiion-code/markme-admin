import 'package:flutter/material.dart';

class ScheduleSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDate;
  final ValueChanged<DateTime> onEndDate;

  const ScheduleSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDate,
    required this.onEndDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _picker(context, 'Start Date', startDate, onStartDate),
            const SizedBox(height: 8),
            _picker(context, 'End Date', endDate, onEndDate),
          ],
        ),
      ),
    );
  }

  Widget _picker(
      BuildContext context,
      String label,
      DateTime? value,
      ValueChanged<DateTime> onPick,
      ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2035),
          initialDate: value ?? DateTime.now(),
        );
        if (date != null) onPick(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(value?.toString().split(' ')[0] ?? 'Select date'),
      ),
    );
  }
}
