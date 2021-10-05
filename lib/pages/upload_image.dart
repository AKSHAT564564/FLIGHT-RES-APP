import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PickImage extends StatefulWidget {
  final email;
  const PickImage({Key? key, required this.email}) : super(key: key);

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  bool showSpinner = false;
  File? file;
  UploadTask? task;
  String urlDownload = '';

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path!);
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    try {
      final fileName = basename(file!.path);
      final destination = 'files/$fileName';
      final ref = FirebaseStorage.instance.ref(destination);
      task = ref.putFile(file!);
    } on FirebaseException catch (e) {
      task = null;
    }

    if (task == null) return;

    final snapshot = await task!.whenComplete(() => {});
    urlDownload = await snapshot.ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection('userData')
        .doc(widget.email)
        .update({"profilePic": urlDownload});
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      selectFile();
                    },
                    child: Text('Select Image'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      await uploadFile();
                      Navigator.pop(context,true);
                    },
                    child: Text('Upload Image'),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
