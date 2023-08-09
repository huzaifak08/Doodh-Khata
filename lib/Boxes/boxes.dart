import 'package:doodh_app/Models/khata_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<KhataModel> getData() => Hive.box<KhataModel>('khata');
}
