import 'package:flutter/material.dart';
import 'package:mashatel/values/radii.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingCategoriesPage extends StatefulWidget {
  @override
  _LoadingListPageState createState() => _LoadingListPageState();
}

class _LoadingListPageState extends State<LoadingCategoriesPage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Radii.widgetsRadius,
                        ),
                        child: ClipRRect(
                          borderRadius: Radii.widgetsRadius,
                          clipBehavior: Clip.antiAlias,
                          child: Row(
                            children: [
                              Container(
                                width: 120.w,
                                height: 120.h,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      right: 10.w, top: 10.h, bottom: 10.h),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
