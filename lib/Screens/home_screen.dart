import 'package:doodh_app/Boxes/boxes.dart';
import 'package:doodh_app/Models/khata_model.dart';
import 'package:doodh_app/Routes%20Service/route_name.dart';
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
                              onPressed: () {},
                              icon: const Icon(Icons.delete_outline)),
                          IconButton(
                              onPressed: () {},
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
}
