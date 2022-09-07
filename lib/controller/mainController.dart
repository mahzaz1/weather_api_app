import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/api_services.dart';

class MainController extends GetxController{

  dynamic currentWeatherData;
  dynamic hourlyWeatherData;

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  var isLoaded = false.obs;

@override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await getUserLocation();
    currentWeatherData = getCurrentWeather(latitude.value,longitude.value);
    hourlyWeatherData = getHourlyWeather(latitude.value,longitude.value);

  }

  getUserLocation()async{
      var isLocationEnabled;
      var userPermission;

      isLocationEnabled = await Geolocator.isLocationServiceEnabled();

      if(!isLocationEnabled){
        Future.error('Location Is Not Enabled');
      }

      userPermission = Geolocator.checkPermission();

      if(userPermission == LocationPermission.deniedForever){
        return Future.error('Permission Is Denied Forever');
      }
      else if(userPermission == LocationPermission.denied){
        userPermission = Geolocator.requestPermission();
        if(userPermission == LocationPermission.denied ){
          return Future.error('Permission Is Denied');

        }
      }else{
        return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((response)
        {
          latitude.value = response.latitude;
          longitude.value = response.longitude;
          isLoaded.value = true;
        });
      }
  }
}