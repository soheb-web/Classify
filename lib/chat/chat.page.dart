import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/chat/chating.page.dart';
import 'package:shopping_app_olx/chat/controller/inboxProvider.provider.dart';
import 'package:shopping_app_olx/cloth/service/categoryController.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});
  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(inboxProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inboxListASync = ref.watch(inboxProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 247),
      body: RefreshIndicator(

        onRefresh: () async {
          await ref.refresh(inboxProvider);
        },

        child:

        inboxListASync.when(
          data: (snap) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 60.h),

                /// Header
                Row(
                  children: [
                    SizedBox(width: 20.w),
                    Text(
                      "Message",
                      style: GoogleFonts.dmSans(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 36, 33, 38),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                /// Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SizedBox(
                    height: 49.h,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 13.h,
                          horizontal: 13.w,
                        ),
                        prefixIcon: Icon(Icons.search, size: 20.sp),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.r),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search chats...",
                        hintStyle: GoogleFonts.dmSans(fontSize: 19.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                /// Inbox List
                ///
                Expanded(

                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child:

                    ListView.builder(
                      itemCount: snap.inbox.length, // your API data length
                      itemBuilder: (context, index) {

                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: GestureDetector(
                            onTap: () {

                              final converId = snap.inbox[index].conversationId;
                              final userid = snap.egedUser.id;



                              final messagesList = ref.watch(markSeen(converId));

                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder:
                                      (context) => ChatingPage(
                                        userid: snap.inbox[index].otherUser.id.toString(),
                                        name: snap.inbox[index].otherUser.name,
                                      ),
                                ),
                              );

                            },
                            child:


                            NameBody(

                              isReaded: snap.inbox[index].otherUser.isReaded,
                              image: snap.inbox[index].otherUser.profilePick.toString(),
                              //"assets/chatimage1.png", // static for now
                              name: snap.inbox[index].otherUser.name,
                              //"Unknown", // from API
                              txt: snap.inbox[index].otherUser.senderYou == true?   snap.inbox[index].lastMessage : snap.inbox[index].otherUser.isReaded == false? "New message":  snap.inbox[index].lastMessage,
                              //"No message yet",
                              time: "${snap.inbox[index].timestamp.hour}:${snap.inbox[index].timestamp.minute}",
                              // "--:--",
                              isDivider: true,


                            ),




                          ),
                        );
                      },
                    ),

                  ),
                ),


              ],
            );
          },
          error: (err, stack) => Center(child: Text("pull to refresh")),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),


      ),
    );
  }
}

class NameBody extends StatelessWidget {
  final String image;
  final String name;
  final String txt;
  final String time;
  final bool isDivider;
  final bool isReaded;

  const NameBody({
    super.key,
    required this.image,
    required this.name,
    required this.txt,
    required this.time,
    required this.isDivider,
    required this.isReaded
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            /// Profile Image
            ///
            ClipOval(
              child: Image.network(
                "//classfiy.onrender.com" + image,
                fit: BoxFit.cover,
                width: 44.w,
                height: 44.h,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported),
              ),
            ),

            SizedBox(width: 10.w),

            /// Name + Message
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 36, 33, 38),
                  ),
                ),
                Text(
                  txt,
                  style: GoogleFonts.dmSans(
                    fontSize: 12.sp,
                    fontWeight: isReaded ?  FontWeight.w500 : FontWeight.bold,
                    color: const Color.fromARGB(255, 97, 91, 104),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            const Spacer(),

            /// Time
            Text(
              time,
              style: GoogleFonts.dmSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 97, 91, 104),
              ),
            ),

          ],
        ),

        SizedBox(height: 10.h),
        isDivider ? const Divider() : const SizedBox(),

      ],
    );
  }
}
