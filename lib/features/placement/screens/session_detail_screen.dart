import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/placement/blocs/session/session_bloc.dart';
import 'package:markme_admin/features/placement/blocs/session/session_state.dart';
import 'package:markme_admin/features/placement/blocs/session/sesssion_event.dart';
import '../models/session/eligibility.dart';
import '../models/session/placement_session.dart';

class SessionDetailScreen extends StatefulWidget {
  final String collegeId;
  final String sessionId;

  const SessionDetailScreen({
    super.key,
    required this.sessionId,
    required this.collegeId,
  });

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _sessionNameController;
  late TextEditingController _companyNameController;
  late TextEditingController _roleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _driveTypeController;
  late TextEditingController _statusController;
  late TextEditingController _formIdController;
  late TextEditingController _collegeIdController;
  late TextEditingController _companyIdController;

  // Eligibility
  late TextEditingController _batchesController; // comma separated
  late TextEditingController _minCgpaController;
  late TextEditingController _maxBacklogsController;

  // Skills
  late TextEditingController _skillsController; // comma separated

  PlacementSession? _session;

  @override
  void initState() {
    super.initState();

    _sessionNameController = TextEditingController();
    _companyNameController = TextEditingController();
    _roleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _driveTypeController = TextEditingController();
    _statusController = TextEditingController();
    _formIdController = TextEditingController();
    _collegeIdController = TextEditingController(text: widget.collegeId);
    _companyIdController = TextEditingController();

    _batchesController = TextEditingController();
    _minCgpaController = TextEditingController();
    _maxBacklogsController = TextEditingController();

    _skillsController = TextEditingController();

    context.read<PlacementSessionBloc>().add(
      LoadSessionData(collegeId: widget.collegeId, sessionId: widget.sessionId),
    );
  }

  void _initControllersFromSession(PlacementSession session) {
    _sessionNameController.text = session.sessionName;
    _companyNameController.text = session.companyName;
    _roleController.text = session.role;
    _descriptionController.text = session.description;
    _locationController.text = session.location;
    _driveTypeController.text = session.driveType;
    _statusController.text = session.status;
    _formIdController.text = session.formId;
    _collegeIdController.text = session.collegeId;
    _companyIdController.text = session.companyId;

    _batchesController.text = session.eligibility.batches
        .join(', ')
        .toUpperCase();
    _minCgpaController.text = session.eligibility.minCgpa.toString();
    _maxBacklogsController.text = session.eligibility.maxBacklogs.toString();

    _skillsController.text = session.requiredSkills.join(', ');
  }

  @override
  void dispose() {
    _sessionNameController.dispose();
    _companyNameController.dispose();
    _roleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _driveTypeController.dispose();
    _statusController.dispose();
    _formIdController.dispose();
    _collegeIdController.dispose();
    _companyIdController.dispose();

    _batchesController.dispose();
    _minCgpaController.dispose();
    _maxBacklogsController.dispose();

    _skillsController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    if (_session == null) return;
    if (!_formKey.currentState!.validate()) return;

    final eligibility = Eligibility(
      batches: _batchesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      minCgpa: double.tryParse(_minCgpaController.text) ?? 0.0,
      maxBacklogs: int.tryParse(_maxBacklogsController.text) ?? 0,
    );

    final skills = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final updatedSession = _session!.copyWith(
      sessionName: _sessionNameController.text,
      companyName: _companyNameController.text,
      role: _roleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      driveType: _driveTypeController.text,
      status: _statusController.text.toLowerCase(),
      formId: _formIdController.text,
      collegeId: _collegeIdController.text,
      companyId: _companyIdController.text,
      eligibility: eligibility,
      requiredSkills: skills,
    );

    context.read<PlacementSessionBloc>().add(
      UpdatePlacementSession(updatedSession),
    );
    _toggleEditMode();
  }

