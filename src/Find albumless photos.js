// Apple Photos script. Finds all photos that are not in an album.
// This file is a JXA script (JavaScript for Automation)
// Tested on Apple Photos 5.0
// Source: https://github.com/andynil/automation-apple-photos

function run() {
  if (!verifyThatPhotosAppIsRunning()) {
    return;
  }

  var newAlbumNameForAlbumlessPhotos = "ALBUMLESS";

  var app = getPhotosApp();
  app.displayAlert(`This script will scan through Apple Photos for photos NOT in an album. This might take some time.\n
The identified photos will be added to a new album ${newAlbumNameForAlbumlessPhotos}, or a variant of that name if it exists already.`);

  findAlbumlessPhotos(newAlbumNameForAlbumlessPhotos);
}

function findAlbumlessPhotos(targetAlbumName) {
  var app = getPhotosApp();
  var albums = getAllAlbumsAsFlatList(app);
  var albumlessIds = getAlbumlessPhotoIds(app, albums);

  if (albumlessIds.length === 0) {
    app.displayAlert(
      "No albumless photos found. Seems like all photos are in one or more albums."
    );
    return;
  }

  var albumlessPhotos = getPhotoObjectSpecifiers(app, albumlessIds);
  var targetAlbum = getNewAlbumWithUniqueName(app, targetAlbumName, albums);
  app.add(albumlessPhotos, { to: targetAlbum });
  app.displayAlert(
    `Added ${albumlessPhotos.length} photo(s) to album ${targetAlbum.name()}`
  );
}

function getNewAlbumWithUniqueName(app, nameWish, albums) {
  var nameToTry = nameWish;
  var counter = 0;

  do {
    var targetAlbum = findAlbumByName(nameToTry, albums);

    if (!targetAlbum) {
      return createAlbum(app, nameToTry);
    }

    counter++;
    nameToTry = `${nameWish}-${counter}`;
  } while (true);
}

function getAlbumlessPhotoIds(app, albums) {
  var allPhotoIds = app.mediaItems.id();
  var albumedPhotoIds = getPhotoIdsInAlbums(albums);
  return allPhotoIds.filter((id) => !albumedPhotoIds.has(id));
}

function getPhotoIdsInAlbums(albums) {
  var set = new Set();

  for (var i = 0; i < albums.length; i++) {
    var ids = albums[i].mediaItems.id();
    ids.forEach((id) => {
      set.add(id);
    });
  }

  return set;
}

function getPhotoObjectSpecifiers(app, ids) {
  var result = [];

  for (var i = 0; i < ids.length; i++) {
    var photoId = ids[i];
    var photo = app.mediaItems.byId(photoId);
    result.push(photo);
  }

  return result;
}

function findAlbumByName(name, albums) {
  var result = albums.filter((album) => album.name() == name);
  return 0 < result.length ? result[0] : null;
}

function createAlbum(app, name) {
  return app.make({ new: "album", named: name });
}

function getAllAlbumsAsFlatList(node) {
  var albums = [];

  for (var i = 0; i < node.folders.length; i++) {
    var folder = node.folders[i];
    var subalbums = getAllAlbumsAsFlatList(folder);
    albums = albums.concat(subalbums);
  }

  return albums.concat(node.albums());
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
