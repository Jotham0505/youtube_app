import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_clone_app/authentication/services/navigation_service.dart';



class AlertService {
  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationService;

  AlertService(){
    _navigationService =_getIt.get<NavigationService>();
  }

  void ShowToast({required String text, IconData icon = Icons.info}){
    try {
      
    } catch (e) {
      
    }
  }
}