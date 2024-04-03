import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseDistante {
  final String url;
  final String anonKey;
  late final SupabaseClient supabaseClient;

  DatabaseDistante({
    required this.url,
    required this.anonKey,
  });

  Future<void> initSupabase() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    this.supabaseClient = Supabase.instance.client;
  }

  Future<bool> signIn(String username, String password) async {
    print(username);
    print(password);
    final response = await this.supabaseClient
    .from("UTILISATEUR")
    .select("*");
    print(response);
    if (response.isEmpty) {
      return false;
    }
    return true;
  }
}
