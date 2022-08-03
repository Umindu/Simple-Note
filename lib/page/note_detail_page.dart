import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/db/notes_database.dart';
import 'package:note/model/note.dart';
import 'package:note/page/edit_note_page.dart';
import 'package:note/settings/theme.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [editButton(), deleteButton()],
            elevation: 0),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      (DateFormat.yMMMd().add_jm().format(note.createdTime)),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      note.description,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(
        Icons.edit_outlined,
      ),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
      icon: Icon(
        Icons.delete,
      ),
      onPressed: () async {
        showDeleteWidget(context);
      });

  showDeleteWidget(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      title: Text(
        "Confirm Delete",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Text(
        "Are you sure want to delete this note?",
        style: Theme.of(context).textTheme.subtitle1,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        TextButton(
          onPressed: () {
            NotesDatabase.instance.delete(widget.noteId);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            "Delete",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
