import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/placement/models/company/company_details.dart';
import '../blocs/company/company_bloc.dart';
import '../blocs/company/company_event.dart';
import '../blocs/company/company_state.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';

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
    final XFile? picked =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

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
          if(state is CompanyLoading){
            AppUtils.showCustomLoading(context);
          }else{
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
                        onChanged: (value) => setState(() => name = value),
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
                        onChanged: (value) => setState(() => location = value),
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
                        onChanged: (value) => setState(() => description = value),
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
                    if (_isEditing)
                      Column(
                        children: [
                          _buildAddableField(
                            controller: _jobRoleController,
                            label: "Add Job Role",
                            hint: "e.g., Software Engineer",
                            icon: Icons.work_outline,
                            onAdd: () {
                              if (_jobRoleController.text.trim().isNotEmpty) {
                                setState(() {
                                  jobRoles.add(_jobRoleController.text.trim());
                                  _jobRoleController.clear();
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    _buildEditableChipsList(
                      items: jobRoles,
                      icon: Icons.work,
                      color: Colors.blue,
                      isEditable: _isEditing,
                      onAdd: _isEditing
                          ? () => _jobRoleController.text.trim().isNotEmpty
                          ? _buildAddableField(
                        controller: _jobRoleController,
                        label: "Add Job Role",
                        hint: "e.g., Software Engineer",
                        icon: Icons.work_outline,
                        onAdd: () {
                          if (_jobRoleController.text.trim().isNotEmpty) {
                            setState(() {
                              jobRoles.add(_jobRoleController.text.trim());
                              _jobRoleController.clear();
                            });
                          }
                        },
                      )
                          : null
                          : null,
                      onDelete: _isEditing
                          ? (index) => setState(() => jobRoles.removeAt(index))
                          : null,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Sessions Card
                _buildCard(
                  title: "Sessions",
                  children: [
                    _buildEditableChipsList(
                      items: sessionIds,
                      icon: Icons.event,
                      color: Colors.green,
                      isEditable: false,
                      onDelete: _isEditing
                          ? (index) => setState(() => sessionIds.removeAt(index))
                          : null,
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
          final companyDetails= CompanyDetails(company: widget.company, collegeId: widget.collegeId);
          context.push("/addPlacementSession",extra:companyDetails );
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
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

  Widget _buildAddableField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required VoidCallback onAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
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
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed:onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text("Add"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableChipsList({
    required List<String> items,
    required IconData icon,
    required Color color,
    required bool isEditable,
    VoidCallback? onAdd,
    void Function(int)? onDelete,
  }) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              "No ${color == Colors.blue ? 'job roles' : 'sessions'} added",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (isEditable) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 16),
                label: Text("Add ${color == Colors.blue ? 'Job Role' : 'Session'}"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items
            .asMap()
            .entries
            .map(
              (entry) => Chip(
            label: Text(entry.value),
            avatar: Icon(icon, size: 16, color: color),
            backgroundColor: color.withValues(alpha: 0.1),
            deleteIcon: isEditable
                ? Icon(Icons.close, size: 16, color: Colors.grey[600])
                : null,
            onDeleted: isEditable ? () => onDelete!(entry.key) : null,
          ),
        )
            .toList(),
      ),
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
    final parentContext= context;
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
                  company:widget.company, // Fixed: use companyId
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
