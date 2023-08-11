import 'package:doodh_app/Boxes/boxes.dart';
import 'package:doodh_app/Models/entry_model.dart';
import 'package:doodh_app/Models/khata_model.dart';
import 'package:doodh_app/Routes%20Service/route_name.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
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
          final entries = <EntryModel>[];
          final DateTime khataDate = widget.date[
              'date']; // Must convert it back to DateTime before comparison

          for (final khataModel in khataModels) {
            if (khataModel.date!.month == khataDate.month) {
              entries.addAll(khataModel.entryModel);
            }
          }

          if (entries.isNotEmpty) {
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];

                // return ListTile(
                //   title: Text(entry.date.toString()),
                // );
                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  height: height * 0.09,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.shade200.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(23)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Day: ${dayFormat.format(khataDate)}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Liters: ${entry.quantity}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No Data'),
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
}

 



                // return ListView.builder(
          //   itemCount: box.length,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text(
          //           "${monthFormat.format(data[index].month!)} / ${yearFormat.format(data[index].month!)}"),
          //       subtitle: Text(data[index].literPrice.toString()),
          //     );
          //   },
          // );
