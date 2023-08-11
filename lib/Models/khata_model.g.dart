// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khata_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KhataModelAdapter extends TypeAdapter<KhataModel> {
  @override
  final int typeId = 0;

  @override
  KhataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KhataModel(
      date: fields[0] as DateTime?,
      literPrice: fields[1] as double?,
      entryModel: (fields[2] as List).cast<EntryModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, KhataModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.literPrice)
      ..writeByte(2)
      ..write(obj.entryModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KhataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
