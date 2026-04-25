import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/scheme.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../core/utils/pdf_generator.dart';

class FormFillScreen extends StatefulWidget {
  final Map<String, dynamic>? schemeData;

  const FormFillScreen({super.key, this.schemeData});

  @override
  State<FormFillScreen> createState() => _FormFillScreenState();
}

class _FormFillScreenState extends State<FormFillScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _documentUploaded = {};
  
  late Scheme _scheme;
  bool _isGeneratingPDF = false;

  @override
  void initState() {
    super.initState();
    if (widget.schemeData != null) {
      final schemeJson = widget.schemeData!['scheme'] as Map<String, dynamic>;
      _scheme = Scheme.fromJson(schemeJson);
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    // Initialize controllers for common fields
    _controllers['applicant_name'] = TextEditingController();
    _controllers['father_name'] = TextEditingController();
    _controllers['dob'] = TextEditingController();
    _controllers['gender'] = TextEditingController();
    _controllers['address'] = TextEditingController();
    _controllers['mobile'] = TextEditingController();
    _controllers['aadhar'] = TextEditingController();
    _controllers['bank_account'] = TextEditingController();
    _controllers['ifsc'] = TextEditingController();

    // Initialize document upload status
    for (var doc in _scheme.requiredDocuments) {
      _documentUploaded[doc] = false;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleDocumentUpload(String document) {
    setState(() {
      _documentUploaded[document] = true;
    });
  }

  Future<void> _generateAndDownloadPDF() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isGeneratingPDF = true;
    });

    try {
      // Collect form data
      final formData = <String, String>{};
      _controllers.forEach((key, controller) {
        formData[key] = controller.text;
      });

      // Generate PDF
      final pdf = await PDFGenerator.generateApplicationForm(
        schemeName: _scheme.name,
        formData: formData,
        documents: _scheme.requiredDocuments,
      );

      // Show print/share dialog
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: '${_scheme.name}_application.pdf',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF generated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPDF = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Application Form'),
        elevation: 0,
      ),
      body: widget.schemeData == null
          ? const Center(child: Text('No scheme data'))
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scheme Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _scheme.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  'Fill the form below to apply',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 24),

                    // Personal Details Section
                    _buildSectionHeader('Personal Details').animate().fadeIn(delay: 100.ms, duration: 400.ms),
                    const SizedBox(height: 16),
                    _buildTextField('Applicant Name', 'applicant_name', required: true).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                    const SizedBox(height: 12),
                    _buildTextField('Father/Husband Name', 'father_name', required: true).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                    const SizedBox(height: 12),
                    _buildTextField('Date of Birth', 'dob', required: true, hintText: 'DD/MM/YYYY').animate().fadeIn(delay: 250.ms, duration: 400.ms),
                    const SizedBox(height: 12),
                    _buildDropdown('Gender', 'gender', ['Male', 'Female', 'Other']).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                    const SizedBox(height: 24),

                    // Contact Details Section
                    _buildSectionHeader('Contact Details').animate().fadeIn(delay: 350.ms, duration: 400.ms),
                    const SizedBox(height: 16),
                    _buildTextField('Address', 'address', required: true, maxLines: 3).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                    const SizedBox(height: 12),
                    _buildTextField('Mobile Number', 'mobile', required: true, keyboardType: TextInputType.phone).animate().fadeIn(delay: 450.ms, duration: 400.ms),

                    const SizedBox(height: 24),

                    // Identity Documents Section
                    _buildSectionHeader('Identity Documents').animate().fadeIn(delay: 500.ms, duration: 400.ms),
                    const SizedBox(height: 16),
                    _buildTextField('Aadhar Number', 'aadhar', required: true, keyboardType: TextInputType.number, maxLength: 12).animate().fadeIn(delay: 550.ms, duration: 400.ms),
                    const SizedBox(height: 12),
                    _buildTextField('Bank Account Number', 'bank_account', required: true, keyboardType: TextInputType.number).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                    const SizedBox(height: 12),
                    _buildTextField('IFSC Code', 'ifsc', required: true, textCaps: TextCapitalization.characters).animate().fadeIn(delay: 650.ms, duration: 400.ms),

                    const SizedBox(height: 24),

                    // Document Upload Section
                    _buildSectionHeader('Upload Documents').animate().fadeIn(delay: 700.ms, duration: 400.ms),
                    const SizedBox(height: 16),
                    ..._scheme.requiredDocuments.map((doc) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDocumentUploadCard(doc),
                        )).animate().fadeIn(delay: 750.ms, duration: 400.ms),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isGeneratingPDF ? null : _generateAndDownloadPDF,
                        child: _isGeneratingPDF
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Generate & Download Form'),
                      ),
                    ).animate().fadeIn(delay: 800.ms, duration: 400.ms),

                    const SizedBox(height: 16),

                    // Instructions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Instructions',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '1. Fill all required fields marked with *\n'
                            '2. Download the generated PDF\n'
                            '3. Visit ${_scheme.applicationOffice}\n'
                            '4. Submit the form with required documents',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 850.ms, duration: 400.ms),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String key, {
    bool required = false,
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    int? maxLength,
    TextCapitalization textCaps = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: _controllers[key],
      maxLines: maxLines,
      keyboardType: keyboardType,
      maxLength: maxLength,
      textCapitalization: textCaps,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(String label, String key, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: '$label *',
        border: const OutlineInputBorder(),
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        _controllers[key].text = value ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  Widget _buildDocumentUploadCard(String document) {
    final isUploaded = _documentUploaded[document] ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded ? AppColors.accentGreen : AppColors.border,
          width: isUploaded ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isUploaded ? Icons.check_circle : Icons.cloud_upload_outlined,
            color: isUploaded ? AppColors.accentGreen : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isUploaded)
                  Text(
                    'Tap to upload',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (!isUploaded)
            ElevatedButton(
              onPressed: () => _handleDocumentUpload(document),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Upload'),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Uploaded',
                style: TextStyle(
                  color: AppColors.accentGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
