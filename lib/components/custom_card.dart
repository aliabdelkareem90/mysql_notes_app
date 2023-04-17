import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mysql_notes_app/constants/api_links.dart';
import 'package:mysql_notes_app/model/note_model.dart';

class CustomCard extends StatelessWidget {
  final NoteModel noteModel;
  void Function()? onTap;
  void Function()? onDelete;

  CustomCard({
    Key? key,
    required this.noteModel,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('$imageRootLink/${noteModel.image}');
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                '$imageRootLink/${noteModel.image}',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    "${noteModel.title}",
                    style: const TextStyle(fontSize: 19.0),
                  ),
                  subtitle: Text(
                    "${noteModel.content}",
                    style: const TextStyle(
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      FontAwesomeIcons.trashCan,
                      color: Colors.red,
                      size: 19,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
