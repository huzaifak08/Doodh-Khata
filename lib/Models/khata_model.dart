import 'package:doodh_app/Models/entry_model.dart';
import 'package:hive/hive.dart';
part 'khata_model.g.dart';

@HiveType(typeId: 0)
class KhataModel extends HiveObject {
  // Hive Fields:

  @HiveField(0)
  DateTime? date;

  @HiveField(1)
  double? literPrice;

  @HiveField(2)
  List<EntryModel> entryModel;

  KhataModel({this.date, this.literPrice, required this.entryModel});
}
