import 'package:app/models/job.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ClientWidget extends StatelessWidget {
  final Job job;
  ClientWidget({this.job});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Material(
            color: MainTrans,
            child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: (job.clientPhotoUrl == '') ||
                                  (job.clientPhotoUrl == null)
                              ? DEFAULT_AVATAR
                              : job.clientPhotoUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                // decoration: BoxDecoration(
                                //     borderRadius:
                                //         BorderRadius.all(Radius.circular(4.0)),
                                //     border:
                                //         Border.all(width: .4, color: MainWhite),
                                //     color: BlackTrans),
                                child: Text(
                                  job.clientName,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(color: MainBlack, fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 4),
                              SmoothStarRating(
                                color: MainYellow,
                                borderColor: MainGrey,
                                isReadOnly: true,
                                rating: 4.0,
                                size: 18,
                                onRated: (rating) => {},
                                spacing: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                onTap: () {}))
      ],
    );
  }
}
