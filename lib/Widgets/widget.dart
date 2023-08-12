import 'package:flutter/material.dart';

deleteDialog(
    {required BuildContext context,
    required String kOrE,
    required VoidCallback onPressed}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete $kOrE'),
        content: Text('Are you sure you want to delete $kOrE?'),
        actions: [
          ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.delete_outline_outlined),
              label: const Text('Delete')),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancel')),
        ],
      );
    },
  );
}
