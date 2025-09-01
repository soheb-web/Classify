// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shopping_app_olx/config/pretty.dio.dart';
// import 'package:shopping_app_olx/register/model/registerBodyModel.dart';
// import 'package:shopping_app_olx/register/model/registerResModel.dart';
// import 'package:shopping_app_olx/register/service/registerService.dart';

// final registerProvider =
//     FutureProvider.family<RegisterResModel, RegisterBodyModel>((
//       ref,
//       body,
//     ) async {
//       final registerservice = RegisterService(await createDio());
//       return registerservice.register(body);
//     });
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app_olx/globalkey/navigatorkey.dart';
import 'package:shopping_app_olx/login/login.page.dart';

class RegisterController {
  static Future<Map<String, dynamic>> register({
    required BuildContext context,
    required String fullname,
    required String phonenumber,
    required String address,
    required String city,
    required String pincode,
  }) async {
    final Uri url = Uri.parse(
      "https://classfiy.onrender.com/api/auth/register",
    );
    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({"Accept": "application/json"});

    request.fields.addAll({
      "full_name": fullname,
      "phone_number": phonenumber,
      "address": address,
      "city": city,
      "pincode": pincode,
    });

    try {
      final http.StreamedResponse response = await request.send();
      final responsebody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responsebody);

      log(responsebody);
      log(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Your account is created successfull")));
        navigatorKey.currentState?.push(
          CupertinoPageRoute(builder: (context) => LoginPage()),
        );
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["errors"]["phone_number"].toString())),
        );
        throw Exception("Failed to register :${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Something went wrong :$e");
    }
  }
}
