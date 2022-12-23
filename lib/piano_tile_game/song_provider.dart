import 'dart:math';

import 'package:multi_game/piano_tile_game/note.dart';

List<Note> initNotes() {
  List<Note> listNote = [];
  for (var i = 0; i < 500; i++) {
    listNote.add(Note(i, Random().nextInt(5)));
  }
  listNote.add(Note(0, -1));
  listNote.add(Note(0, -1));
  listNote.add(Note(0, -1));
  listNote.add(Note(0, -1));
  return listNote;
}
