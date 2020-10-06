import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/modles/advertisment.dart';
import 'package:mashatel/values/colors.dart';
import 'package:url_launcher/url_launcher.dart' as Uri_launcher;

class CarouselWithIndicatorDemo extends StatefulWidget {
  final List<String> urls;
  final bool isAds;
  final List<Advertisment> ads;
  CarouselWithIndicatorDemo({this.urls, this.isAds = false, this.ads});

  @override
  _CarouselWithIndicatorDemoState createState() =>
      _CarouselWithIndicatorDemoState();
}

class _CarouselWithIndicatorDemoState extends State<CarouselWithIndicatorDemo> {
  List<Widget> imageSliders = [];
  int _current = 0;
  Future<void> _launchInBrowser(String url) async {
    if (await Uri_launcher.canLaunch(url)) {
      await Uri_launcher.launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> generateSliderWidgets() {
    List<Widget> imageSliders = widget.isAds
        ? widget.ads
            .map((item) => Container(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: GestureDetector(
                        onTap: () {
                          _launchInBrowser(item.url);
                        },
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) {
                            return FlareActor(
                              "assets/animations/loading.flr",
                              sizeFromArtboard: true,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              animation: "loading",
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ))
            .toList()
        : widget.urls
            .map((item) => Container(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: CachedNetworkImage(
                        imageUrl: item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) {
                          return FlareActor(
                            "assets/animations/loading.flr",
                            sizeFromArtboard: true,
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            animation: "loading",
                          );
                        },
                      ),
                    ),
                  ),
                ))
            .toList();
    return imageSliders;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageSliders = generateSliderWidgets();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return imageSliders.isNotEmpty
        ? Column(children: [
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  viewportFraction: 1.1,
                  enlargeCenterPage: true,
                  height: size.height / 4,
                  onPageChanged: (index, reason) {
                    setState(() {
                      //// change indicator
                      _current = index;
                    });
                  }),
            ),
            ///// indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.isAds
                  ? widget.ads.map((url) {
                      int index = widget.ads.indexOf(url);
                      return Container(
                        width: 8.0.w,
                        height: 8.0.h,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? AppColors.primaryColor
                              : AppColors.secondaryElement,
                        ),
                      );
                    }).toList()
                  : widget.urls.map((url) {
                      int index = widget.urls.indexOf(url);
                      return Container(
                        width: 8.0.w,
                        height: 8.0.h,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? AppColors.primaryColor
                              : AppColors.secondaryElement,
                        ),
                      );
                    }).toList(),
            ),
          ])
        : Container(
            height: size.height / 4,
            child: Image.asset('assets/images/logo.png'));
  }
}
