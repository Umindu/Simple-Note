import 'package:flutter/material.dart';
import 'package:note/db/notes_database.dart';
import 'package:note/main.dart';
import 'package:note/model/note.dart';
import 'package:note/widget/note_form_widget.dart';
import 'package:note/page/home_page.dart';
import 'package:image_picker/image_picker.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              if (title.isEmpty || description.isEmpty) {
                Navigator.of(context).pop();
              } else {
                showSaveWidget(context);
              }
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.book_rounded,
              ),
            ),
            IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.attach_file_sharp,
              ),
            ),
            PopupMenuButton<int>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Share"),
                ),
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Save"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Delete"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Background colour"),
                ),
              ],
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.save_alt_sharp),
          label: Text("Save"),
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () async {
            if (title.length == 0 && description.length == 0) {
              showEmptyTitleDialog(context);
            } else {
              addOrUpdateNote();
            }
          },
        ),
      );

  showSaveWidget(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      title: Text(
        "Save Changes?",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Text(
        "New file has been modified, save changes?",
        style: Theme.of(context).textTheme.subtitle1,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        TextButton(
          onPressed: () {
            addOrUpdateNote();
            Navigator.of(context).pop();
          },
          child: Text(
            "Save",
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

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}

void showEmptyTitleDialog(BuildContext context) {
  print("in dialog ");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text(
          "Notes is empty!",
          style: Theme.of(context).textTheme.headline6,
        ),
        content: Text(
          'The content of the note cannot be empty to be saved.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Okay",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      break;

    case 1:
      break;

    case 2:
      break;

    case 3:
      break;
  }
}
