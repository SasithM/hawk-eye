import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawk_eye/login.dart';
import 'package:hawk_eye/main.dart';
import 'package:hawk_eye/showInfo.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:responsive_container/responsive_container.dart';

class SelectedCrimeDetails extends StatefulWidget {
  @override
  _SelectedCrimeDetailsState createState() => _SelectedCrimeDetailsState();
}

class _SelectedCrimeDetailsState extends State<SelectedCrimeDetails> {

  var userDocument;
  var imageList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('user')
          .document(loggedUser)
          .collection('crimes')
          .document(selectedCrimeId)
          .snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          userDocument = snapshot.data;

          var dateTime = userDocument['time'].toString();
          var date = List.from(dateTime.split(new RegExp(r"[.: ]")));

          imageList = new List(userDocument['images'].length);
          for(int y = 0; y<imageList.length; y++){
            imageList[y] = y+1;
          }
          List<NetworkImage> evidenceImagesList = List<NetworkImage>(imageList.length);
          for(int i= 0; i<imageList.length; i++){
            evidenceImagesList[i] = NetworkImage(userDocument['images']['image${i+1}']);
          }
          return new Scaffold(
            backgroundColor: Colors.grey[200],
            body: Stack(
              children: <Widget>[
                Center(
                  child: ListView(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ResponsiveContainer(
                            heightPercent: 1.0,
                            widthPercent: 100,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),

                          ResponsiveContainer(
                              heightPercent: 6,
                              widthPercent: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.transparent,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        color: Colors.blue[900],
                                        splashColor: Colors.blueAccent,
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        alignment: Alignment.center,
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        color: Colors.transparent,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          alignment: Alignment.centerLeft,
                                          child: Text('${userDocument['location']}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 30,
                                            ), //style
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              )
                          ),

                          ResponsiveContainer(
                            heightPercent: 4,
                            widthPercent: 75,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 8),
                                color: Colors.transparent,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${date[0]} at ${date[1]}:${date[2]}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ), //style
                                    textAlign: TextAlign.left,
                                  ),
                                )
                            ),
                          ),

                          ResponsiveContainer(
                            heightPercent: 50,
                            widthPercent: 100,
                            child: Scrollbar(
                              child: PhotoViewGallery.builder(
                                scrollPhysics: const BouncingScrollPhysics(),
                                builder: (BuildContext context, index) {
                                  return PhotoViewGalleryPageOptions(
                                    //controller: ,
                                    imageProvider: evidenceImagesList[index],
                                    minScale: PhotoViewComputedScale.contained * 0.9,
                                    maxScale: PhotoViewComputedScale.covered * 2,
                                  );
                                },
                                itemCount: evidenceImagesList.length,
                                loadingBuilder: (context, event) => Center(
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                                    ),
                                  ),
                                ),
                                backgroundDecoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                          ),

                          ResponsiveContainer(
                            heightPercent: 5.0,
                            widthPercent: 80.0,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                "More Information",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          ResponsiveContainer(
                            heightPercent: 30.0,
                            widthPercent: 90.0,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                userDocument['details'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }else{
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                      'Something Went Wrong...'
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