  void _endSession() {
    final parentContext=context;
    if (_session == null) return;
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you sure you want to end this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _statusController.text = "ended";
              });
              parentContext.read<PlacementSessionBloc>().add(
                UpdatePlacementSession(
                  _session!.copyWith(
                    status: _statusController.text.toLowerCase(),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  void _deleteSession() {
    if (_session == null) return;
    final parentContext=context;
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: const Text(
          'Are you sure you want to delete this session? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              parentContext.read<PlacementSessionBloc>().add(
                DeletePlacementSession(_session!),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null
          ? Icon(icon, size: 20, color: Colors.grey.shade700)
          : null,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlacementSessionBloc, PlacementSessionState>(
      listener: (context, state) {
        if (state is PlacementSessionLoading) {
          AppUtils.showCustomLoading(context);
        } else {
          if (Navigator.canPop(context)) {
            context.pop();
          }
        }

        if (state is PlacementSessionUpdated) {
          context.pop();
          AppUtils.showCustomSnackBar(context, 'Placement session updated');
        } else if (state is PlacementSessionFailure) {
          AppUtils.showCustomSnackBar(context, state.message);
        } else if (state is PlacementSessionDeleted) {
          AppUtils.showCustomSnackBar(context, 'Placement session deleted');
          if (Navigator.canPop(context)) {
            context.pop();
          }
        } else if (state is LoadedSessionData) {
          setState(() {
            _session = state.session;
            _initControllersFromSession(_session!);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(_session?.sessionName ?? 'Session Detail'),
          backgroundColor: _getStatusColor(_session?.status ?? 'closed'),
          elevation: 0,
          actions: [
            if (_session != null && !_isEditing)
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _toggleEditMode();
                      break;
                    case 'end':
                      _endSession();
                      break;
                    case 'delete':
                      _deleteSession();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (_session!.status == 'live')
                    const PopupMenuItem(
                      value: 'end',
                      child: Text('End Session'),
                    ),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            if (_isEditing) ...[
              IconButton(icon: const Icon(Icons.save), onPressed: _saveChanges),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleEditMode,
              ),
            ],
          ],
        ),
        body: _session == null
            ? const Center(child: Text("Loading..."),)
            : Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    final fieldWidth = isWide
                        ? (constraints.maxWidth - 64) / 2
                        : constraints.maxWidth;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _StatusCard(session: _session!),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Session Details',
                            subtitle: 'Basic information',
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _sessionNameController,
                                    enabled: _isEditing,
                                    decoration: _inputDecoration(
                                      'Session Name',
                                      icon: Icons.event_note,
                                    ),
                                    validator: (v) => v == null || v.isEmpty
                                        ? 'Session name is required'
                                        : null,
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _companyNameController,
                                    enabled: _isEditing,
                                    decoration: _inputDecoration(
                                      'Company',
                                      icon: Icons.business,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _companyIdController,
                                    enabled: false,
                                    decoration: _inputDecoration(
                                      'Company ID',
                                      icon: Icons.confirmation_number,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _formIdController,
                                    enabled: false,
                                    decoration: _inputDecoration(
                                      'Form ID',
                                      icon: Icons.article_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Role & Drive',
                            subtitle: 'Position details',
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _roleController,
                                    enabled: _isEditing,
                                    decoration: _inputDecoration(
                                      'Role',
                                      icon: Icons.work_outline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _driveTypeController,
                                    enabled: _isEditing,
                                    decoration: _inputDecoration(
                                      'Drive Type',
                                      icon: Icons.directions_car,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _locationController,
                                    enabled: _isEditing,
                                    decoration: _inputDecoration(
                                      'Location',
                                      icon: Icons.location_on_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Description',
                            subtitle: 'Job overview',
                            child: TextFormField(
                              controller: _descriptionController,
                              enabled: _isEditing,
                              maxLines: 5,
                              decoration: _inputDecoration(
                                'Description',
                                icon: Icons.description_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Eligibility & Skills',
                            subtitle: 'Who can apply',
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _batchesController,
                                    enabled: _isEditing,
                                    decoration: _inputDecoration(
                                      'Batches (comma separated)',
                                      icon: Icons.people_outline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _minCgpaController,
                                    enabled: _isEditing,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: _inputDecoration(
                                      'Min CGPA',
                                      icon: Icons.school_outlined,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _maxBacklogsController,
                                    enabled: _isEditing,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration(
                                      'Max Backlogs',
                                      icon: Icons.rule_folder_outlined,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: _skillsController,
                                    enabled: _isEditing,
                                    decoration: _inputDecoration(
                                      'Required Skills (comma separated)',
                                      icon: Icons.star_outline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Meta',
                            subtitle: 'Status and tracking',
                            child: Column(
                              children: [
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 12,
                                  children: [
                                    SizedBox(
                                      width: fieldWidth,
                                      child: TextFormField(
                                        controller: _statusController,
                                        enabled: _isEditing,
                                        decoration: _inputDecoration(
                                          'Status (live/upcoming/closed)',
                                          icon: Icons.traffic_outlined,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: fieldWidth,
                                      child: TextFormField(
                                        controller: _collegeIdController,
                                        enabled: _isEditing,
                                        decoration: _inputDecoration(
                                          'College ID',
                                          icon: Icons.apartment_outlined,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ReadOnlyChip(
                                        label: 'Start',
                                        value: _formatDate(_session!.startDate),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _ReadOnlyChip(
                                        label: 'End',
                                        value: _formatDate(_session!.endDate),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _ReadOnlyChip(
                                        label: 'Created',
                                        value: _formatDate(_session!.createdAt),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final PlacementSession session;

  const _StatusCard({required this.session});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    if (session.status == 'live') {
      statusColor = Colors.green;
      statusText = 'LIVE';
    } else if (session.status == 'upcoming') {
      statusColor = Colors.orange;
      statusText = 'UPCOMING';
    } else {
      statusColor = Colors.grey;
      statusText = 'CLOSED';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.15),
            statusColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              session.status == 'live' ? Icons.circle : Icons.schedule,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.companyName} - ${session.role}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyChip extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'live':
      return Colors.green;
    case 'upcoming':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
