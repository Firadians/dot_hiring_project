import 'package:flutter/material.dart';
import 'package:dot_project_app/custom_text_editable_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();

  // ValueNotifier to manage button color state
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers to update button state
    nameController.addListener(_updateButtonState);
    categoryController.addListener(_updateButtonState);
    currencyController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    nameController.removeListener(_updateButtonState);
    categoryController.removeListener(_updateButtonState);
    currencyController.removeListener(_updateButtonState);
    nameController.dispose();
    categoryController.dispose();
    currencyController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isFormFilled =
        nameController.text.isNotEmpty && currencyController.text.isNotEmpty;
    _isButtonEnabled.value = isFormFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah pengeluaran baru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextEditableWidget(
                  controller: nameController,
                  hintText: 'Nama Pengeluaran',
                  isEditing: true,
                ),
                CustomCategoryWidget(
                  hintText: 'Makanan',
                  controller: categoryController,
                  isEditing: false,
                  leftIconPath: 'assets/pizza_vector.svg',
                ),
                CustomDateWidget(),
                CustomNumberEditableWidget(
                  controller: currencyController,
                  hintText: 'Nominal',
                  isEditing: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isButtonEnabled,
                      builder: (context, isEnabled, child) {
                        return ElevatedButton(
                          onPressed: isEnabled
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle the form submission
                                  }
                                }
                              : null,
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                isEnabled
                                    ? Colors
                                        .blue // Update with your desired color
                                    : Colors.grey),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
