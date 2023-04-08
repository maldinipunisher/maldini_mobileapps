// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:maldini_mobileapps/configs/url_list.dart';
import 'package:maldini_mobileapps/http_parser/http_parser.dart';
import 'package:maldini_mobileapps/models/product.dart';

class ProductUpdatePage extends StatefulWidget {
  final Product product;
  const ProductUpdatePage({super.key, required this.product});

  @override
  State<ProductUpdatePage> createState() => _ProductUpdatePageState();
}

class _ProductUpdatePageState extends State<ProductUpdatePage> {
  final name = TextEditingController();
  final picture = TextEditingController();
  final picture_ori = TextEditingController();
  final price = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? const Center(
            child: SpinKitFadingCircle(
              color: Colors.amberAccent,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Update Makanan"),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: ListView(
                children: [
                  Text("Nama"),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Color.fromARGB(255, 216, 216, 216),
                    ),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          hintText: "Masukkan nama makanan",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("Price"),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Color.fromARGB(255, 216, 216, 216),
                    ),
                    child: TextFormField(
                      controller: price,
                      decoration: InputDecoration(
                          hintText: "Masukkan harga makanan",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("Gambar"),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Color.fromARGB(255, 216, 216, 216),
                    ),
                    child: TextFormField(
                      controller: picture,
                      decoration: InputDecoration(
                          hintText: "Masukkan link gambar",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("Gambar Ori"),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Color.fromARGB(255, 216, 216, 216),
                    ),
                    child: TextFormField(
                      controller: picture_ori,
                      decoration: InputDecoration(
                          hintText: "Masukkan link gambar ori",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => (states.contains(MaterialState.pressed))
                              ? const Color.fromARGB(255, 65, 147, 255)
                              : const Color.fromARGB(255, 0, 65, 150),
                        ),
                        minimumSize:
                            MaterialStateProperty.all(Size(400.w, 30.h)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r)))),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final parser = HttpParser();
                      await parser.httpPut(
                          UrlList.updateProduct + widget.product.id.toString(),
                          body: {
                            "name": name.text,
                            "price": price.text,
                            "picture": picture.text,
                            "picture_ori": picture_ori.text,
                          }).then((value) {
                        if (value?.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Berhasil merubah")));
                        }
                      }).whenComplete(() {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
