import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql_notes_app/components/choosing_image_bottomsheet.dart';
import 'package:mysql_notes_app/constants/api_links.dart';

import '../main.dart';
import '../services/crud.dart';
import 'custom_icon_button.dart';
import 'custom_textfield.dart';

class CustomForm extends StatefulWidget {
  final String formTitle;
  const CustomForm({Key? key, required this.formTitle}) : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> with Crud {
  TextEditingController tController = TextEditingController();
  TextEditingController cController = TextEditingController();

  static final GlobalKey<FormState> _globalKey = GlobalKey();

  String? title, content;
  File? file;

  addNote() async {
    if (file == null) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image is requeired"),
        ),
      );
    }

    if (_globalKey.currentState!.validate()) {
      // _globalKey.currentState!.save();
      var response = await postFileRequest(
        addNotesLink,
        {
          "title": tController.text.toString(),
          "content": cController.text.toString(),
          "id": sharedPreferences.getString("id"),
        },
        file!,
      );

      if (response['status'] == 'success') {
        Navigator.pop(context);
        setState(() {});
        return response;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 22,
                ),
                Center(
                    child: Text(
                  widget.formTitle,
                  style: const TextStyle(fontSize: 24),
                )),
                const SizedBox(
                  height: 22.0,
                ),
                CustomTextField(
                  label: "Title",
                  textInputAction: TextInputAction.next,
                  controller: tController,
                  validator: (val) {},
                  onSaved: (val) => title = val!,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                CustomTextField(
                  label: "Content",
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  controller: cController,
                  validator: (val) {},
                  onSaved: (val) => content = val!,
                ),
                const SizedBox(
                  height: 22.0,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () async {

                        await addNote();
                        print("add");
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Add Note",
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
