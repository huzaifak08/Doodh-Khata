import 'package:doodh_app/Boxes/boxes.dart';
import 'package:doodh_app/Models/entry_model.dart';
import 'package:doodh_app/Provider/khataKey_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Constants/consts.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  // DateTime? selectedDate;
  DateTime? newDate;
  final DateFormat dateFormat = DateFormat("d/MMMM/yyyy");

  double dropDownValue = quantityList.first;

  @override
  void initState() {
    newDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final khataKeyProvider = Provider.of<KhatakeyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Entry'),
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
                    // showDatePicker(
                    //   context: context,
                    //   firstDate: DateTime(DateTime.now().year - 5, 5),
                    //   lastDate: DateTime(DateTime.now().year + 8, 9),
                    //   initialDate: DateTime.now(),
                    // ).then((value) {
                    //   if (value != null) {
                    //     setState(() {
                    //       selectedDate = value;
                    //     });
                    //   } else {
                    //     return null;
                    //   }
                    // });

                    _selectDate(context);
                  },
                  child: const Text(
                    'Pick Date',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  " ${dateFormat.format(newDate!)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity/Liter'),
                DropdownButton(
                  borderRadius: BorderRadius.circular(23),
                  value: dropDownValue,
                  items: quantityList.map<DropdownMenuItem<double>>((val) {
                    return DropdownMenuItem<double>(
                      value: val,
                      child: Text(val.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropDownValue = value!;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: height * 0.04),
            SizedBox(
              width: width * 0.5,
              child: ElevatedButton(
                onPressed: () async {
                  final box = Boxes.getKhataData();
                  final existingKhataKey = khataKeyProvider.khataKey;

                  final existingKhataModel = box.get(existingKhataKey);

                  if (existingKhataModel != null) {
                    final entryModel = EntryModel(
                      date: newDate,
                      quantity: dropDownValue,
                      entryPrice:
                          (dropDownValue * existingKhataModel.literPrice!),
                      khataKey: existingKhataModel.khataKey,
                    );

                    existingKhataModel.entryModel.add(entryModel);

                    existingKhataModel.save();

                    debugPrint("Existing Key ${existingKhataModel.khataKey}");
                    debugPrint("Entry Model Date ${entryModel.date}");
                    debugPrint("Entry Model Quantity ${entryModel.quantity}");
                    debugPrint("Entry Model Price ${entryModel.entryPrice}");

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Entry Saved Successfully')));

                    Navigator.pop(context);
                  } else {
                    print('KhataModel not found in the box');
                  }
                },
                child: const Text("Add Entry"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstSelectedDate =
        DateTime(currentDate.year, currentDate.month, 1);
    final DateTime lastSelectedDate =
        DateTime(currentDate.year, currentDate.month + 1, 0);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstSelectedDate,
      lastDate: lastSelectedDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null && picked != newDate) {
      setState(() {
        newDate = picked;
      });
    }
  }
}
