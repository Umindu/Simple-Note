import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note/db/notes_database.dart';
import 'package:note/model/note.dart';
import 'package:note/page/edit_note_page.dart';
import 'package:note/page/note_detail_page.dart';
import 'package:note/widget/note_card_widget.dart';
import 'package:note/settings/theme.dart';
import 'package:note/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note/main.dart';

bool isGrid = false;
var Notescounts;

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(),
              ListTile(
                contentPadding:
                    EdgeInsets.only(left: 250.0, right: 0.0, top: 0),
                leading: Icon(
                  Icons.settings,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Setting()),
                  );
                  refreshNotes();
                },
              ),
              ListTile(),
              ListTile(
                title:
                    Text('All notes                           $Notescounts '),
                leading: Icon(Icons.my_library_books),
                onTap: () {
                  NotesPage();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Starred'),
                leading: Icon(Icons.star),
                onTap: () {
                  print("");
                },
              ),
              ListTile(
                title: Text('Recent'),
                leading: Icon(Icons.timer),
                onTap: () {
                  print("Clicked");
                },
              ),
              ListTile(
                title: Text('Offline'),
                leading: Icon(Icons.offline_pin),
                onTap: () {
                  print("Clicked");
                },
              ),
              ListTile(
                title: Text('Uploads'),
                leading: Icon(Icons.file_upload),
                onTap: () {
                  print("Clicked");
                },
              ),
              ListTile(
                title: Text('Backups'),
                leading: Icon(Icons.backup),
                onTap: () {
                  print("Clicked");
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          title: const Text('Notes',
              style: TextStyle(fontSize: 32, color: Colors.deepOrangeAccent),
              textAlign: TextAlign.center),
          leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                  Notescounts = notes.length;
                  refreshNotes();
                }),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                // Notescounts= notes.length; refreshNotes();
              },
              icon: const Icon(
                Icons.search_sharp,
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
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 50.0,
                  ),
                  value: 0,
                  child: Text("Edit"),
                ),
                const PopupMenuItem<int>(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 50.0,
                  ),
                  value: 1,
                  child: Text("View"),
                ),
                const PopupMenuItem<int>(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 50.0,
                  ),
                  value: 2,
                  child: Text("Short by"),
                ),
                const PopupMenuItem<int>(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 50.0,
                  ),
                  value: 3,
                  child: Text("Settings"),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'No Notes',
                      style: TextStyle(fontSize: 20),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Add Note"),
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  ///view list and grid change...............................
  @override
  _savebool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isGrid", isGrid);
  }

  ///..........................................................

  Widget buildNotes() => isGrid
      ? ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));
                refreshNotes();
              },
              child: NoteCardWidgetList(note: note, index: index),
            );
          },
        )
      : StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(8),
          itemCount: notes.length,
          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemBuilder: (context, index) {
            final note = notes[index];
            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));
                refreshNotes();
              },
              child: NoteCardWidget(note: note, index: index),
            );
          },
        );

  ///menu popup button........................................................

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;

      case 1:
        simple();
        break;

      case 2:
        break;

      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Setting()),
        );
        break;
    }
  }

  /// view change simple box.......................................................

  Future<void> simple() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            alignment: Alignment.topRight,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: 30.0,
                ),
                leading: const Icon(Icons.list_sharp),
                title: const Text(
                  "List View",
                ),
                onTap: () {
                  isGrid = true;
                  _savebool();
                  refreshNotes();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: 30.0,
                ),
                leading: const Icon(Icons.grid_on_sharp),
                title: const Text("Grid View"),
                onTap: () {
                  isGrid = false;
                  _savebool();
                  refreshNotes();
                  Navigator.of(context).pop();
                },
              ),
            ],
            elevation: 10,
          );
        })) {
      case 'List':
        break;
      case "Grid":
        break;
      case null:
        break;
    }
  }
}
