import 'package:doodh_app/Boxes/boxes.dart';
import 'package:doodh_app/Models/entry_model.dart';
import 'package:doodh_app/Models/khata_model.dart';
import 'package:doodh_app/Routes%20Service/route_name.dart';
import 'package:doodh_app/Widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class EntryScreen extends StatefulWidget {
  final dynamic date;
  const EntryScreen({super.key, required this.date});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final DateFormat dayFormat = DateFormat('d');
  final DateFormat monthFormat = DateFormat('MMMM');
  final DateFormat yearFormat = DateFormat('yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${monthFormat.format(widget.date['date'])}/${yearFormat.format(widget.date['date'])}'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<KhataModel>>(
        valueListenable: Boxes.getKhataData().listenable(),
        builder: (context, box, child) {
          final khataModels = box.values.toList().cast<KhataModel>();
          final entryList = <EntryModel>[];
          final DateTime khataDate = widget.date[
              'date']; // Must convert it back to DateTime before comparison

          for (final khataModel in khataModels) {
            if (khataModel.date!.month == khataDate.month) {
              entryList.addAll(khataModel.entryModel);
            }
          }

          if (entryList.isNotEmpty) {
            return ListView.builder(
              itemCount: entryList.length,
              itemBuilder: (context, index) {
                final entry = entryList[index];

                return InkWell(
                  // Delete Entry:

                  onTap: () {
                    deleteDialog(
                      context: context,
                      kOrE: 'Entry',
                      onPressed: () {
                        _deleteEntry(entry);

                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.01),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.01),
                    height: height * 0.1,
                    decoration: BoxDecoration(
                        color:
                            Colors.deepPurpleAccent.shade200.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(23)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Day: ${dayFormat.format(entry.date!)}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kilo: ${entry.quantity}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "PKR: ${entry.entryPrice}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Empty Khata'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.addEntryScreen);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Delete Entry:
  void _deleteEntry(EntryModel entry) async {
    final box = Boxes.getKhataData();

    final DateTime khataDate = widget
        .date['date']; // Must convert it back to DateTime before comparison

    final specificKhataModel = box.values.firstWhere(
      (khata) => khata.date!.month == khataDate.month,
    );

    specificKhataModel.entryModel.remove(entry);
    specificKhataModel.save();

    // Refresh the UI after deletion
    setState(() {});
  }
}
