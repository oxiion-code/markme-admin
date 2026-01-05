import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/features/student_onboarding/models/student_verification_args.dart';
import '../../../../data/models/student.dart';

enum VerificationStatus { verified, failed, pending }

class StudentVerificationListScreen extends StatefulWidget {
  final List<Student> students;
  final String collegeId;

  const StudentVerificationListScreen({
    super.key,
    required this.students,
    required this.collegeId,
  });

  @override
  State<StudentVerificationListScreen> createState() =>
      _StudentVerificationListScreenState();
}

class _StudentVerificationListScreenState
    extends State<StudentVerificationListScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, VerificationStatus> verificationStatus = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students to Verify',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          _buildStatsChip(),
          const SizedBox(width: 16),
        ],
      ),
      body: widget.students.isEmpty
          ? _buildEmptyState(theme)
          : Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: widget.students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final student = widget.students[index];
                  return _StudentVerificationCard(
                    student: student,
                    status: verificationStatus[student.id] ?? VerificationStatus.pending,
                    collegeId: widget.collegeId,
                    onVerificationComplete: (result) {
                      setState(() {
                        verificationStatus[student.id] = result;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChip() {
    final verifiedCount = verificationStatus.values
        .where((status) => status == VerificationStatus.verified)
        .length;
    final total = widget.students.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 16, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            '$verifiedCount/$total verified',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: theme.colorScheme.onPrimaryContainer,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Process',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap START on each student card to begin verification',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.group_off_rounded,
              size: 60,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No students found',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No students available for this batch.\nPlease check your filters.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Filters'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentVerificationCard extends StatelessWidget {
  final Student student;
  final VerificationStatus status;
  final String collegeId;
  final Function(VerificationStatus) onVerificationComplete;

  const _StudentVerificationCard({
    required this.student,
    required this.status,
    required this.collegeId,
    required this.onVerificationComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        elevation: status != VerificationStatus.pending ? 0 : 2,
        color: _getCardColor(theme, status),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: _getBorderSide(theme, status),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Status Badge
              _StatusBadge(status: status),
              const SizedBox(width: 12),

              /// Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            student.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Regd: ${student.regdNo}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              /// Action Button
              _ActionButton(
                status: status,
                student: student,
                collegeId: collegeId,
                onVerificationComplete: onVerificationComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BorderSide _getBorderSide(ThemeData theme, VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return BorderSide(color: Colors.green, width: 2);
      case VerificationStatus.failed:
        return BorderSide(color: Colors.red, width: 2);
      case VerificationStatus.pending:
        return BorderSide(color: theme.colorScheme.outline.withOpacity(0.5));
    }
  }

  Color _getCardColor(ThemeData theme, VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green.withOpacity(0.08);
      case VerificationStatus.failed:
        return Colors.red.withOpacity(0.08);
      case VerificationStatus.pending:
        return theme.colorScheme.surface;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final VerificationStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData icon;
    Color color;

    switch (status) {
      case VerificationStatus.verified:
        icon = Icons.verified_rounded;
        color = Colors.green;
        break;
      case VerificationStatus.failed:
        icon = Icons.cancel_rounded;
        color = Colors.red;
        break;
      case VerificationStatus.pending:
        icon = Icons.schedule_rounded;
        color = theme.colorScheme.primary;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VerificationStatus status;
  final Student student;
  final String collegeId;
  final Function(VerificationStatus) onVerificationComplete;

  const _ActionButton({
    required this.status,
    required this.student,
    required this.collegeId,
    required this.onVerificationComplete,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case VerificationStatus.pending:
        return _StartVerificationButton(
          student: student,
          collegeId: collegeId,
          onVerificationComplete: onVerificationComplete,
        );
      case VerificationStatus.verified:
        return _StatusChip(
          label: 'VERIFIED',
          color: Colors.green,
          icon: Icons.check_circle_rounded,
        );
      case VerificationStatus.failed:
        return _StatusChip(
          label: 'FAILED',
          color: Colors.red,
          icon: Icons.error_rounded,
        );
    }
  }
}

class _StartVerificationButton extends StatelessWidget {
  final Student student;
  final String collegeId;
  final Function(VerificationStatus) onVerificationComplete;

  const _StartVerificationButton({
    required this.student,
    required this.collegeId,
    required this.onVerificationComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.play_arrow_rounded, size: 18),
      label: const Text('START', style: TextStyle(fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      onPressed: () async {
        final args = StudentVerificationArgs(
          collegeId: collegeId,
          student: student,
        );

        final result = await context.push(
          "/student-verification-details",
          extra: args,
        );

        if (result == "verified") {
          onVerificationComplete(VerificationStatus.verified);
        } else if (result == "failed") {
          onVerificationComplete(VerificationStatus.failed);
        }
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
