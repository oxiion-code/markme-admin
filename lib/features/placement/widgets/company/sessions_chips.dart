import 'package:flutter/material.dart';
import 'empty_state.dart';

class SessionsChips extends StatelessWidget {
  final List<String> sessionIds;
  final void Function(int index, String sessionId)? onTap;

  const SessionsChips({
    super.key,
    required this.sessionIds,
    this.onTap,
  });

  DateTime _parseSessionDate(String sessionId) {
    final microseconds = int.parse(sessionId);

    return DateTime.fromMicrosecondsSinceEpoch(
      microseconds,
      isUtc: true,
    ).toLocal();
  }
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} /"
        "${date.month.toString().padLeft(2, '0')} /"
        "${date.year}:";
  }

  @override
  Widget build(BuildContext context) {
    if (sessionIds.isEmpty) {
      return const EmptyState(
        icon: Icons.event,
        label: "No sessions added",
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: sessionIds.asMap().entries.map((entry) {
          final index = entry.key;
          final sessionId = entry.value;
          final date = _parseSessionDate(sessionId);

          return ActionChip(
            avatar: const Icon(
              Icons.event,
              size: 16,
              color: Colors.green,
            ),
            backgroundColor: Colors.green.withOpacity(0.12),
            label: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Session ${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            onPressed: onTap != null
                ? () => onTap!(index, sessionId)
                : null,
          );
        }).toList(),
      ),
    );
  }
}
