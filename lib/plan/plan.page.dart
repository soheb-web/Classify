import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/new/controller/plan.provider.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/plan/reting.page.dart';
import '../home/home.page.dart';



class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});
  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}


class _PlanPageState extends ConsumerState<PlanPage> {
  int tabBottom = 0;
  DateTime? lastBackPressTime;

  @override
  Widget build(BuildContext context) {

    final plan = ref.watch(planProvider);

    return PopScope(
    canPop: false,

    onPopInvoked: (didPop) {
      if (!didPop) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(page: 3)),
        );
      }
    },

        child: Scaffold(
      body: plan.when(
        data: (snap) {
          return SingleChildScrollView(
            child: Stack(
              children: [

                Container(
                  height: MediaQuery.of(context).size.height + 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                    ),
                  ),
                ),

                Image.asset("assets/bgimage.png"),

                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 60.h),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(page:3)));
                      // Navigator.pop(context);
                    },
                    child: Container(
                      width: 46.w,
                      height: 46.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),

                Positioned(
                  top: 100.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Center(
                          child: Text(
                            "Paid Plan",
                            style: GoogleFonts.dmSans(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 33, 36, 38),
                            ),
                          ),
                        ),


                        DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                dividerColor: Color.fromARGB(255, 137, 25, 255),
                                dividerHeight: 1.w,
                                unselectedLabelColor: Color.fromARGB(
                                  255,
                                  30,
                                  30,
                                  30,
                                ),
                                labelColor: Colors.black,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                                indicatorWeight: 6.w,
                                indicatorColor: Color.fromARGB(
                                  255,
                                  137,
                                  25,
                                  255,
                                ),
                                tabs: [
                                  Tab(
                                    child: Text(
                                      "Single Listing ",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(
                                          255,
                                          137,
                                          25,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "Multiple Listing ",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 30, 30, 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.h),

                              SizedBox(
                                height: 550.h,
                                child: TabBarView(
                                  children: [

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => RetingPage(),
                                          ),
                                        );
                                      },
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [

                                            ...snap.data
                                                .where(
                                                  (e) => e.planType == "single",
                                                )
                                                .map(
                                                  (e) => Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 10.h,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                  top:
                                                                      Radius.circular(
                                                                        20.r,
                                                                      ),
                                                                ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.white,
                                                          builder:
                                                              (
                                                                _,
                                                              ) => PaymentBottomSheet(
                                                                amount:
                                                                    double.tryParse(
                                                                      e.price,
                                                                    ) ??
                                                                    0.0,
                                                                id: e.id.toString(),
                                                              ),
                                                        );
                                                      },
                                                      child: PlanBody(
                                                        flag: false,
                                                        planID: e.id.toString(),
                                                        titlename: e.price,
                                                        duration:
                                                            e.duration.toString(),
                                                        desc: e.description,
                                                        addBoost: e.boostCount
                                                                .toString(),
                                                        bgColor: Colors.white,
                                                        plan: Colors.black,
                                                        month: Colors.black,
                                                        name: Colors.black,
                                                        title: Colors.black,
                                                        listing_type:e.listing_type.toString()
                                        
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Multiple Listing Plans

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => RetingPage(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          ...snap.data
                                              .where(
                                                (e) => e.planType == "multiple",
                                              )
                                              .map(
                                                (e) => Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 10.h,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(
                                                                      20.r,
                                                                    ),
                                                              ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                        builder:
                                                            (
                                                              _,
                                                            ) => PaymentBottomSheet(
                                                              amount:
                                                                  double.tryParse(
                                                                    e.price,
                                                                  ) ??
                                                                  0.0,
                                                              id: e.id.toString(),
                                                            ),
                                                      );
                                                    },
                                                    child: PlanBody(
                                                      flag: true,
                                                      planID: e.id.toString(),
                                                      titlename: e.price,
                                                      duration:
                                                          e.duration.toString(),
                                                      desc: e.description,
                                                      addBoost:
                                                          e.boostCount
                                                              .toString(),
                                                      bgColor: Colors.white,
                                                      plan: Colors.black,
                                                      month: Colors.black,
                                                      name: Colors.black,
                                                      title: Colors.black,
                                                        listing_type:e.listing_type.toString()
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.h),


                        // Text(
                        //   "Ads Visibility ",
                        //   style: GoogleFonts.dmSans(
                        //     fontSize: 20.sp,
                        //     fontWeight: FontWeight.w600,
                        //     color: Color.fromARGB(255, 33, 36, 38),
                        //   ),
                        // ),

                        SizedBox(height: 15.h),

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: 106.h,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20.r),
                        //     color: Colors.white,
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsets.only(left: 20.w, top: 20.h),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         FeatureBody(
                        //           txt: "15 days listing for Free Plan",
                        //         ),
                        //         FeatureBody(
                        //           txt: "30 days listing for Paid Plan",
                        //         ),
                        //         SizedBox(height: 10.h),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: 40.h),

                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          );
        },
        error: (err, stack) {
          return Center(child: Text("$err"));
        },
        loading: () => Center(child: CircularProgressIndicator()),
      ),
      )) ;
  }
}




