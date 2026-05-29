let closingWindowId = null;

function sendData() {
  const windows = workspace.stackingOrder;

  let windowData = [];
  const resourceClasses = [];

  let isClosingIdPresent = false;
  for (const window of windows) {
    resourceClasses.push(window.resourceClass);
    if (window.internalId === closingWindowId) isClosingIdPresent = true;
    if (window.normalWindow && window.internalId !== closingWindowId) {
      windowData.push({
        pos: window.pos,
        caption: window.caption,
        minimized: window.minimized,
        internalId: window.internalId,
        xPos: window.frameGeometry.x,
        active: window.active,
        desktopFileName: window.desktopFileName || "",
        resourceClass: window.resourceClass,
      });
    }
    if (!isClosingIdPresent) closingWindowId = null;
  }
  closingWindowId = null;
  callDBus(
    "dev.hunterwhite.pager",
    "/change",
    "dev.hunterwhite.pager",
    "pass",
    JSON.stringify({ data: windowData }),
  );

  print("pager-resource-classes: ", JSON.stringify(resourceClasses));
}

function windowAdded(window) {
  print("window added");
  window.frameGeometryChanged.connect(sendData);
  // window.windowShown.connect(sendData);
  // window.windowHidden.connect(sendData);
}

function windowRemoved(window) {
  print("removing window", window.internalId);
  closingWindowId = window.internalId;
  print(closingWindowId);

  window.frameGeometryChanged.disconnect(sendData);

  callDBus(
    "dev.hunterwhite.pager",
    "/change",
    "dev.hunterwhite.pager",
    "close",
    JSON.stringify({ id: window.internalId }),
  );

  // window.windowShown.disconnect(sendData);
  // window.windowHidden.disconnect(sendData);
  // sendData();
}

//Workspace signals
workspace.windowAdded.connect(windowAdded);
workspace.windowActivated.connect(sendData);
workspace.windowRemoved.connect(windowRemoved);

for (const window of workspace.stackingOrder) {
  window.frameGeometryChanged.disconnect(sendData);
  window.frameGeometryChanged.connect(sendData);
}
