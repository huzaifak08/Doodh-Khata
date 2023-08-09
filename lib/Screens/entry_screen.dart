import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryScreen extends StatefulWidget {
  final dynamic data;
  const EntryScreen({super.key, required this.data});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final DateFormat monthFormat = DateFormat('MMMM');
  final DateFormat yearFormat = DateFormat('yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Entry: ${monthFormat.format(widget.data['date'])}/${yearFormat.format(widget.data['date'])}'),
        centerTitle: true,
      ),
    );
  }
}
