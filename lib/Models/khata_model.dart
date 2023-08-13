import 'package:doodh_app/Models/entry_model.dart';
import 'package:hive/hive.dart';
part 'khata_model.g.dart';

@HiveType(typeId: 0)
class KhataModel extends HiveObject {
  // Hive Fields:
  @HiveField(0)
  String? khataKey;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  double? literPrice;

  @HiveField(3)
  List<EntryModel> entryModel;

  KhataModel(
      {this.khataKey, this.date, this.literPrice, required this.entryModel});
}
