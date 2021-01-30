import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


Future createBodyMeasurement(String age,String height,String weight,BuildContext context ) async {
  var resBody={};
  resBody["age"]=age;
  resBody["height"]=height;
  resBody["weight"]=weight;
  String str=json.encode(resBody);
  print(str);
  final http.Response response = await http.post(
    'https://c87ac0f6be11.ngrok.io/predict',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: str,
  );

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Failed to create album.');
  }
}