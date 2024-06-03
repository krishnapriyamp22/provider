import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provide_app/database/model.dart';
import 'package:provide_app/provider/helperclass.dart';
import 'package:provide_app/screen/splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.openBox<Studentupdates>('student');
  if(!Hive.isAdapterRegistered(StudentupdatesAdapter().typeId)) {
    Hive.registerAdapter(StudentupdatesAdapter());
  }
  runApp( MyApp());
}
// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Color.fromARGB(255, 87, 85, 254),)
        ),
        
        home: ScreenSplash(),
      ),
    );
  }
}

