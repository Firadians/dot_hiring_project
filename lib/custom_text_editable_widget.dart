import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class CustomTextEditableWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isEditing;

  CustomTextEditableWidget({
    required this.hintText,
    required this.controller,
    required this.isEditing,
  });

  @override
  _CustomTextEditableWidgetState createState() =>
      _CustomTextEditableWidgetState();
}

class _CustomTextEditableWidgetState extends State<CustomTextEditableWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextFormField(
        controller: widget.controller,
        readOnly: !widget.isEditing,
        style: TextStyle(fontSize: 14), // Set text size here
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(225, 67, 67, 67),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class CustomNumberEditableWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isEditing;

  CustomNumberEditableWidget({
    required this.hintText,
    required this.controller,
    required this.isEditing,
  });

  @override
  _CustomNumberEditableWidgetState createState() =>
      _CustomNumberEditableWidgetState();
}

class _CustomNumberEditableWidgetState
    extends State<CustomNumberEditableWidget> {
  final NumberFormat _currencyFormat = NumberFormat.simpleCurrency(
    locale: 'id_ID', // Locale for Indonesia
    name: '', // No currency name, just use the symbol
    decimalDigits: 0, // No decimal places
  );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatCurrency);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatCurrency);
    super.dispose();
  }

  void _formatCurrency() {
    final text = widget.controller.text;
    final cleanedText =
        text.replaceAll('Rp. ', '').replaceAll(RegExp(r'[^\d]'), '');
    final doubleValue = double.tryParse(cleanedText);

    if (doubleValue != null) {
      final formattedValue = 'Rp. ${_currencyFormat.format(doubleValue)}';
      if (text != formattedValue) {
        widget.controller.value = widget.controller.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextFormField(
        controller: widget.controller,
        readOnly: !widget.isEditing,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(fontSize: 14), // Set text size here
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(225, 67, 67, 67),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class CustomCategoryWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isEditing;
  final String leftIconPath;

  CustomCategoryWidget({
    required this.hintText,
    required this.controller,
    required this.isEditing,
    required this.leftIconPath,
  });

  @override
  _CustomCategoryWidgetState createState() => _CustomCategoryWidgetState();
}

class _CustomCategoryWidgetState extends State<CustomCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextFormField(
        controller: widget.controller,
        readOnly: !widget.isEditing,
        style: TextStyle(fontSize: 14), // Set text size here
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              widget.leftIconPath,
              color: Colors.yellow,
              fit: BoxFit.scaleDown,
            ),
          ),
          suffixIcon: SizedBox(
            width: 40,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 16,
                ),
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(225, 67, 67, 67),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class CustomDateWidget extends StatefulWidget {
  @override
  _CustomDateWidgetState createState() => _CustomDateWidgetState();
}

class _CustomDateWidgetState extends State<CustomDateWidget> {
  DateTime? selectedDate;
  final DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedDate == null
                      ? 'Tanggal Pengeluaran'
                      : formatter.format(selectedDate!),
                  style: TextStyle(
                    color: selectedDate == null ? Colors.grey : Colors.black,
                    fontSize: 14, // Set text size here
                  ),
                ),
              ),
              Icon(Icons.calendar_month_outlined, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
