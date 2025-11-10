import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/login/Model/otpBodyModel.dart';
import 'package:shopping_app_olx/login/controller/otpController.dart';

class OtpPage extends ConsumerStatefulWidget {
  final String phone;
  const OtpPage({super.key, required this.phone});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  String otp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [

                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                    ),
                  ),
                ),

                Image.asset("assets/bgimage.png"),

                Positioned.fill(
                  top: 150.h,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity, // ya specific width
                        height: 350.h, // aapki desired height
                        child: Center(
                          child: Image.asset(
                            "assets/otpimage.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Center(
                        child: Text(
                          "Enter OTP",
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 26.sp,
                            color: Color(0xFF242126),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 44.w, right: 44.w),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Enter your OTP send to your number your provided",
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Color(0xFF615B68),
                            letterSpacing: -0.75,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Which is",
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: Color(0xFF615B68),
                              letterSpacing: -0.75,
                            ),
                          ),
                          Text(
                            "${widget.phone}",
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: Color(0xFF891AFF),
                              letterSpacing: -0.75,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      OtpPinField(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        fieldHeight: 45,
                        fieldWidth: 45,
                        otpPinFieldStyle: OtpPinFieldStyle(
                          defaultFieldBorderColor: Colors.grey,
                          activeFieldBorderColor: Color(0XFF891AFF),
                        ),
                        otpPinFieldDecoration:
                            OtpPinFieldDecoration.roundedPinBoxDecoration,
                        maxLength: 6,
                        onChange: (value) {
                          setState(() {
                            otp = value;
                          });
                        },
                        onSubmit: (value) async {

                          final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                          String? token = await _firebaseMessaging.getToken();
                          print('FCM Token: $token');
                          final otpBody = OtpBodyModel(
                            phoneNumber: widget.phone,
                            otp: value,
                            fcm_Token:token!,

                          );

                          try {
                            final response = await ref.watch(
                              otpProvider(otpBody).future,
                            );


                            log("TOKEN SAVED: ${response.token}");


                            var box = await Hive.box("data");
                            await box.put("token", response.token.toString());
                            await box.put("id", response.user.id.toString());

                            await box.put(
                              "fullName",
                              response.user.fullName.toString(),
                            );
                            await box.put(
                              "address",
                              response.user.address.toString(),
                            );
                            await box.put(
                              "city",
                              response.user.city.toString(),
                            );
                            await box.put(
                              "phoneNumber",
                              response.user.phoneNumber,
                            );
                            Fluttertoast.showToast(msg: "Login Successful");
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            log("otp failed ${e.toString()}");

                            Fluttertoast.showToast(msg: "Invalid OTP");
                          }
                        },
                      ),
                      SizedBox(height: 20),
                   Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Edit your number?",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF615B68),
                                ),
                              ),
SizedBox(width: 20.w,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Edit Number",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF891AFF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                    ],
                  ),
                ),



              ],
            ),

          ],
        ),
      ),
    );
  }
}
