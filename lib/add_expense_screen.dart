import 'package:flutter/material.dart';
import 'package:dot_project_app/custom_text_editable_widget.dart';

class AddExpenseScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();

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
              Icons.arrow_back_ios_new_rounded), // Add the back arrow icon here
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Ensure the Scaffold resizes when the keyboard is shown
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
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
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 10, 151, 176)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0), // Added horizontal padding
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
