import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Models/currentWeatherModel.dart';
import '../const/strings.dart';


 getCurrentWeather(lat,long) async{
   var link = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric';
  final response = await http.get(Uri.parse(link));
  var data = jsonDecode(response.body.toString());
  if(response.statusCode == 200){

    Get.snackbar('Congratulation','Everything is going perfect',snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.amber,colorText: Colors.white,margin: EdgeInsets.all(10));
    return CurrentWeatherModel.fromJson(data);

  }
}
List<dynamic> list = [];

getHourlyWeather(lat,long) async{
  var hourlylink = 'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric';

  final response = await http.get(Uri.parse(hourlylink));
  var data = jsonDecode(response.body.toString());


  if(response.statusCode == 200){

    list = data['list'];
    return list;

  }
}