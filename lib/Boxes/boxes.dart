import 'package:doodh_app/Models/entry_model.dart';
import 'package:doodh_app/Models/khata_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<KhataModel> getKhataData() => Hive.box<KhataModel>('khotaaaaa');
  static Box<EntryModel> getEntryData() => Hive.box<EntryModel>('entryyyyy');
}
