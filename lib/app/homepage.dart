import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mysql_notes_app/app/edit_note.dart';
import 'package:mysql_notes_app/components/custom_card.dart';
import 'package:mysql_notes_app/components/custom_form.dart';
import 'package:mysql_notes_app/constants/api_links.dart';
import 'package:mysql_notes_app/main.dart';
import 'package:mysql_notes_app/model/note_model.dart';

import '../services/crud.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Crud {
  bool isLight = false;
  Future getNotes() async {
    var response = await postRequest(
      viewNotesLink,
      {
        "id": sharedPreferences.getString("id"),
      },
    );
    if (response['status'] == "success") {
      setState(() {});

      return response;
    }
  }

  Future deleteNote(noteId, noteImage) async {
    var response = await postRequest(
      deleteNotesLink,
      {"id": noteId, "image": noteImage},
    );
    if (response == "success") {
      Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    }
  }

  @override
  initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLight = !isLight;
                sharedPreferences.setBool("isLight", isLight);
              });
            },
            icon: isLight
                ? const Icon(FontAwesomeIcons.sun)
                : const Icon(FontAwesomeIcons.moon),
          ),
          IconButton(
            onPressed: () {
              sharedPreferences.clear();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", (route) => false);
            },
            icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getNotes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['data'].length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomCard(
                    noteModel: NoteModel.fromJson(snapshot.data['data'][index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNote(
                            notes: snapshot.data['data'][index],
                          ),
                        ),
                      );
                    },
                    onDelete: () async {
                      await deleteNote(
                        snapshot.data['data'][index]['id'],
                        snapshot.data['data'][index]['image'],
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Note is deleted"),
                        ),
                      );
                    },
                  );
                },
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: Text(
                "No Notes",
                style: TextStyle(fontSize: 28),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return const CustomForm(
                formTitle: "Add a new note",
              );
            },
          );
          setState(() {});
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }
}
