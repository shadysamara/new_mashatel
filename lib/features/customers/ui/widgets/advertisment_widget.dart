import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mashatel/features/customers/modles/advertisment.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/radii.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertismentWidget extends StatelessWidget {
  Advertisment advertisment;
  double margin;
  AdvertismentWidget(this.advertisment, this.margin);
  launchURL() async {
    if (await canLaunch(advertisment.url)) {
      await launch(advertisment.url);
    } else {
      CustomDialougs.utils
          .showDialoug(messageKey: 'launch_error', titleKey: 'alert');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return GestureDetector(
      onTap: () {
        launchURL();
      },
      child: Container(
        color: Colors.white,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: margin.h),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Radii.widgetsRadius,
          ),
          height: 110.h,
          width: 110.w,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: advertisment.imageUrl,
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}
