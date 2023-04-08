import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final Widget image;
  final String price;
  final String name;
  final VoidCallback onPressed;
  final double height;
  final double width;
  const ProductCard(
      {super.key,
      required this.image,
      required this.price,
      required this.name,
      required this.onPressed,
      this.height = 300,
      this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 1), blurRadius: 0.5, color: Colors.grey),
            BoxShadow(
                offset: Offset(0, -0.5), blurRadius: 0.1, color: Colors.grey),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.6, width: width, child: image),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "$price /porsi",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 0, 65, 150)),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => (states.contains(MaterialState.pressed))
                                ? const Color.fromARGB(255, 65, 147, 255)
                                : const Color.fromARGB(255, 0, 65, 150),
                          ),
                          minimumSize: MaterialStateProperty.all(
                              Size(width * 0.75, 30.h)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r)))),
                      onPressed: onPressed,
                      child: Text(
                        "Order",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
