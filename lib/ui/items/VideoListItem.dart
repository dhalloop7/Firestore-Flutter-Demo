import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelivaato/ui/screens/Player.dart';

class VideoListItem extends StatelessWidget {
  DocumentSnapshot document;

  VideoListItem(DocumentSnapshot document) {
    this.document = document;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.passthrough,
      children: <Widget>[
        Container(
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
//                              child: Image.network(document['image'],
//                                  fit: BoxFit.cover),
              child: CachedNetworkImage(
                fadeInCurve: ElasticInOutCurve(0.5),
                imageUrl: document['image'],
                fit: BoxFit.cover,
              ),
              elevation: 5.0,
              clipBehavior: Clip.antiAlias),
          margin: EdgeInsets.fromLTRB(6.0, 5.0, 6.0, 5.0),
          height: 190.0,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 25.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0)),
//                                color: Color.fromRGBO(239, 83, 80, 0.9)
                color: Color(0xffE46433).withAlpha(200)),
            child: FlatButton.icon(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  openPlayer(document, context);
                },
                icon: Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 25.0,
                ),
                label: Text('Play',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w500))),
          ),
        )
      ],
    );
  }

  void openPlayer(DocumentSnapshot document, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Player(videoUrl: document)));
  }
}
