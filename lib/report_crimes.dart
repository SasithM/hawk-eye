import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hawk_eye/login.dart';
import 'package:hawk_eye/main.dart';
import 'package:hawk_eye/user_data.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:hawk_eye/drawer_only.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


Map<String, String> multiImages;
var crimeCategory;
String uploadTime;

class ReportCrimes extends StatefulWidget {
  @override
  _ReportCrimesState createState() => _ReportCrimesState();
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Cancelled';
      } else {
        result = 'Failed ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${bytesTransferred(snapshot)} bytes sent');
        } else {
          //subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: () => task.pause()),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                      icon: const Icon(Icons.file_upload),
                      onPressed: () => task.resume()),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () => task.cancel()),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: () => onDownload(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReportCrimesState extends State<ReportCrimes> {

  final TextEditingController _textDescription = new TextEditingController();
  final TextEditingController _textLocation = new TextEditingController();
  final TextEditingController _dateTime = new TextEditingController();

  var now = new DateTime.now();// to get the current time and date when the button is pressed

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  LocalKey _commentKey;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  FileType _pickType = FileType.image;
  String _extension;
  bool _doneButtonEnabled = false;
  bool _addImagesButtonEnabled = true;
  List<String> uploadedImagesList = [];
  Map<String, String> uploadedImagesMap = {};

  List<Widget> children = <Widget>[
    Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(30, 70, 30, 20),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'Your Image Uploads will Appear Here...',
            style: TextStyle(
              fontSize: 11.0,
            ),
          ),
        ))
  ];

  Future<void> loadAssets() async {
    children = [];
    String currentTime = DateTime.now().toString();

    uploadTime = currentTime;

    getUrlBack(String uploadedFileName, StorageUploadTask imageUpload) async {
      print(userName.toString());
      await imageUpload.onComplete;
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('users/$loggedUser/evidence/$currentTime')
          .child(uploadedFileName);
      storageReference.getDownloadURL().then((fileURL) {
        //print('ha ha : $fileURL');
        uploadedImagesList.add(fileURL);
      });
    }

    upload(fileName, filePath) {
      _extension = fileName.toString().split('.').last;
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('users/$loggedUser/evidence/$currentTime')
          .child(fileName);
      final StorageUploadTask uploadTask = storageReference.putFile(
          File(filePath),
          StorageMetadata(
            contentType: '$_pickType/$_extension',
          ));

      getUrlBack(fileName, uploadTask);

      setState(() {
        _tasks.add(uploadTask);
      });
    }

    uploadToFirebase() {
      uploadedImagesList.clear();
      multiImages.forEach((fileName, filePath) => upload(fileName, filePath),);
      _doneButtonEnabled = true;
    }

    try {
      multiImages = await FilePicker.getMultiFilePath(type: _pickType);
      if (multiImages != null) {
        uploadToFirebase();
        _addImagesButtonEnabled = false;
      }
    } on PlatformException catch (e) {
      print('Unsupported Operation ' + e.toString());
    }
    if (!mounted) {
      return;
    }
  }

  Future<void> dataMapCreate() async {
    for(int i = 0; i<uploadedImagesList.length; i++){
      uploadedImagesMap['image${i+1}'] = uploadedImagesList[i].toString();
    }
  }

  downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    //print('Success\nDownloaded $name\nUrl: $url\nPath: $path\nBytes Count: $byteCount');
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.teal,
      content: Image.memory(
        bodyBytes,
        fit: BoxFit.fill,
      ),
      elevation: 50.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          )),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {},
      ),
    ));
  }

  var _crimeKey = new GlobalKey();
  var crimeId;

  void _onCrimeDropItemSelected(String newValueSelected) {
    setState(() {
      this.crimeId = newValueSelected;
      this._crimeKey.currentState;
      crimeCategory = crimeId;
    });
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {

    var _onAddImagesButtonPressed;
    var _onDonePressed;

    //Add Images button press event
    if (_addImagesButtonEnabled) {
      _onAddImagesButtonPressed = () {
        loadAssets();
      };
    }

    if(_textDescription.text.toString() != null){
      _doneButtonEnabled = true;
    }

    if (_doneButtonEnabled) {
      _onDonePressed = () {
        _doneButtonEnabled = false;

        dataMapCreate();

        String tempString = '';
        for (int x = 0; x < uploadedImagesList.length; x++) {
          tempString = tempString + '\n[Image${x + 1} == ${uploadedImagesList[x]}]';
        }

        crimeData[0] = uploadedImagesMap;
        crimeData[1] = crimeId.toString();
        crimeData[2] = _textLocation.text.toString();
        crimeData[3] = _textDescription.text.toString();
        crimeData[4] = _dateTime.text.toString();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Your Response Recorded Successfully'),
        ));

        submitForUser();

        Future.delayed(const Duration(seconds: 3), () {
          int count = 0;
          Navigator.popUntil(
              context,
                  (route) {
                return count++ == 1;
              }
          );
        });
      };
    }

    _tasks.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () {
          setState(() {
            _tasks.remove(task);
          });
        },
        onDownload: () {
          downloadFile(task.lastSnapshot.ref);
        },
      );
      children.add(tile);
    });

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              children: <Widget>[
                ResponsiveContainer(
                    heightPercent: 2.0,
                    widthPercent: 100.0,
                    child: Container(
                      color: Colors.transparent,
                    )), // notch neglect

                ResponsiveContainer(
                  padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                  heightPercent: 4.5,
                  widthPercent: 100.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.blue[700],
                          splashColor: Colors.blueAccent,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          alignment: Alignment.center,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                      Container(
                          color: Colors.transparent,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Report a crime",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),
                            ),
                          )),
                    ],
                  ),
                ), // heading

                ResponsiveContainer(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 4),
                  heightPercent: 5,
                  widthPercent: 100.0,
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      'Provide your evidence',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 13.0
                      ),
                    ),
                  ),
                ), // instruction heading

                ResponsiveContainer(
                    padding: EdgeInsets.fromLTRB(105, 0, 105, 0),
                    heightPercent: 5.1,
                    widthPercent: 35.0,
                    child: RaisedButton(
                      child: Text(
                        'Add Images',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 10.0,
                        ),
                      ),
                      disabledColor: Colors.grey[300],
                      elevation: 10,
                      textColor: Colors.white,
                      color: Colors.blue[600],
                      onPressed: _onAddImagesButtonPressed,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0),
                      ),
                      splashColor: Colors.white,
                    )), // add images button

                ResponsiveContainer(
                  heightPercent: 23.0,
                  widthPercent: 80.0,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ListView(
                    children: children,
                  ),
                ),

                ResponsiveContainer(
                  heightPercent: 13.0,
                  widthPercent: 100.0,
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                  child: DateTimeField(
                    controller: _dateTime,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date & Time',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat'
                      ),
                      helperText: '* required',
                    ),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),
                ),

                ResponsiveContainer(
                  heightPercent: 13.0,
                  widthPercent: 100.0,
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Crime category',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat'
                      ),
                      helperText: '* required',
                    ),
                    value: crimeId,
                    isDense: true,
                    onChanged: (valueSelectedByUser) {
                      _onCrimeDropItemSelected(valueSelectedByUser);
                    },
                    items: <String>['Robberies', 'Murders', 'Hit & Run', 'Sexual Crimes', 'Cyber Crimes', 'Bribery, Corruption']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                ResponsiveContainer(
                  key: _commentKey,
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                  heightPercent: 13.0,
                  widthPercent: 100.0,
                  child: Container(
                      child: TextFormField(
                        toolbarOptions: ToolbarOptions(
                            copy: true, paste: true, cut: true, selectAll: false),
                        controller: _textLocation,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            //hintText: '',
                            helperText: '* required',
                            labelText: 'Location',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontSize: 14.0)),
                        maxLines: 1,
                      )),
                ),// uploaded images appear here

                ResponsiveContainer(
                  key: _commentKey,
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  heightPercent: 20.0,
                  widthPercent: 100.0,
                  child: Container(
                      child: TextFormField(
                        toolbarOptions: ToolbarOptions(
                            copy: true, paste: true, cut: true, selectAll: false),
                        controller: _textDescription,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            //hintText: '',
                            helperText: '* required',
                            labelText: 'Describe the crime in detail',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontSize: 14.0)),
                        maxLines: 5,
                      )),
                ), // text section

                ResponsiveContainer(
                  padding: EdgeInsets.fromLTRB(110, 0, 110, 0),
                  heightPercent: 7.0,
                  widthPercent: 50.0,
                  child: RaisedButton(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 13.0,
                      ),
                    ),
                    disabledColor: Colors.grey[300],
                    elevation: 5,
                    textColor: Colors.black,
                    color: Colors.amber,
                    onPressed: _onDonePressed,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(100.0),
                    ),
                    splashColor: Colors.white,
                  ),
                ), // finalize button
              ],
            ),
          )
        ],
      ),
    );
  }
}
