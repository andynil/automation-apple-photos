// Finds and displays a list of all albums for a selected photo in Apple Photos
// This file is a JXA script (JavaScript for Automation)
// Tested on Apple Photos 5.0
// Source: https://github.com/andynil/automation-apple-photos

function run() {
  if (!verifyThatPhotosAppIsRunning()) {
    return;
  }

  var app = getPhotosApp();

  if (!verifyPhotoSelection(app)) {
    return;
  }

  var selectedPhoto = getSelectedPhoto(app);
  var albums = getAlbumsFlattened(app);
  var matchingAlbums = findAlbumsForPhoto(selectedPhoto.id(), albums);
  displayResults(selectedPhoto, matchingAlbums, app);
}

function displayResults(photo, albums, app) {
  if (albums.length) {
    var names = albums.map((album) => {
      var parts = getFullAlbumNameStructure(album);
      var name = parts.join(" > ");
      return " • " + name;
    });

    var text = `Photo ${photo.filename()} sits in these albums\n${names.join(
      "\n"
    )}`;
    app.displayAlert(text);
  } else {
    app.displayAlert("Photo is in no album");
  }
}

function findAlbumsForPhoto(id, albums) {
  var filtered = [];

  for (var j = 0; j < albums.length; j++) {
    var album = albums[j];

    var matches = album.mediaItems.whose({ id: { "=": id } });

    if (matches.length) {
      filtered.push(album);
    }
  }

  return filtered;
}

function verifyPhotoSelection(app) {
  // Apart from "regular" selection of photos, app.selection().length also shows
  // the following behavior:
  // Library > Photos (i.e. all photos) selected: Length is 0
  // Any album selected: Length equals the number of photos in the album

  var selection = app.selection();

  if (selection.length == 1) {
    var selectedPhoto = getSelectedPhoto(app);

    if (selectedPhoto == null) {
      app.displayAlert(
        "Failed to find selected photo.\n\nThis might happen if you select the photo while viewing a Smart Album. Try selecting the photo while in a regular album (e.g right click photo > Add to > New Album)."
      );
      return false;
    }

    return true;
  } else if (selection.length == 0) {
    app.displayAlert("Please select a photo in the Photos app");
    return false;
  } else {
    app.displayAlert("Please select a single photo in the Photos app");
    return false;
  }
}

function getSelectedPhoto(app) {
  try {
    var photo = app.selection()[0];
    photo.id(); // This blows up if selecting photo while in a Smart Album
    return photo;
  } catch (e) {
    return null;
  }
}

function getAlbumsFlattened(app) {
  return findAllAlbums(app);
}

function findAllAlbums(node) {
  //   log(`PROCESSING node: ${node.name()}, it has ${node.folders.length}$ subfolders`);
  var albums = [];

  for (var i = 0; i < node.folders.length; i++) {
    var folder = node.folders[i];

    var subalbums = findAllAlbums(folder);
    albums = albums.concat(subalbums);
  }

  return albums.concat(node.albums());
}

function getFullAlbumNameStructure(album) {
  var parts = [album.name()];

  try {
    while (album.parent) {
      album = album.parent;
      parts.unshift(album.name());
    }
  } catch {
    // No op.
    // Unfortunately I couldn't find a clean way to determine if current node
    // is the topmost node or not (i.e. the 'application object'). The topmost node
    // identifies as a 'folder' class (ObjectSpecifier.classOf), but fails on name()
    // and id().
  }

  return parts;
}

function isPhotosAppRunning() {
  return Application("Photos").running();
}

function verifyThatPhotosAppIsRunning() {
  if (isPhotosAppRunning()) {
    return true;
  }

  var app = Application.currentApplication();
  app.includeStandardAdditions = true;
  app.displayAlert("Photos app is not running");
  return false;
}

function getPhotosApp() {
  var app = Application("Photos");
  app.includeStandardAdditions = true;
  app.activate();
  return app;
}

// Printing
// function logAlbumsToConsole(albums) {
//   var output = [];
//   for (var i = 0; i < albums.length; i++) {
//     var parts = getFullAlbumNameStructure(albums[i]);
//     var name = parts.join(">");
//     output.push(name);
//   }
//   console.log("Found", albums.length, "albums:");
//   console.log(output.join("\n"));
// }

// function log(text) {
//   console.log(text);
// }