// PLAN CARD
class PlanBody extends StatefulWidget {
  final bool flag;
  final String planID;
  final Color bgColor;
  final Color plan;
  final Color month;
  final Color name;
  final Color title;
  final String titlename;
  final String duration;
  final String desc;
  final String addBoost;
  final String listing_type;
  const PlanBody({
    super.key,
    required this.flag,
    required this.bgColor,
    required this.plan,
    required this.month,
    required this.name,
    required this.title,
    required this.titlename,
    required this.duration,
    required this.desc,
    required this.addBoost,
    required this.planID,
    required this.listing_type,
  });

  @override
  State<PlanBody> createState() => _PlanBodyState();
}

class _PlanBodyState extends State<PlanBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 166.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: widget.bgColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            RichText(
              text: TextSpan(
                style: GoogleFonts.dmSans(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.plan,
                ),
                children: [
                  TextSpan(text: '₹${widget.titlename}/'),
                  widget.flag==true?
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Text(
                      '${widget.addBoost} Ad / month',
                      style: GoogleFonts.dmSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.month,
                      ),
                    ),
                  ): WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Text(
                      '${widget.addBoost} Ad',
                      style: GoogleFonts.dmSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.month,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // SizedBox(height: 10.h),
            Row(

              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Text(
                //   "${widget.desc}",
                //   style: GoogleFonts.dmSans(
                //     fontSize: 14.sp,
                //     fontWeight: FontWeight.w500,
                //     color: widget.title,
                //     letterSpacing: -0.50,
                //   ),
                // ),

                Icon(Icons.star,size: 16.sp,),
                SizedBox(width: 10.w,),
                Text(
                  "Radius",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.title,
                    letterSpacing: -0.50,
                  ),
                ),
                SizedBox(width: 10.w,),
                Icon(Icons.arrow_forward,size: 16.sp,),
                SizedBox(width: 10.w,),
                Text(
                  widget.listing_type??"",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.title,
                    letterSpacing: -0.50,
                  ),
                ),

              ],),
            // SizedBox(height: 10.h,),
            Row(
              children: [
                Icon(Icons.star,size: 16.sp,),
                SizedBox(width: 10.w,),
                Text(
                  "${widget.duration} Days Live",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.name,
                  ),
                ),
              ],
            ),
         /*   Row(
              children: [
                Icon(Icons.star,size: 16.sp,),
                SizedBox(width: 10.w,),
                Text(
                  "${widget.addBoost} Ads (1 ads/ day)",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.name,
                  ),
                ),
              ],
            ),*/

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    Icon(Icons.star,size: 16.sp,),
                    SizedBox(width: 10.w,),
                    Text(
                      "Unlimited Chats",
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: widget.title,
                        letterSpacing: -0.50,
                      ),
                    ),



                  ],
                ),

                Icon(Icons.arrow_forward_ios,size: 20,)

              ],
            ),


          ],
        ),
      ),
    );
  }
}

// FEATURE CHECKLIST
class FeatureBody extends StatefulWidget {
  final String txt;
  const FeatureBody({super.key, required this.txt});

  @override
  State<FeatureBody> createState() => _FeatureBodyState();
}

class _FeatureBodyState extends State<FeatureBody> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check, color: Color.fromARGB(255, 97, 91, 104)),
        SizedBox(width: 10.w),
        SizedBox(
          width: 330.w,
          child: Text(
            overflow: TextOverflow.ellipsis,
            widget.txt,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 97, 91, 104),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentBottomSheet extends StatefulWidget {
  final String id;
  final double amount;
  final double gstPercentage;

  PaymentBottomSheet({
    super.key,
    required this.amount,
    this.gstPercentage = 18,
    required this.id,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  bool loder = false;
  @override
  Widget build(BuildContext context) {
    final double gstAmount = (widget.amount * widget.gstPercentage) / 100;
    final double total = widget.amount + gstAmount;

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Payment Summary",
            style: GoogleFonts.dmSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.h),
          _row("Amount", "₹${widget.amount.toStringAsFixed(2)}"),
          _row("GST (${widget.gstPercentage}%)", "₹${gstAmount.toStringAsFixed(2)}"),
          Divider(),
          _row("Total", "₹${total.toStringAsFixed(2)}", isBold: true),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 137, 26, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.45.r),
                ),
              ),
              onPressed: () async{
                setState(() {
                  loder = true;
                });
                final box = Hive.box("data");
                final userid = box.get("id");
                final state = APIService(createDio());
                final response = await state.buyPlan(userId: userid, trnxId: "dadadasdadad", paymentType: "Success", status: "complete", planId: widget.id);

                if (response.response.data["status"] == true){
                  setState(() {
                    loder = false;
                  });
                  Fluttertoast.showToast(msg: "${response.response.data["message"]}", backgroundColor: Colors.blue, textColor: Colors.white);
                  // Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                }

                else{
                  setState(() {
                    loder = false;
                  });
                  Fluttertoast.showToast(msg: "${response.response.data["message"]}", backgroundColor: Colors.red, textColor: Colors.white);
                  Navigator.pop(context);
                }
                // navigate to payment or perform action
              },
              child: loder == true? CircularProgressIndicator(color: Colors.white,) : Text(
                "Pay Now",
                style: GoogleFonts.dmSans(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );

  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
