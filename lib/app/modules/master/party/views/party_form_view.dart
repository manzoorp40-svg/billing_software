import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../widgets/form/form_section.dart';
import '../controllers/party_form_controller.dart';

class PartyFormView extends GetView<PartyFormController> {
  const PartyFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) {
          controller.onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Obx(() => Text(
            controller.isEditMode.value ? 'Edit Party' : 'New Party',
          )),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          actions: [
            Obx(() => controller.isSaving.value
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : TextButton.icon(
              onPressed: controller.saveParty,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            )),
          ],
        ),
        body: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Information
                FormSection(
                  title: 'Basic Information',
                  children: [
                    // Party Type
                    Obx(() => DropdownButtonFormField<PartyType>(
                      value: controller.selectedPartyType.value,
                      decoration: const InputDecoration(
                        labelText: 'Party Type *',
                        border: OutlineInputBorder(),
                      ),
                      items: PartyType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setPartyType(value);
                        }
                      },
                    )),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: controller.validateName,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Contact Information
                FormSection(
                  title: 'Contact Information',
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: controller.validatePhone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: controller.alternatePhoneController,
                            decoration: const InputDecoration(
                              labelText: 'Alternate Phone',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone_android),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: controller.addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // GST & Tax Information
                FormSection(
                  title: 'Tax Information',
                  children: [
                    TextFormField(
                      controller: controller.gstinController,
                      decoration: const InputDecoration(
                        labelText: 'GSTIN',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business_outlined),
                        helperText: '15-character GST Identification Number',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                        LengthLimitingTextInputFormatter(15),
                      ],
                      validator: controller.validateGstin,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Opening Balance
                FormSection(
                  title: 'Opening Balance',
                  children: [
                    Row(
                      children: [
                        // Balance Type
                        Obx(() => SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(
                              value: 0,
                              label: Text('Receivable'),
                              icon: Icon(Icons.arrow_downward),
                            ),
                            ButtonSegment(
                              value: 1,
                              label: Text('Payable'),
                              icon: Icon(Icons.arrow_upward),
                            ),
                          ],
                          selected: {controller.balanceType.value},
                          onSelectionChanged: (value) {
                            controller.setBalanceType(value.first);
                          },
                        )),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: controller.openingBalanceController,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.currency_rupee),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: controller.validateOpeningBalance,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Notes
                FormSection(
                  title: 'Notes',
                  children: [
                    TextFormField(
                      controller: controller.notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    Obx(() => ElevatedButton(
                      onPressed: controller.isSaving.value ? null : controller.saveParty,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text(controller.isEditMode.value ? 'Update Party' : 'Create Party'),
                    )),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}