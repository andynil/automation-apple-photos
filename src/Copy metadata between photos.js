// Copies metadata between two photos in Apple Photos
// This file is a JXA script (JavaScript for Automation)
// Tested on Apple Photos 5.0
// Source: https://github.com/andynil/automation-apple-photos

function run() {
  if (!verifyThatPhotosAppIsRunning()) {
    return;
  }

  copyMetadata();
}

function copyMetadata() {
  var app = getPhotosApp();
  var selection = app.selection();

  if (selection.length != 2) {
    app.displayAlert("Select exactly two photos");
    return;
  }

  var source = selection[0];
  var target = selection[1];

  try {
    var props = source.properties();
    var targetProps = target.properties();

    var text = buildCopyFromToDialogText(props, targetProps);

    if (!displayDialog(app, text)) {
      return;
    }

    if (props.name) target.name = props.name;
    if (props.description) target.description = props.description;
    if (props.date) target.date = props.date;
    if (props.location) target.location = props.location;
  } catch {
    app.displayAlert(
      "Failed to copy (some or all) metadata.\n\nThis might happen if you run this script while viewing a Smart Album. Try running the script while viewing a regular album."
    );
  }
}

function displayDialog(app, text) {
  try {
    app.displayDialog(text);
    return true;
  } catch {
    return false;
  }
}

function getDescription(props) {
  return `	Date: ${props.date}
	Title: ${props.name}
	Description: ${props.description}
	Location: ${props.location}`;
}

function buildCopyFromToDialogText(sourceProps, targetProps) {
  return `Will copy (non-null) values

FROM ${sourceProps.filename}:
${getDescription(sourceProps)}

TO ${targetProps.filename} (will be overwritten):
${getDescription(targetProps)}
`;
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
