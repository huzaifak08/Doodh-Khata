import 'package:hive/hive.dart';
part 'entry_model.g.dart';

@HiveType(typeId: 1)
class EntryModel extends HiveObject {
  // Fields:
  @HiveField(0)
  String? khataKey;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  double? quantity;

  @HiveField(3)
  double? entryPrice;

  EntryModel({this.khataKey, this.date, this.quantity, this.entryPrice});
}
