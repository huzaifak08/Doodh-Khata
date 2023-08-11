import 'package:hive/hive.dart';
part 'entry_model.g.dart';

@HiveType(typeId: 1)
class EntryModel extends HiveObject {
  // Fields:

  @HiveField(0)
  DateTime? date;

  @HiveField(1)
  double? quantity;

  @HiveField(2)
  double? entryPrice;

  EntryModel({this.date, this.quantity, this.entryPrice});
}
