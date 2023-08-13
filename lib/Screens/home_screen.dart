import 'package:doodh_app/Boxes/boxes.dart';
import 'package:doodh_app/Models/khata_model.dart';
import 'package:doodh_app/Routes%20Service/route_name.dart';
import 'package:doodh_app/Widgets/dialog_widget.dart';
import 'package:doodh_app/Widgets/other_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateFormat monthFormat = DateFormat('MMMM');
  final DateFormat yearFormat = DateFormat('yyyy');

  final priceController = TextEditingController();

  Map<int, double> monthTotalMap = {};

  void calculateMonthTotals(List<KhataModel> khataList) {
    monthTotalMap.clear();

    for (final khataModel in khataList) {
      final month = khataModel.date!.month;
      final entryModels = khataModel.entryModel;

      double total = 0;

      for (final entryModel in entryModels) {
        total += entryModel.entryPrice ?? 0;
      }

      monthTotalMap[month] = total;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doodh Khata'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<KhataModel>>(
        valueListenable: Boxes.getKhataData().listenable(),
        builder: (context, box, child) {
          final data = box.values.toList().cast<KhataModel>();

          // Calculate month total:
          calculateMonthTotals(data);

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final khataModel = data[index];
              final monthTotal = monthTotalMap[khataModel.date!.month] ?? 0;

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.entryScreen,
                      arguments: {'date': data[index].date!});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.01),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: ListView(
                    children: [
                      Text(
                        "${monthFormat.format(data[index].date!)} / ${yearFormat.format(data[index].date!)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      SizedBox(height: height * 0.01),
                      Text(
                        "PKR/Kilo: ${data[index].literPrice.toString()}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        "Total PKR:  $monthTotal",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                // Delete Khata:

                                deleteDialog(
                                  context: context,
                                  kOrE: 'Khata',
                                  onPressed: () {
                                    deleteKhata(data[index]); // Delete Khata
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete_outline)),
                          IconButton(
                              onPressed: () => _editKhataDialog(
                                  khataModel: data[index],
                                  price: data[index].literPrice!),
                              // Must Change ---------------------------------------
                              icon: const Icon(Icons.edit_note_outlined))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.addKhataScreen);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Delete Entire Khata:
  void deleteKhata(KhataModel khataModel) async {
    await khataModel.delete();
  }

  // Edit Khata:
  Future<void> _editKhataDialog(
      {required KhataModel khataModel, required double price}) async {
    final height = MediaQuery.of(context).size.height;

    priceController.text = price.toString();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit PKR/Kilo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter the new Price per Kilo!'),
              SizedBox(height: height * 0.02),
              TextField(
                controller: priceController,
                decoration:
                    textInputDecoration.copyWith(labelText: 'Enter PKR/Kilo'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
                onPressed: () async {
                  final newPrice = double.parse(priceController.text);

                  khataModel.literPrice = newPrice;

                  await khataModel.save();

                  // Update old entries with the new modified price
                  final entryBox = Boxes.getEntryData();
                  final oldEntries = entryBox.values.where(
                      (entry) => entry.date!.month == khataModel.date!.month);

                  for (final entry in oldEntries) {
                    entry.entryPrice = entry.quantity! * newPrice;

                    debugPrint("New Entry ${entry.entryPrice}");
                    await entry.save();
                  }

                  priceController.clear();

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.edit_attributes_outlined),
                label: const Text('Modify')),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel')),
          ],
        );
      },
    );
  }
}
