import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 60),
                      const Text(
                        "Údaje o uživateli",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(viewModel.userNameController, 'Zadejte vaše jméno'),
                      const SizedBox(height: 8),
                      _buildTextField(viewModel.userPhoneNumberController, 'Zadejte telefonní číslo', isPhone: true),
                      TextButton(
                        onPressed: viewModel.showBonusCardSettings,
                        child: Text(
                          viewModel.isCardNumberEmpty ? "+ Přidat zákaznickou kartu" : "+ Upravit zákaznickou kartu",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Visibility(visible: !isKeyboard, child: const Spacer()),
                      Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 22),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: MaterialButton(
                          height: 50,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            viewModel.saveUserData();
                          },
                          child: const Text(
                            "Uložit",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPhone = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 14,
              offset: const Offset(0, 1.1)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: TextField(
          controller: controller,
          maxLength: isPhone ? 18 : null,
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            counterText: "",
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            labelText: label,
          ),
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) => SettingsViewModel();
}
