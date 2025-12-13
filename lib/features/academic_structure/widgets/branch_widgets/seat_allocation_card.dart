import 'package:flutter/material.dart';
import 'package:markme_admin/features/academic_structure/models/branch_seat_allocation.dart';

class SeatAllocationCard extends StatelessWidget {
  final BranchSeatAllocation seat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SeatAllocationCard({
    super.key,
    required this.seat,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getSeatStatusColor() {
    final percentage = seat.totalSeats > 0
        ? (seat.availableSeats / seat.totalSeats) * 100
        : 0;

    if (percentage >= 80) return Colors.green.shade400;
    if (percentage >= 50) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final seatPercentage = seat.totalSeats > 0
        ? (seat.availableSeats / seat.totalSeats) * 100
        : 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      seat.courseId.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeatStatusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${seatPercentage.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Year and seat info row
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.calendar_today,
                    label: 'Year ${seat.year}',
                    color: Colors.blue.shade100,
                  ),
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.event_seat,
                    label: '${seat.availableSeats}/${seat.totalSeats}',
                    color: Colors.green.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Seats',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: seat.totalSeats > 0
                        ? seat.availableSeats / seat.totalSeats
                        : 0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_getSeatStatusColor()),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${seat.availableSeats} available',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${seat.totalSeats - seat.availableSeats} taken',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action buttons with improved styling
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionButton(
                    icon: Icons.edit_outlined,
                    color: Colors.blue,
                    label: 'Edit',
                    onPressed: onEdit,
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    label: 'Delete',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
