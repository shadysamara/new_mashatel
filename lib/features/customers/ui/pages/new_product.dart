// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mashatel/features/customers/blocs/app_get.dart';
// import 'package:mashatel/features/customers/modles/product.dart';
// import 'package:mashatel/services/connectvity_service.dart';
// import 'package:mashatel/utils/custom_dialoug.dart';
// import 'package:mashatel/values/colors.dart';
// import 'package:mashatel/widgets/TextField.dart';
// import 'package:mashatel/widgets/custom_appbar.dart';
// import 'package:mashatel/widgets/custom_drawer.dart';
// import 'package:mashatel/widgets/primary_button.dart';

// class NewProductOld extends StatelessWidget {
//   String marketId;
//   NewProductOld(this.marketId);
//   AppGet appGet = Get.put(AppGet());

//   GlobalKey<FormState> formKey = GlobalKey();

//   bool isUploaded = false;

//   File imageFile;

//   String nameEn;

//   String nameAr;

//   String descAr;

//   String descEn;

//   double price;

//   setProductNameAr(String value) {
//     this.nameAr = value;
//   }

//   setProductNameEn(String value) {
//     this.nameEn = value;
//   }

//   setProductDescAr(String value) {
//     this.descAr = value;
//   }

//   setProductDescEn(String value) {
//     this.descEn = value;
//   }

//   setPrice(String value) {
//     this.price = double.parse(value);
//   }

//   setCatNameEn(String value) {
//     this.nameEn = value;
//   }

//   nullValidation(String value) {
//     if (value.isEmpty) {
//       return 'null_error');
//     }
//   }

//   saveForm() async {
//     if (formKey.currentState.validate()) {
//       if (appGet.imagePath.value.isNotEmpty) {
//         formKey.currentState.save();
//         if (ConnectivityService.connectivityStatus !=
//             ConnectivityStatus.Offline) {
//           Product product = Product(
//             marketId: appGet.marketId.value,
//             nameAr: this.nameAr,
//             nameEn: this.nameEn,
//             price: this.price,
//             descAr: this.descAr,
//             descEn: this.descEn,
//           );
//           String productId = await appGet.addNewProduct(product);
//           if (productId != null) {
//             CustomDialougs.utils.showSackbar(
//                 messageKey: 'success_product_added', titleKey: 'success');
//             Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
//           } else {
//             CustomDialougs.utils.showSackbar(
//                 messageKey: 'faild_product_added', titleKey: 'faild');
//             appGet.imagePath.value = '';
//             Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
//           }
//         } else {
//           CustomDialougs.utils
//               .showDialoug(messageKey: 'network_error', titleKey: 'alert');
//         }
//       } else {
//         CustomDialougs.utils
//             .showDialoug(messageKey: 'uploaded_image_error', titleKey: 'alert');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       drawer: AppSettings(appGet.appUser.value),
//       appBar: BaseAppbar('new_product'),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GestureDetector(onTap: () async {
//                 appGet.imagePath.value = '';
//                 PickedFile pickImage =
//                     await ImagePicker().getImage(source: ImageSource.gallery);
//                 this.imageFile = File(pickImage.path);
//                 appGet.setLocalImageFile(imageFile);
//               }, child: Obx(() {
//                 return appGet.localImageFilePath.value.isNotEmpty
//                     ? appGet.imagePath.value.isNotEmpty
//                         ? Container(
//                             width: 200.w,
//                             height: 200.h,
//                             child: Image.file(
//                               File(appGet.localImageFilePath.value),
//                               fit: BoxFit.fill,
//                             ),
//                           )
//                         : Container(
//                             width: 200.w,
//                             height: 200.h,
//                             child: Opacity(
//                                 opacity: 0.1,
//                                 child: Image.file(
//                                   File(appGet.localImageFilePath.value),
//                                 )),
//                           )
//                     : Container(
//                         width: 150.w,
//                         height: 150.h,
//                         color: Colors.grey[400],
//                         child: Icon(Icons.add),
//                       );
//               })),
//               SizedBox(
//                 height: 30.h,
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 50.w),
//                 child: PrimaryButton(
//                     color: AppColors.primaryColor,
//                     textKey: 'upload_image',
//                     buttonPressFun: () {
//                       if (ConnectivityService.connectivityStatus !=
//                           ConnectivityStatus.Offline) {
//                         appGet.uploadImage(imageFile);
//                       } else {
//                         CustomDialougs.utils.showDialoug(
//                             messageKey: 'network_error', titleKey: 'alert');
//                       }
//                     }),
//               ),
//               SizedBox(
//                 height: 40.h,
//               ),
//               Form(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       MyTextField(
//                         hintTextKey: 'nameAr',
//                         nofLines: 1,
//                         saveFunction: setProductNameAr,
//                         validateFunction: nullValidation,
//                       ),
//                       MyTextField(
//                         hintTextKey: 'nameEn',
//                         nofLines: 1,
//                         saveFunction: setProductNameEn,
//                         validateFunction: nullValidation,
//                       ),
//                       MyTextField(
//                         hintTextKey: 'descAr',
//                         nofLines: 1,
//                         saveFunction: setProductDescAr,
//                         validateFunction: nullValidation,
//                       ),
//                       MyTextField(
//                         hintTextKey: 'descEn',
//                         nofLines: 1,
//                         saveFunction: setProductDescEn,
//                         validateFunction: nullValidation,
//                       ),
//                       MyTextField(
//                         hintTextKey: 'price',
//                         nofLines: 1,
//                         textInputType: TextInputType.number,
//                         saveFunction: setPrice,
//                         validateFunction: nullValidation,
//                       ),
//                     ],
//                   )),
//               PrimaryButton(
//                   color: AppColors.primaryColor,
//                   textKey: 'add',
//                   buttonPressFun: saveForm)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
