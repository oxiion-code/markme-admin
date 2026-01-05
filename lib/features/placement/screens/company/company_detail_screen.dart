import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/placement/models/company/company_details.dart';
import '../../blocs/company/company_bloc.dart';
import '../../blocs/company/company_event.dart';
import '../../blocs/company/company_state.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';

import '../../widgets/company/job_roles_chips.dart';
import '../../widgets/company/sessions_chips.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final Company company;
  final String collegeId;

  const CompanyDetailsScreen({
    super.key,
    required this.company,
    required this.collegeId,
  });

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  late String name;
  late String description;
  late String location;
  late List<String> jobRoles;
  late List<String> sessionIds;
  File? logoFile;

  final TextEditingController _sessionController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.company.name;
    description = widget.company.description;
    location = widget.company.location;
    jobRoles = List.from(widget.company.jobRoles);
    sessionIds = List.from(widget.company.sessionIds);
  }

  @override
  void dispose() {
    _sessionController.dispose();
    _jobRoleController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        logoFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.company.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                setState(() => _isEditing = true);
              },
            ),
          if (_isEditing)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.green),
                  onPressed: _onSave,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => setState(() => _isEditing = false),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: !_isEditing
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDeleteButton(),
            )
          : null,
      body: BlocListener<CompanyBloc, CompanyState>(
        listener: (context, state) {
          if (state is CompanyLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            context.pop();
          }
          if (state is CompanyUpdated) {
            AppUtils.showCustomSnackBar(
              context,
              "Company updated successfully!",
            );
            setState(() => _isEditing = false);
            context.pop("updated");
          } else if (state is CompanyDeleted) {
            AppUtils.showCustomSnackBar(
              context,
              "Company deleted successfully!",
            );
            context.pop("deleted");
          } else if (state is CompanyOperationFailure) {
            AppUtils.showCustomSnackBar(context, state.message, isError: true);
          }else if(state is FetchedCompanyData){
            final company = state.company;
            setState(() {
              name = company.name;
              description = company.description;
              location = company.location;
              jobRoles = List.from(company.jobRoles);
              sessionIds = List.from(company.sessionIds);
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildCard(
                  title: "Company Information",
                  children: [
                    _buildInfoRow(
                      Icons.business,
                      "Name",
                      _isEditing ? name : widget.company.name,
                      _isEditing
                          ? _buildTextField(
                              "Company Name",
                              Icons.business,
                              initialValue: name,
                              onChanged: (value) =>
                                  setState(() => name = value),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? "Required" : null,
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      Icons.location_on,
                      "Location",
                      _isEditing ? location : widget.company.location,
                      _isEditing
                          ? _buildTextField(
                              "Location",
                              Icons.location_on,
                              initialValue: location,
                              onChanged: (value) =>
                                  setState(() => location = value),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? "Required" : null,
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      Icons.description,
                      "Description",
                      _isEditing ? description : widget.company.description,
                      _isEditing
                          ? _buildTextField(
                              "Description",
                              Icons.description,
                              initialValue: description,
                              maxLines: 4,
                              onChanged: (value) =>
                                  setState(() => description = value),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? "Required" : null,
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Job Roles Card
                _buildCard(
                  title: "Job Roles",
                  children: [
                    JobRolesChips(
                      jobRoles: jobRoles,
                      isEditable: _isEditing,
                      controller: _jobRoleController,
                      onAdd: (role) {
                        setState(() => jobRoles.add(role));
                      },
                      onDelete: (index) {
                        setState(() => jobRoles.removeAt(index));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sessions Card
                _buildCard(
                  title: "Sessions",
                  children: [
                    SessionsChips(
                      sessionIds: sessionIds,
                      onTap:
                      (index,sessionId){
                        context.push(
                          '/placementSessionDetails',
                          extra: {
                            'collegeId': widget.collegeId,
                            'sessionId': sessionId,
                          },
                        ).then((_){
                          context.read<CompanyBloc>().add(
                            FetchCompanyData(
                              collegeId: widget.collegeId,
                              companyId:widget.company.companyId,
                            ),
                          );
                        });
                      }
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Delete Button (only in view mode)
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _isEditing
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                final companyDetails = CompanyDetails(
                  company: widget.company,
                  collegeId: widget.collegeId,
                );
                context
                    .push("/addPlacementSession", extra: companyDetails)
                    .then((_) {
                      context.read<CompanyBloc>().add(
                        FetchCompanyData(
                          collegeId: companyDetails.collegeId,
                          companyId: companyDetails.company.companyId,
                        ),
                      );
                    });
              },
              label: Text("Add session"),
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: _isEditing ? _pickLogo : null,
          child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                  image: DecorationImage(
                    image: logoFile != null
                        ? FileImage(logoFile!)
                        : widget.company.logoUrl.isNotEmpty
                        ? NetworkImage(widget.company.logoUrl)
                        : const AssetImage('assets/placeholder.png')
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // ✨ Edit Icon Overlay (ONLY in edit mode)
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing ? name : widget.company.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Created: ${widget.company.createdAt.split('T')[0]}",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                "${jobRoles.length} Job Role${jobRoles.length != 1 ? 's' : ''} • "
                "${sessionIds.length} Session${sessionIds.length != 1 ? 's' : ''}",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Widget? editWidget,
  ) {
    if (editWidget != null) return editWidget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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

  Widget _buildTextField(
    String label,
    IconData icon, {
    String? initialValue,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
  Widget _buildDeleteButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _showDeleteConfirmation,
        icon: const Icon(Icons.delete_outline, color: Colors.white),
        label: const Text(
          "Delete Company",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final company = Company(
        companyId: widget.company.companyId,
        name: name,
        description: description,
        location: location,
        jobRoles: jobRoles,
        sessionIds: sessionIds,
        logoUrl: widget.company.logoUrl,
        createdAt: widget.company.createdAt,
      );
      context.read<CompanyBloc>().add(
        UpdateCompany(
          collegeId: widget.collegeId,
          company: company,
          companyLogo: logoFile, // ✅ NEW
        ),
      );
    }
  }

  void _showDeleteConfirmation() {
    final parentContext = context;
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text("Delete Company"),
          ],
        ),
        content: Text(
          "Are you sure you want to delete ${widget.company.name}? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(parentContext);
              parentContext.read<CompanyBloc>().add(
                DeleteCompany(
                  collegeId: widget.collegeId,
                  company: widget.company, // Fixed: use companyId
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
