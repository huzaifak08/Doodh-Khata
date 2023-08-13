import 'package:doodh_app/Models/entry_model.dart';
import 'package:doodh_app/Models/khata_model.dart';
import 'package:doodh_app/Provider/khataKey_provider.dart';
import 'package:doodh_app/Routes%20Service/route_name.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'Routes Service/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(KhataModelAdapter());
  Hive.registerAdapter(EntryModelAdapter());

  await Hive.openBox<KhataModel>('khotaaaaa');
  await Hive.openBox<EntryModel>('entryyyyy');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => KhatakeyProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: RouteName.homeScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
