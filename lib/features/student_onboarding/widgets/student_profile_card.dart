import 'package:flutter/material.dart';

import '../../../data/models/student.dart';

class StudentProfileCard extends StatelessWidget {
  final Student student;

  const StudentProfileCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// PROFILE IMAGE + STATUS DOT
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: student.profilePhotoUrl.isNotEmpty
                      ? NetworkImage(student.profilePhotoUrl)
                      : null,
                  child: student.profilePhotoUrl.isEmpty
                      ? Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: theme.colorScheme.primary,
                  )
                      : null,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.onPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// NAME + BASIC INFO
            Column(
              children: [
                Text(
                  student.name,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.badge_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Roll: ${student.rollNo} • Regd: ${student.regdNo}',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        student.email,
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// QUICK TAGS
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                if (student.branchId.isNotEmpty)
                  _TagChip(
                    icon: Icons.account_tree_rounded,
                    label: student.branchId,
                  ),
                if (student.courseId.isNotEmpty)
                  _TagChip(
                    icon: Icons.school_rounded,
                    label: student.courseId,
                  ),
                if (student.batchId.isNotEmpty)
                  _TagChip(
                    icon: Icons.group_rounded,
                    label: 'Batch ${student.batchId}',
                  ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(height: 1),

            const SizedBox(height: 20),

            /// FAMILY DETAILS
            _SectionHeader(
              icon: Icons.family_restroom_rounded,
              title: 'Family Details',
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Father',
              value: student.fatherName,
              icon: Icons.male_rounded,
            ),
            _InfoRow(
              label: 'Mother',
              value: student.motherName,
              icon: Icons.female_rounded,
            ),
            _InfoRow(
              label: 'Student Mobile',
              value: student.studentMobileNo,
              icon: Icons.phone_android_rounded,
            ),
            _InfoRow(
              label: 'Father Mobile',
              value: student.fatherMobileNo,
              icon: Icons.phone_rounded,
            ),
            _InfoRow(
              label: 'Mother Mobile',
              value: student.motherMobileNo,
              icon: Icons.phone_rounded,
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),

            /// PERSONAL DETAILS
            _SectionHeader(
              icon: Icons.person_outline_rounded,
              title: 'Personal Details',
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Date of Birth',
              value: student.dob,
              icon: Icons.cake_rounded,
            ),
            _InfoRow(
              label: 'Gender',
              value: student.sex,
              icon: Icons.people_alt_rounded,
            ),
            _InfoRow(
              label: 'Category',
              value: student.category,
              icon: Icons.category_rounded,
            ),
            _InfoRow(
              label: 'Admission Date',
              value: student.admissionDate,
              icon: Icons.calendar_month_rounded,
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),

            /// ADDRESS DETAILS
            _SectionHeader(
              icon: Icons.location_on_rounded,
              title: 'Address',
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'Residential',
              value: _formatNormalAddress(student.normalAddress),
              maxLines: 3,
              icon: Icons.home_rounded,
            ),
            if (_hasHostelAddress(student.hostelAddress)) ...[
              const SizedBox(height: 12),
              _InfoRow(
                label: 'Hostel',
                value: _formatHostelAddress(student.hostelAddress),
                maxLines: 3,
                icon: Icons.meeting_room_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  bool _hasHostelAddress(HostelAddress address) {
    return address.hostel.isNotEmpty ||
        address.block.isNotEmpty ||
        address.roomNo.isNotEmpty;
  }

  String _formatHostelAddress(HostelAddress address) {
    return [
      address.hostel,
      address.block,
      address.roomNo.isNotEmpty ? 'Room ${address.roomNo}' : '',
    ].where((e) => e.isNotEmpty).join(', ');
  }

  String _formatNormalAddress(NormalAddress address) {
    return [
      address.atPo,
      address.cityVillage,
      address.dist,
      address.state,
      address.pin,
    ].where((e) => e.isNotEmpty).join(', ');
  }
}

/// ---------------- SECTION HEADER ----------------
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 22,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// ---------------- TAG CHIP ----------------
class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TagChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      visualDensity: VisualDensity.compact,
      avatar: Icon(
        icon,
        size: 16,
        color: theme.colorScheme.primary,
      ),
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      backgroundColor: theme.colorScheme.surfaceVariant,
      side: BorderSide(
        color: theme.colorScheme.outlineVariant,
      ),
    );
  }
}

/// ---------------- REUSABLE INFO ROW ----------------
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final int maxLines;
  final IconData? icon;

  const _InfoRow({
    required this.label,
    required this.value,
    this.maxLines = 1,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: RichText(
              maxLines: maxLines,
              text: TextSpan(
                text: '$label: ',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
