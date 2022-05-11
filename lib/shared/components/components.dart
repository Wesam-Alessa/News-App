import 'package:flutter/material.dart';
import 'package:news/modules/web_view/web_view_screen.dart';
import 'package:news/shared/conditinalBuilder/conditinalBuilder.dart';

Widget buildArticleItem(item, context) => InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => WebViewScreen(item['url'])));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/images/loading.gif'),
                image: NetworkImage(
                    '${item['urlToImage'] ?? 'https://www.just.edu.jo/Units_and_offices/Offices/IRO/PublishingImages/Pages/HowToApplyStuffweek/preview.gif'}'),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${item['title']}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${item['publishedAt']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget articleBuilder(list, len, context,{isSearch=false}) {
  var long = 0;
  if (len >= 10) {
    long = 10;
  } else {
    long = len;
  }
  return ConditionalBuilder(
    condition: list.length > 0,
    builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 1.0,
                color: Colors.grey,
              ),
            ),
        itemCount: long),
    fallback: (context) => Center(
      child: isSearch?Container():CircularProgressIndicator(),
    ),
  );
}
