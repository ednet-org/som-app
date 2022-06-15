import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/template_storage/main/utils/AppWidget.dart';
import 'package:som/template_storage/screen/template/DTCategoryDetailScreen.dart';

import '../../../ui/components/MainMenu.dart';

class DTSearchScreen extends StatefulWidget {
  @override
  _DTSearchScreenState createState() => _DTSearchScreenState();
}

class _DTSearchScreenState extends State<DTSearchScreen> {
  var searchCont = TextEditingController();
  List<String> recentSearch = [];
  List<String> trending = [];

  String searchText = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    recentSearch.add('iPhone release date');
    recentSearch.add('basic knowledge of flutter');
    recentSearch.add('Live Score');
    recentSearch.add('Latest Movie');
    recentSearch.add('Latest iPhone');

    trending.add('iPhone release date');
    trending.add('basic knowledge of flutter');
    trending.add('Live Score');
    trending.add('Latest Movie');
    trending.add('Latest iPhone');
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Search'),
      drawer: MainMenu(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchCont,
              style: primaryTextStyle(),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: primaryTextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
                contentPadding: EdgeInsets.all(16),
                prefixIcon: Icon(AntDesign.search1,
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
                labelStyle: secondaryTextStyle(),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer!)),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
              onChanged: (String searchTxt) {
                searchText = searchTxt;
                if (searchTxt == '') {
                  hideKeyboard(context);
                }
                setState(() {});
              },
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Searches', style: primaryTextStyle())
                            .expand(),
                        Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Text(
                            'View All',
                            style: secondaryTextStyle(color: white),
                          ).onTap(() {
                            DTCategoryDetailScreen().launch(context);
                          }),
                        ),
                      ],
                    ),
                    16.height,
                    ListView.builder(
                      itemCount: recentSearch.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: context.width(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.search,
                                      color: white, size: 20),
                                ),
                                Flexible(
                                  child: Text(recentSearch[i],
                                          style: primaryTextStyle(size: 14),
                                          maxLines: 2)
                                      .paddingOnly(left: 8, right: 8),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    16.height,
                    Text(
                      'What\'s Trending',
                      style: primaryTextStyle(
                          color: Theme.of(context).primaryColor),
                    ),
                    16.height,
                    ListView.builder(
                      itemCount: trending.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: context.width(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.trending_up,
                                      color: white, size: 20),
                                ),
                                Flexible(
                                  child: Text(trending[i],
                                          style: primaryTextStyle(size: 14),
                                          maxLines: 2)
                                      .paddingOnly(left: 8, right: 8),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ).visible(searchText == ''),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xffD6D6D6),
                      strokeWidth: 4,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                    ),
                  ),
                ).visible(searchText != ''),
              ],
            )
          ],
        ),
      ),
    );
  }
}
