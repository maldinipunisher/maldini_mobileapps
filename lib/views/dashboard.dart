// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:maldini_mobileapps/components/product_card.dart';
import 'package:maldini_mobileapps/models/product.dart';
import 'package:maldini_mobileapps/views/crud.dart';
import 'package:maldini_mobileapps/views/product_search.dart';
import 'package:collection/collection.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final draggableScrollableController = DraggableScrollableController();
  final totalController = TextEditingController();
  final products = <Product?>[];
  final orders = <Product?>[];
  double initialBottomSheet = 0.125;
  bool loading = true;
  Map groupedOrders = {};

  @override
  void initState() {
    Product.getAll().then((value) {
      setState(() {
        products.addAll(value);
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    [draggableScrollableController, totalController].map((e) => e.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initialBottomSheet = 0.125;
    if (orders.isNotEmpty) {
      groupedOrders = groupBy(orders, (p) => p!.name);
      if (groupedOrders.isNotEmpty) {
        for (var v in groupedOrders.keys) {
          if (initialBottomSheet >= 1) {
            break;
          } else {
            initialBottomSheet += 0.125;
          }
        }
      }
      draggableScrollableController.animateTo(initialBottomSheet,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    String kembalian = "Rp. 0";
    print(initialBottomSheet);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maldini Mobile Apps"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ProductSearch(
                        products: products,
                      );
                    });
              },
              icon: const Icon(
                Icons.search,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CrudPage(products: products)));
              },
              icon: const Icon(
                Icons.add,
              ))
        ],
      ),
      body: (loading)
          ? Container(
              color: Colors.white,
              child: const Center(
                child: SpinKitFadingCircle(
                  color: Colors.amberAccent,
                ),
              ),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 9 / 16,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      children: products
                          .map((e) => ProductCard(
                              image: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    topRight: Radius.circular(12.r)),
                                child: Image.network(
                                  e!.picture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              price: NumberFormat.currency(
                                      locale: "id",
                                      symbol: "Rp.",
                                      decimalDigits: 0)
                                  .format(int.tryParse(e.price) ?? 0),
                              name: e.name,
                              onPressed: () {
                                setState(() {
                                  orders.add(e);
                                });
                              }))
                          .toList()),
                ),
                SizedBox.expand(
                  child: DraggableScrollableSheet(
                    initialChildSize: initialBottomSheet,
                    minChildSize: 0.125,
                    expand: true,
                    controller: draggableScrollableController,
                    builder: (context, scrollController) {
                      return NotificationListener<
                          OverscrollIndicatorNotification>(
                        onNotification: (notification) {
                          notification.disallowIndicator();
                          return false;
                        },
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 15.h),
                                      width: ScreenUtil().screenWidth,
                                      height: ScreenUtil().screenHeight * 0.87,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15.w),
                                      height: 2.w,
                                      color: Color.fromARGB(255, 0, 65, 150),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(5.w),
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 0, 65, 150),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.r),
                                                ),
                                                child: Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.shop_outlined,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 0, 65, 150),
                                                        size: 32.sp,
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Text(NumberFormat
                                                              .currency(
                                                                  locale: "id",
                                                                  symbol: "Rp.",
                                                                  decimalDigits:
                                                                      0)
                                                          .format(orders.fold(
                                                              0,
                                                              (previousValue,
                                                                      element) =>
                                                                  previousValue +
                                                                  ((element !=
                                                                          null)
                                                                      ? int.parse(
                                                                          element
                                                                              .price)
                                                                      : 0)))
                                                          .toString())
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        elevation:
                                                            MaterialStateProperty
                                                                .all(0),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .resolveWith(
                                                          (states) => (orders
                                                                  .isNotEmpty)
                                                              ? (states.contains(
                                                                      MaterialState
                                                                          .pressed))
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      65,
                                                                      147,
                                                                      255)
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      0,
                                                                      65,
                                                                      150)
                                                              : Colors.grey,
                                                        ),
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all(Size(100.w,
                                                                    30.h)),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6.r)))),
                                                    onPressed: () {
                                                      if (orders.isNotEmpty) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                return AlertDialog(
                                                                  title: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .food_bank,
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              65,
                                                                              150)),
                                                                      Text(
                                                                        "Detail Pesanan",
                                                                        style:
                                                                            TextStyle(
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              65,
                                                                              150),
                                                                          fontSize:
                                                                              14.sp,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Column(
                                                                        children: groupedOrders
                                                                            .entries
                                                                            .map((e) =>
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(bottom: 10.h),
                                                                                  child: SizedBox(
                                                                                    height: 40.h,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Image.network(
                                                                                              "${e.value.first.picture}",
                                                                                              width: 30.h,
                                                                                              height: 30.h,
                                                                                              fit: BoxFit.cover,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10.w,
                                                                                            ),
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text("${e.key}"),
                                                                                                Text("${NumberFormat.currency(locale: "id", symbol: "Rp.", decimalDigits: 0).format(int.tryParse(e.value?.first.price) ?? 0)}/ porsi"),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                          children: [
                                                                                            Text("x${e.value.length.toString()}"),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            .toList(),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Total",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            ":",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            NumberFormat.currency(locale: "id", symbol: "Rp.", decimalDigits: 0).format(orders.fold(0, (previousValue, element) => previousValue + ((element != null) ? int.parse(element.price) : 0))).toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10.h,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Uang Dibayar",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            ":",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                130.w,
                                                                            height:
                                                                                40.h,
                                                                            child:
                                                                                TextFormField(
                                                                              controller: totalController,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  kembalian = NumberFormat.currency(locale: "id", symbol: "Rp.", decimalDigits: 0).format((int.tryParse(value) ?? 0) - orders.fold(0, (previousValue, element) => previousValue + ((element != null) ? int.parse(element.price) : 0))).toString();
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                  hintText: "Total uang",
                                                                                  border: OutlineInputBorder(
                                                                                    borderSide: BorderSide.none,
                                                                                  )),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10.h,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Kembalian",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            ":",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            kembalian,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            elevation: MaterialStateProperty.all(0),
                                                                            backgroundColor: MaterialStateProperty.resolveWith(
                                                                              (states) => (states.contains(MaterialState.pressed)) ? const Color.fromARGB(255, 65, 147, 255) : const Color.fromARGB(255, 0, 65, 150),
                                                                            ),
                                                                            minimumSize: MaterialStateProperty.all(Size(300.w, 30.h)),
                                                                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)))),
                                                                        onPressed:
                                                                            () {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(content: Text("Struk Tercetak")));
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Cetak Struk",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16.sp,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                            });
                                                      }
                                                    },
                                                    child: Text(
                                                      "Charge",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16.sp,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16.h,
                                              ),
                                              Column(
                                                children: groupedOrders.entries
                                                    .map((e) => Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 16.h),
                                                          child: SizedBox(
                                                            height: 65.h,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Image
                                                                        .network(
                                                                      "${e.value.first.picture}",
                                                                      width:
                                                                          65.h,
                                                                      height:
                                                                          65.h,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "${e.key}"),
                                                                        Text(
                                                                            "${NumberFormat.currency(locale: "id", symbol: "Rp.", decimalDigits: 0).format(int.tryParse(e.value?.first.price) ?? 0)}/ porsi"),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          for (var i = 0;
                                                                              i < orders.length;
                                                                              i++) {
                                                                            if (orders[i]!.name ==
                                                                                e.key) {
                                                                              orders.removeAt(i);
                                                                              break;
                                                                            }
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            40.w,
                                                                        height:
                                                                            30.w,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.r),
                                                                            border: Border.all(width: 1.w, color: const Color.fromARGB(255, 0, 65, 150))),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "-",
                                                                            style: TextStyle(
                                                                                fontSize: 16.sp,
                                                                                color: const Color.fromARGB(255, 0, 65, 150),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    Text(e.value
                                                                        .length
                                                                        .toString()),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          for (var i = 0;
                                                                              i < orders.length;
                                                                              i++) {
                                                                            if (orders[i]!.name ==
                                                                                e.key) {
                                                                              orders.add(orders[i]);
                                                                              break;
                                                                            }
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            40.w,
                                                                        height:
                                                                            30.w,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6.r),
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              65,
                                                                              150),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "+",
                                                                            style: TextStyle(
                                                                                fontSize: 16.sp,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
