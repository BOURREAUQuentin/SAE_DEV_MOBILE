import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'UI/login.dart';
import 'UI/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://uydzbhtiqlcmfvqtmrsd.supabase.co",
      anonKey:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV5ZHpiaHRpcWxjbWZ2cXRtcnNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA0MTE1MjQsImV4cCI6MjAyNTk4NzUyNH0.aC8qM2QihVzg8U92z5sRPGQ5YKIAyYnEaWws6IQBZAQ");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saé Dev Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data!) {
            return Home();
          } else {
            return Login();
          }
        },
      ),
    );
  }

  Future<bool> _checkAuthenticated() async {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
