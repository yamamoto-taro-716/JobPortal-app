import 'dart:developer';

import 'package:app/components/iconbutton.dart';
import 'package:app/models/job.dart';
import 'package:app/models/job_categories.dart';
import 'package:app/public/colors.dart';
import 'package:app/public/constants.dart';
import 'package:app/public/strings.dart' as Strings;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

Widget jobCard(Job job, onTap) {
  var borderRadius = BorderRadius.all(Radius.circular(4));

  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    decoration: BoxDecoration(
        // border: Border.all(color: MainBlack),
        borderRadius: borderRadius,
        boxShadow: [
          // BoxShadow(
          //     blurRadius: 2,
          //     color: MainGrey,
          //     offset: Offset(2, 2),
          //     spreadRadius: 0)
        ]),
    child: Material(
        color: MainWhite,
        borderRadius: borderRadius,
        child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Column(children: [
              Expanded(
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: (job.clientPhotoUrl == '') ||
                              (job.clientPhotoUrl == null)
                          ? DEFAULT_AVATAR
                          : job.clientPhotoUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(4)),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Container(
                      color: MainTrans,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(4),
                                    ),
                                    color: MainRed),
                                child: Text(
                                  Strings.budgetRange[job.budgetRange],
                                  style:
                                      TextStyle(color: MainWhite, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: 120),
                                // width: 120,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: borderRadius,
                                    border:
                                        Border.all(width: .4, color: MainWhite),
                                    color: BlackTrans),
                                child: Text(
                                  job.clientName,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(color: MainWhite, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(color: MainWhite, borderRadius: borderRadius),
                child: Column(
                  children: [
                    Container(
                      height: 44,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        job.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: MainBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 8),
                        SmoothStarRating(
                          color: MainYellow,
                          isReadOnly: true,
                          rating: 4.0,
                          size: 18,
                          onRated: (rating) => {},
                          spacing: 0,
                        ),
                        Material(
                            color: MainTrans,
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: MainGrey,
                              ),
                              splashRadius: 20,
                              color: MainBlue,
                              onPressed: () {
                                print('dsf');
                              },
                            ))
                      ],
                    )
                  ],
                ),
              )
            ]))),
  );

  // return Container(
  //     height: 220,
  //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //     child: Stack(
  //       children: [
  //         Container(
  //             child: CachedNetworkImage(
  //           imageUrl: Strings.photoUrl,
  //           imageBuilder: (context, imageProvider) => Container(
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(6)),
  //                 image:
  //                     DecorationImage(image: imageProvider, fit: BoxFit.cover)),
  //           ),
  //           placeholder: (context, url) => CircularProgressIndicator(),
  //           errorWidget: (context, url, error) => Icon(Icons.error),
  //         )),
  //         Container(
  //           width: double.infinity,
  //           margin: EdgeInsets.symmetric(vertical: 4),
  //           child: Text(
  //             job.title,
  //             textAlign: TextAlign.center,
  //             maxLines: 1,
  //             style: TextStyle(
  //                 color: MainBlue, fontSize: 18, fontWeight: FontWeight.bold),
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //         Material(
  //           color: MainTrans,
  //           child: InkWell(
  //             borderRadius: borderRadius,
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(height: 6),
  //                   // Text(
  //                   //   job.description,
  //                   //   textAlign: TextAlign.left,
  //                   //   overflow: TextOverflow.ellipsis,
  //                   //   maxLines: 3,
  //                   // ),
  //                   Expanded(
  //                     child: Row(
  //                       children: [
  //                         Column(
  //                           children: [
  //                             Container(
  //                               child: Column(
  //                                 children: [Text(job.clientName)],
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                         SizedBox(width: 40),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.end,
  //                             children: [
  //                               iconLabel(
  //                                   Icons.category, category, job.typeName),
  //                               iconLabel(Icons.attach_money, budget,
  //                                   budgetRange[job.budgetRange]),
  //                               iconLabel(
  //                                   Icons.calendar_today,
  //                                   deadline,
  //                                   job.deadLine == null
  //                                       ? noDeadline
  //                                       : job.deadLine.toString())
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             onTap: onTap,
  //           ),
  //         ),
  //       ],
  //     ));
}

Widget iconLabel(icon, title, text) {
  return Container(
    margin: EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(icon, color: PureAmber, size: 20),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ]),
        Container(
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 24),
            alignment: Alignment.topLeft,
            child: Text(
              text,
              textAlign: TextAlign.left,
            ))
      ],
    ),
  );
}
