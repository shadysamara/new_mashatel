import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/shimmer_products.dart';
import 'package:mashatel/features/messanger/ui/pages/massenger.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsPage extends StatelessWidget {
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
        ),
        body: AllExistsChats(MashatelClient.mashatelClient.getUser()));
  }
}

class AllExistsChats extends StatelessWidget {
  String myId;
  AllExistsChats(this.myId);
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return Obx(() {
      return appGet.allChats.isNotEmpty
          ? ListView.builder(
              itemCount: appGet.allChats.length,
              itemBuilder: (context, index) {
                String allUsers = appGet.allChats[index]['otherUserMap']
                        ['isMarket']
                    ? '${appGet.allChats[index]['otherUserMap']['userName']} (${appGet.allChats[index]['otherUserMap']['companyName']})'
                    : '${appGet.allChats[index]['otherUserMap']['userName']}';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MassengerPage(
                          appGet.allChats[index]['otherUserId'],
                          chatId: appGet.allChats[index]['chatId'],
                        );
                      },
                    ));
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Row(
                        children: [
                          appGet.allChats[index]['otherUserMap']['isMarket']
                              ? Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  width: 70.w,
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            appGet.allChats[index]
                                                ['otherUserMap']['imagePath']),
                                        fit: BoxFit.fill),
                                  ),
                                )
                              : Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: CircleAvatar(
                                    child: Text(allUsers[0].toUpperCase()),
                                  ),
                                ),
                          Text(allUsers)
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(translator.translate('no_chats')),
            );
    });
  }
}
