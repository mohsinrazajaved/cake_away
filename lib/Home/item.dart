import 'package:cached_network_image/cached_network_image.dart';
import 'package:cake_away/Home/timeago.dart';
import 'package:cake_away/models/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemList extends StatelessWidget {
  final Function ontap;
  final Post item;

  ItemList({@required this.item, this.ontap}); //{}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: new Text(
                                item.postOwnerName ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                new Text(
                                  item.title ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(width: 8),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      TimeAgo.timeAgoSinceDate(item.dateTime ?? ""),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Container(
                height: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: item?.imagesUrls?.first ?? "",
                        placeholder: ((context, s) => Center(
                              child: CircularProgressIndicator(),
                            )),
                        errorWidget: (conex, x, _) {
                          return Center(child: Text("No Image"));
                        },
                        width: 125.0,
                        height: 125.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CachedNetworkImage(
            //     imageUrl:
            //         (item['type'] == "Video") ? item['thumburl'] : item['url'],
            //     placeholder: ((context, s) => Center(
            //           child: CircularProgressIndicator(),
            //         )),
            //     width: 125.0,
            //     height: 200.0,
            //     fit: BoxFit.cover,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
