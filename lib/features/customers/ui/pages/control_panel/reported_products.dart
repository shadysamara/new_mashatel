import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/product_details/product_Details_main.dart';
import 'package:mashatel/features/customers/ui/widgets/banned_product_widget.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';

class ReportedProducts extends StatefulWidget {
  @override
  _ReportedProductsState createState() => _ReportedProductsState();
}

class _ReportedProductsState extends State<ReportedProducts> {
  AppGet appGet = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MashatelClient.mashatelClient.getReportedProducts();
  }

//  getAppUser() async {
//     appUser = await RegistrationClient.registrationIntance
//         .getMarketFromFirestore(spUser.userId);
//     if (spUser.isMarket) {
//       appGet.getMarketProducts(spUser.userId);
//     }
//     appGet.setAppUser(appUser);
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('report_appBar'.tr),
        ),
        body: Obx(() {
          return (appGet.bannedProducts.isEmpty)
              ? Center(
                  child: Text('no_reports'.tr),
                )
              : ListView.builder(
                  itemCount: appGet.bannedProducts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        AppUser appUser = await RegistrationClient
                            .registrationIntance
                            .getMarketFromFirestore(
                                appGet.bannedProducts[index].marketId);
                        Get.to(ProductDetails(
                            appGet.bannedProducts[index], appUser));
                      },
                      child: BannedProduct(
                        productModel: appGet.bannedProducts[index],
                      ),
                    );
                  },
                );
          // return Container(
          //   child: FutureBuilder<List<ProductModel>>(
          //     future: MashatelClient.mashatelClient.getReportedProducts(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return LoadingListPage();
          //       } else if (snapshot.hasData && snapshot.data == null) {
          //         return Center(
          //           child: Text('no_reports')),
          //         );
          //       } else {
          //         List<ProductModel> products = snapshot.data;

          //         return ListView.builder(
          //           itemCount: products.length,
          //           itemBuilder: (context, index) {
          //             return BannedProduct(
          //               productModel: products[index],
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // );
        }));
  }
}
