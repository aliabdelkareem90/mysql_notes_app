import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql_notes_app/components/custom_textfield.dart';
import 'package:mysql_notes_app/services/crud.dart';

import '../components/custom_icon_button.dart';
import '../constants/api_links.dart';
import '../main.dart';

class EditNote extends StatefulWidget {
  final notes;
  const EditNote({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> with Crud {
  final GlobalKey<FormState> _key = GlobalKey();

  var tController = TextEditingController();
  var cController = TextEditingController();

  File? file;

  Future editNote() async {
    if (_key.currentState!.validate()) {
      // debugPrint(widget.notes['image'].toString(),);
      var response;
      if (file == null) {
        response = await postRequest(editNotesLink, {
          "title": tController.text,
          "content": cController.text,
          "id": widget.notes['id'].toString(),
          "imagename" : widget.notes['image'].toString(),
        });
      } else {
        response = await postFileRequest(
          editNotesLink,
          {
            "title": tController.text,
            "content": cController.text,
            "id": widget.notes['id'].toString(),
            "imagename" : widget.notes['image'].toString(),
          },
          file!,
        );
      }
      if (response["status"] == "success") {
        Navigator.of(context).pushReplacementNamed("/");
      }
    }
  }

  @override
  void initState() {
    tController.text = widget.notes['title'];
    cController.text = widget.notes['content'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit note"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _key,
            child: ListView(
              children: [
                CustomTextField(
                  textInputAction: TextInputAction.next,
                  controller: tController,
                  validator: null,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextField(
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  controller: cController,
                  validator: null,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: 150,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomIconButton(
                                    onPressed: () async {
                                      XFile? xFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);
                                      Navigator.pop(context);
                                      file = File(xFile!.path);
                                      setState(() {});
                                    },
                                    text: "Camera",
                                    iconData: Icons.camera_alt,
                                  ),
                                  CustomIconButton(
                                    onPressed: () async {
                                      XFile? xFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      Navigator.pop(context);
                                      file = File(xFile!.path);
                                      setState(() {});
                                    },
                                    text: "Gallery",
                                    iconData: Icons.image,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            file == null ? Colors.white : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        file == null ? "Choose an image" : "Image uploaded ✓",
                        style: TextStyle(
                          fontSize: 22.0,
                          color: file == null ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Container(
                  height: 60,
                  width: double.maxFinite,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await editNote();
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
