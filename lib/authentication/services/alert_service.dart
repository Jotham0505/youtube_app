import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
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
      DelightToastBar(
        builder: (context){
          return ToastCard(
            title: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14
              ),
            ),
          );
        }
      ).show(_navigationService.navigatorkey!.currentContext!);
    } catch (e) {
      print(e);
    }
  }
}