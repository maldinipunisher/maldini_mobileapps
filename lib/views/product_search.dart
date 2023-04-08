import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:maldini_mobileapps/models/product.dart';

class ProductSearch extends StatefulWidget {
  final List<Product?> products;
  const ProductSearch({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  List<Product?> result = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  offset: Offset(0, 2.w), blurRadius: 10.w, color: Colors.grey)
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      size: 24.sp,
                    )),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 231, 231),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    width: 300.w,
                    child: TextFormField(
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      onChanged: (val) {
                        setState(() {
                          result = widget.products
                              .where((element) =>
                                  element!.name.toLowerCase().contains(val) ||
                                  element.name.contains(val) ||
                                  element.name.toUpperCase().contains(val))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16.w),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 0, 65, 150),
                        ),
                        hintText: "Cari menu",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    )),
                SizedBox(
                  width: 24.sp,
                ),
              ],
            ),
          ),
          Column(
            children: result
                .map((e) => ListTile(
                      title: Text(e!.name),
                    ))
                .toList(),
          )
        ],
      )),
    );
  }
}
