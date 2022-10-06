import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:cortex_library_mobile_app/theme/palette.dart';
import 'package:cortex_library_mobile_app/theme/textTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookScreen extends StatefulWidget {
  final book;
  final category;
  final authToken;
  const BookScreen({
    super.key,
    required this.book,
    required this.category,
    required this.authToken,
  });

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  bool isSuccessful = false;
  void reserveBook() async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${widget.authToken}'
    };
    var request = http.Request(
      'POST',
      Uri.parse(
        'https://intheloop.pro/api/books/${widget.book['id']}/reserve',
      ),
    );
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isSuccessful = true;
      setState(() {});
    } else {
      isSuccessful = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Random rng = new Random();
    int rand = rng.nextInt(6);
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 32.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 28.h),
              //About
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 120.w,
                      height: 170.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '${widget.book['cover']}',
                          ),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.r),
                        ),
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      height: 170.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.book['title'],
                            style: subheaderTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${widget.book['authors'][0]['name']} ${widget.book['authors'][0]['surname']} ...',
                            style: bodyTextStyle,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${widget.category}',
                            style: bodyTextStyle,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.star_fill,
                                  color: Colors.yellow),
                              SizedBox(width: 4.w),
                              Text(
                                '$rand',
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    reserveBook();

                    if (isSuccessful) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Uspješno ste rezervisali knjigu.'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                              'Upsss... Došlo je do greške. Pokušajte ponovo.'),
                        ),
                      );
                    }
                  },
                  child: Text('Rezervišite'),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: bodyTextStyle,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
