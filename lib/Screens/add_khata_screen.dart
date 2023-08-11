import 'package:doodh_app/Boxes/boxes.dart';
import 'package:doodh_app/Models/khata_model.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class AddKhataScreen extends StatefulWidget {
  const AddKhataScreen({super.key});

  @override
  State<AddKhataScreen> createState() => _AddKhataScreenState();
}

class _AddKhataScreenState extends State<AddKhataScreen> {
  DateTime? selectedDate;
  final priceController = TextEditingController();
  final DateFormat format = DateFormat('MMMM');

  @override
  void initState() {
    selectedDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Khata'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    showMonthPicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 5, 5),
                      lastDate: DateTime(DateTime.now().year + 8, 9),
                      initialDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          selectedDate = value;
                          debugPrint(selectedDate!.month.toString());
                        });
                      } else {
                        return null;
                      }
                    });
                  },
                  child: const Text(
                    'Pick Month',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  ":  ${format.format(selectedDate!)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(23),
                    borderSide: const BorderSide(width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(23),
                    borderSide: const BorderSide(width: 2),
                  ),
                  hintText: 'Enter PKR/Liter'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: height * 0.04),
            SizedBox(
              width: width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  final data = KhataModel(
                      date: selectedDate,
                      literPrice: double.parse(priceController.text),
                      entryModel: []);

                  // Box:
                  final box = Boxes.getKhataData();
                  box.add(data);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Khata Saved Successfully')));

                  Navigator.pop(context);
                },
                child: const Text("Add Khata"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
