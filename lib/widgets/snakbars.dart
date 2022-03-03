import 'package:flutter/material.dart';

class SnackBars {

  final excistingPlaylist = SnackBar(
    content: Text(
      'Excisting playlist name',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
  final excistingSong = SnackBar(
    content: Text(
      'Song already exists',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
  final songAdded = SnackBar(
    content: Text(
      'Song added to Playlist',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
    final likedAdd = SnackBar(
    content: Text(
      'Song added to Favorites',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
      final likedRemove = SnackBar(
    content: Text(
      'Song removed from Favorites',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
  
}