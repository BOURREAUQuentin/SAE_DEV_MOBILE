import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'UI/login.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final SupabaseClient client = SupabaseClient('https://uydzbhtiqlcmfvqtmrsd.supabase.co','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV5ZHpiaHRpcWxjbWZ2cXRtcnNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA0MTE1MjQsImV4cCI6MjAyNTk4NzUyNH0.aC8qM2QihVzg8U92z5sRPGQ5YKIAyYnEaWws6IQBZAQ');
  
  @override
  Widget build(BuildContext context) {
    _test();
    return MaterialApp(
      title: 'Saé Dev Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }

  _test() async{
    print("a");
    print(MyApp.client.from("UTILISATEUR").select());
    final response = await MyApp.client
        .from("UTILISATEUR")
        .select();

    print("test");
    print(response.length);
  }
}
