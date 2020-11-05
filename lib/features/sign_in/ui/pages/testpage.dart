import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:math';

class TestPage extends StatelessWidget {
  String title;
  TestPage(this.title);
  List<File> files = [];
  List<Asset> images = List<Asset>();
  List<Asset> resultList = List<Asset>();
  List<MultipartFile> imageList = new List<MultipartFile>();
  Future<void> loadAssets() async {
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      for (Asset asset in resultList) {
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile = new MultipartFile.fromBytes(
          imageData,
          filename: 'load_image${Random().nextInt(20)}.jpg',
          contentType: MediaType("image", "jpg"),
        );
        imageList.add(multipartFile);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () async {
                try {
                  print('hi');
                  Dio dio = Dio();
                  await loadAssets();
                  print(imageList.first.filename);
                  print(imageList.first.contentType);
                  print(imageList.length);
                  Map<String, dynamic> mapImages = {};
                  for (int i = 0; i < imageList.length; i++) {
                    mapImages["images[$i]"] = imageList[i];
                  }
                  print(mapImages);
                  FormData formData = FormData.fromMap({
                    ...mapImages,
                    'name': 'chocklate',
                    'price': '500',
                    'quantity': '5',
                    'discount': '200',
                    'market_price': '300',
                    'unit': '5',
                    'weight': '20',
                    'description': 'dark chocklate',
                    'factory': 'kinder',
                    'category_id': '1',
                    'colors': '["#8768", "#123123"]',
                    'size_list': [
                      {"size": "small", "price": 15}
                    ],
                  });
                  Response x = await dio.post(
                      'https://joodya.com/fenix/api/v1/product/save_product',
                      data: formData,
                      options: Options(headers: {
                        'Authorization':
                            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNGY4OTU1Y2VlZWY3ODI5ZGJmMzczMmVkZDU3MGQ5MTgxNzRkZDM4YjM1OWJhNTdkYmVhZTk1NDFhMjY1MzIxMjhjZGQ4MTU1NGNhY2FjMTEiLCJpYXQiOjE2MDIwODg2NzksIm5iZiI6MTYwMjA4ODY3OSwiZXhwIjoxNjMzNjI0Njc5LCJzdWIiOiIxMDMiLCJzY29wZXMiOltdfQ.TlANSR6EO_0Hebs11hUd0VFUffZqLOlWnyJUSdQlmyJfzRlXESjgnpbH3pzTJ5PSdr8OvC_yuiGTe6iSMcQjvdKKHdlRBxX6KpE1-LkMlFgeH8mAJOBwXpJe0HZpNDJZsCSr174ivSeO1qgNo2Tg_WEM6O0b3ApJEYazUZ8KS7i_ROpw8M5k9NmjyqZKb4PwbQFAqaPOtIoFHgfis7Oxf0KhVwKNuX00nlV3Ax1mby0E7OI_k572zYooyFRP9egK4R9Mlum9JB9qwYjUqcINf3Y_IFiGCM-rTi5y81Ya3jll2T-pvSbxW4dv9-LJziaH1KtKUjNzbbaIH0igP7UIJpGbxpKXmDu7HaZDi7gTmdqhJiSnfAOjjcCWh5KxqnUwEufYbbic3BbH-4PTEu8pUpee0HLYeRk8QngnqG823IegLiFxLNSvISZJsJAIVlWqQEYJFty77UcoBotYK3b8qc9Ed13kw4fIKH5x2n_hmdYPtbDZYjSF11bej1AhYn2_7-inZ10LuAFqf0z3CBXJo447Sb3lQOWRBj8LDFdS0J0-2EPj_ryrJZ-9hJtJs8-JkELiA7MawXyzGwDcZNIBf8AhGizNwaVbqxiDpuCpmnqAgI0luIpRBVeTtNYys8rHuSbhkwiBtB1PmyNPu41-CTDAqcdOY1Wo4EZhL9CeXFU'
                      }));
                  print('hi');
                  print(x.data);
                } on Exception catch (e) {
                  print('*********************************');
                  print(e);
                }
              })
        ],
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
