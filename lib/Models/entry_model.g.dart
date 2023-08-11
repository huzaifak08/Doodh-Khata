// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryModelAdapter extends TypeAdapter<EntryModel> {
  @override
  final int typeId = 1;

  @override
  EntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntryModel(
      date: fields[0] as DateTime?,
      quantity: fields[1] as double?,
      entryPrice: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, EntryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.entryPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
