import 'package:hive/hive.dart';
part 'khata_model.g.dart';

@HiveType(typeId: 0)
class KhataModel extends HiveObject {
  // Hive Fields:

  @HiveField(0)
  DateTime? date;

  @HiveField(1)
  int? literPrice;

  KhataModel({this.date, this.literPrice});
}
