import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maldini_mobileapps/configs/url_list.dart';
import 'package:maldini_mobileapps/http_parser/http_parser.dart';
import 'package:maldini_mobileapps/models/product.dart';
import 'package:maldini_mobileapps/views/product_add.dart';
import 'package:maldini_mobileapps/views/product_update.dart';

class CrudPage extends StatefulWidget {
  final List<Product?> products;
  const CrudPage({super.key, required this.products});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Makanan"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProductAddPage()));
              },
              icon: const Icon(
                Icons.add,
              ))
        ],
      ),
      body: (loading)
          ? const Center(
              child: SpinKitFadingCircle(
                color: Colors.amberAccent,
              ),
            )
          : ListView(
              children: List.generate(
                  widget.products.length,
                  (index) => ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductUpdatePage(
                                    product: widget.products[index]!,
                                  )));
                        },
                        leading: Image.network(
                          "${widget.products[index]?.picture}",
                          width: 30.w,
                          height: 30.w,
                          fit: BoxFit.cover,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${widget.products[index]?.name}"),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content:
                                              Text("Hapus data makanan ini?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  final parser = HttpParser();
                                                  await parser
                                                      .httpDelete(UrlList
                                                              .deleteProduct +
                                                          widget
                                                              .products[index]!
                                                              .id
                                                              .toString())
                                                      .then((value) {
                                                    setState(() {
                                                      widget.products
                                                          .removeAt(index);
                                                    });
                                                    Navigator.of(context).pop();
                                                  }).whenComplete(() {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  });
                                                },
                                                child: Text("Ya")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Tidak")),
                                          ],
                                        ));
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30.sp,
                              ),
                            )
                          ],
                        ),
                      )),
            ),
    );
  }
}
