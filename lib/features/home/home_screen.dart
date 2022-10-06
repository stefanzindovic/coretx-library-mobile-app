import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../theme/palette.dart';
import '../../theme/textTheme.dart';
import '../book/book_screen.dart';

class HomeScreen extends StatefulWidget {
  final String authToken;
  const HomeScreen({super.key, required this.authToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userName;
  var books;
  var categories;

  void getUserName() async {
    print(widget.authToken);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${widget.authToken}'
    };
    var request = http.Request(
      'POST',
      Uri.parse(
        'https://intheloop.pro/api/users/me',
      ),
    );
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decoded = jsonDecode(await response.stream.bytesToString());
      userName = decoded['data']['name'];
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  void getAllCategories() async {
    print(widget.authToken);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${widget.authToken}'
    };
    var request = http.Request(
      'GET',
      Uri.parse(
        'https://intheloop.pro/api/categories',
      ),
    );
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decoded = jsonDecode(await response.stream.bytesToString());
      categories = decoded['data'];
      print("TEST: ${decoded}");
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  void getBooks() async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${widget.authToken}'
    };
    var request = http.Request(
      'GET',
      Uri.parse(
        'https://intheloop.pro/api/books',
      ),
    );
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decoded = jsonDecode(await response.stream.bytesToString());
      books = decoded['data'];
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    getUserName();
    getBooks();
    getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 28.w),
        child: (userName == null || books == null)
            ? Center(child: CircularProgressIndicator(color: lightColor))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 64.h),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Zdravo, ${userName}',
                        textAlign: TextAlign.center,
                        style: subheaderTextStyle,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          for (int i = 0; i < categories.length; i++)
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 90.w,
                                      height: 90.h,
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.r),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            categories[i]['photo'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                      width: 90.w,
                                      child: Text(
                                        categories[i]['name'],
                                        style: bodyTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16.w),
                              ],
                            ),
                        ],
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                    SizedBox(height: 32.h),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < books.length; i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.h),
                                Text(
                                  books[i]['category'],
                                  style: subheaderTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 8.h),
                                SingleChildScrollView(
                                  child: (books[i]['books'].length > 0)
                                      ? Row(
                                          children: [
                                            for (int j = 0;
                                                j < books[i]['books'].length;
                                                j++)
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              BookScreen(
                                                            book: books[i]
                                                                ['books'][j],
                                                            category: books[i]
                                                                ['category'],
                                                            authToken: widget
                                                                .authToken,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 160.w,
                                                          height: 210.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                secondaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  12.r),
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                books[i][
                                                                        'books']
                                                                    [
                                                                    j]['cover'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 16.h),
                                                        SizedBox(
                                                          width: 160.w,
                                                          child: Text(
                                                            books[i]['books'][j]
                                                                ['title'],
                                                            style:
                                                                subheaderTextStyle,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                        Row(children: [
                                                          Text(
                                                            "${books[i]["books"][j]["authors"][0]['name']} ${books[i]["books"][j]["authors"][0]['surname']} ...",
                                                            style:
                                                                bodyTextStyle,
                                                          )
                                                        ]),
                                                        SizedBox(height: 32.h),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 16.w),
                                                ],
                                              )
                                          ],
                                        )
                                      : Text('Nema knjiga.',
                                          style: bodyTextStyle),
                                  scrollDirection: Axis.horizontal,
                                ),
                                SizedBox(height: 32.h),
                              ],
                            ),
                          SizedBox(width: 16.w),
                        ],
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
