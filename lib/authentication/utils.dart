import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone_app/authentication/services/alert_service.dart';
import 'package:youtube_clone_app/authentication/services/auth_service.dart';
import 'package:youtube_clone_app/authentication/services/media_service.dart';
import 'package:youtube_clone_app/authentication/services/navigation_service.dart';
import 'package:youtube_clone_app/authentication/services/video_service.dart';
import 'package:youtube_clone_app/values.dart';

Future<void> setupSupabse() async{
  await Supabase.initialize(
    url: 'https://ilevhhdhpwfijooamtby.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlsZXZoaGRocHdmaWpvb2FtdGJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMjA5OTUsImV4cCI6MjAzNDg5Njk5NX0.huTlpXduBD6jDwKno5FMAl1oNERSQoh5pK1EGQG8xPk',
  );
}

Future<void> registerService() async{
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AlertService>(AlertService());
  getIt.registerSingleton<MediaService>(MediaService());
  getIt.registerSingleton<VideoService>(VideoService());
}