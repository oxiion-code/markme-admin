import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import '../../blocs/company/company_bloc.dart';
import '../../blocs/company/company_event.dart';
import '../../blocs/company/company_state.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';

class AddCompanyScreen extends StatefulWidget {
  final String collegeId;
  const AddCompanyScreen({super.key, required this.collegeId});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  String name = '';
  String description = '';
  String location = '';
  List<String> jobRoles = [];
  File? logoFile;

  final TextEditingController jobRoleController = TextEditingController();

  @override
  void dispose() {
    jobRoleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Add Company",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: BlocListener<CompanyBloc, CompanyState>(
        listener: (context, state) {
          if (state is CompanyAdded) {
            AppUtils.showCustomSnackBar(context, "Company added successfully!");
            Navigator.pop(context);
          } else if (state is CompanyUpdated) {
            AppUtils.showCustomSnackBar(context, "Company updated successfully!");
            Navigator.pop(context);
          } else if (state is CompanyDeleted) {
            AppUtils.showCustomSnackBar(context, "Company deleted successfully!");
            Navigator.pop(context);
          } else if (state is CompanyOperationFailure) {
            AppUtils.showCustomSnackBar(context, state.message, isError: true);
          }
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildCard(
                  title: "Company Details",
                  children: [
                    _buildTextField("Company Name", Icons.business, true,
                        validator: (value) =>
                        value?.isEmpty ?? true ? "Company name is required" : null,
                        onSaved: (value) => name = value!.trim()),
                    const SizedBox(height: 20),
                    _buildTextField("Location", Icons.location_on, false,
                        maxLines: 1,
                        validator: (value) =>
                        value?.isEmpty ?? true ? "Location is required" : null,
                        onSaved: (value) => location = value!.trim()),
                    const SizedBox(height: 20),
                    _buildTextField("Description", Icons.description, false,
                        maxLines: 4,
                        validator: (value) =>
                        value?.isEmpty ?? true ? "Description is required" : null,
                        onSaved: (value) => description = value!.trim()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildCard(
                  title: "Job Roles",
                  children: [
                    _buildAddableField(
                      controller: jobRoleController,
                      label: "Add Job Role",
                      hint: "e.g., Software Engineer, Product Manager",
                      icon: Icons.work_outline,
                      onAdd: () {
                        if (jobRoleController.text.trim().isNotEmpty) {
                          setState(() {
                            jobRoles.add(jobRoleController.text.trim());
                            jobRoleController.text="";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (jobRoles.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: jobRoles
                              .asMap()
                              .entries
                              .map((entry) => _buildChip(
                            entry.value,
                            Icons.work,
                            Colors.blue,
                            onDelete: () => setState(() => jobRoles.removeAt(entry.key)),
                          ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildCard(
                  title: "Company Logo",
                  children: [
                    _buildLogoPicker(),
                  ],
                ),
                const SizedBox(height: 40),
                _buildSubmitButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[600]!, Colors.purple[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.business_center, color: Colors.white, size: 48),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add New Company",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Fill in the details to add a new company",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
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
            color: Colors.black.withOpacity(0.05),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.info_outline, size: 20, color: Colors.blue),
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

  Widget _buildTextField(
      String label,
      IconData icon,
      bool isDense, {
        int maxLines = 1,
        String? Function(String?)? validator,
        void Function(String?)? onSaved,
      }) {
    return TextFormField(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      validator: validator,
      onSaved: onSaved,
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
          child: TextFormField(
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text("Add"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, IconData icon, Color color, {VoidCallback? onDelete}) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: color),
      backgroundColor: color.withOpacity(0.1),
      deleteIcon: onDelete != null ? Icon(Icons.close, size: 16, color: Colors.grey[600]) : null,
      onDeleted: onDelete,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildLogoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: logoFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  logoFile!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              )
                  : const Icon(Icons.image, size: 30, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickLogo,
                icon: const Icon(Icons.photo_library_outlined, size: 20),
                label: Text(logoFile != null ? "Change Logo" : "Pick Logo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[50],
                  foregroundColor: Colors.indigo[700],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
        if (logoFile != null) ...[
          const SizedBox(height: 8),
          Text(
            "Logo selected: ${logoFile!.path.split('/').last}",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: Colors.green.withOpacity(0.3),
        ),
        child: BlocBuilder<CompanyBloc, CompanyState>(
          builder: (context, state) {
            if (state is CompanyLoading) {
              return const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text("Adding Company...", style: TextStyle(fontSize: 16)),
                ],
              );
            }
            return const Text(
              "Add Company",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickLogo() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          logoFile = File(picked.path);
        });
      }
    } catch (e) {
      AppUtils.showCustomSnackBar(context, "Failed to pick image", isError: true);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final company = Company(
        companyId: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        location: location,
        jobRoles: jobRoles,
        sessionIds: [], // Empty list since sessions are removed
        logoUrl: '',
        createdAt: DateTime.now().toIso8601String(),
      );
      context.read<CompanyBloc>().add(AddCompany(
        collegeId: widget.collegeId,
        company: company,
        companyLogo: logoFile,
      ));
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("How to add a company"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• Fill all required fields"),
            Text("• Add multiple job roles"),
            Text("• Upload a square logo (recommended)"),
            SizedBox(height: 8),
            Text("All fields are required for successful submission.",
                style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }
}
