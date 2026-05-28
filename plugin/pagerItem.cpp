#include "pagerItem.h"
#include "DBusService.h"
#include "cJSON.h"
#include <KConfig>
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDebug>
#include <QObject>
#include <QRandomGenerator>
#include <QString>
#include <bits/stdc++.h>
#include <cstdlib>
#include <kconfig.h>
#include <qcontainerfwd.h>
#include <qdbusconnection.h>
#include <qlist.h>
#include <qlogging.h>
#include <qmap.h>
#include <qmath.h>
#include <qobject.h>
#include <qobjectdefs.h>
#include <qtmetamacros.h>
#include <string>
#include <unistd.h>

using namespace std;
using namespace chrono;

bool compareByXpos(const Window &a, const Window &b) {
  return a.xPos <= b.xPos;
}

PagerItem::PagerItem(QObject *parent)
    : QObject(parent), dbusSuccess(false), isClosing(false),
      dbusService(parent) {

  QObject::connect(&dbusService, &DBusService::dataPassed, this,
                   &PagerItem::handlePassedData);

  QObject::connect(&dbusService, &DBusService::handleClose, this,
                   &PagerItem::handleClose);

  previousActiveIndex = 0;
  QList<Window> list;
  previousWindows = list;

  registerDBusService();
  checkScript();
}

void PagerItem::registerDBusService() {
  auto sessionBus = QDBusConnection::sessionBus();
  sessionBus.registerService(QString::fromStdString(SERVICE_NAME));

  dbusSuccess = false;

  if (sessionBus.registerObject(QString::fromStdString("/change"),
                                QString::fromStdString(SERVICE_NAME),
                                &dbusService,
                                QDBusConnection::ExportAllSlots)) {
    dbusSuccess = true;
  }

  if (dbusSuccess) {

    qDebug() << "dbus working!!";
  }
}

PagerItem::~PagerItem() = default;

void PagerItem::checkScript() {

  std::string username = getenv("USER");

  std::string cmd = "qdbus org.kde.KWin /Scripting "
                    "org.kde.kwin.Scripting.isScriptLoaded /home/";
  cmd += username;
  cmd += "/.local/share/window-pager/dbus-script.js";

  std::array<char, 128> buffer;
  std::string result;
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(&cmd[0], "r"), pclose);
  while (fgets(buffer.data(), static_cast<int>(buffer.size()), pipe.get()) !=
         nullptr) {
    result += buffer.data();
  }
  result = result.substr(0, result.size() - 1);
  qDebug() << "result";
  qDebug() << result;

  // We need to load the script
  //
  if (result == "false") {
    qDebug() << "Result is false";
    std::string cmd = "qdbus org.kde.KWin /Scripting "
                      "org.kde.kwin.Scripting.loadScript /home/";
    cmd += username;
    cmd += "/.local/share/window-pager/dbus-script.js";

    system(&cmd[0]);
  } else {
    qDebug() << "result is true";
  }
}

void PagerItem::handlePassedData(QString data) {
  if (isClosing)
    return;

  KConfig config;
  // KConfigGroup configGroup =
  //     config.group(QString::fromStdString("dev.hunterwhite.pager"));

  qDebug() << "Got data";

  string dataStdString = data.toStdString();
  // Parse raw data
  cJSON *json = cJSON_Parse(&dataStdString[0]);
  // get windowData array in "data" field
  cJSON *windowData = cJSON_GetObjectItem(json, "data");

  // Store the current iteration
  cJSON *window;

  QList<Window> windows;
  QList<int> indexes;

  int counter = 0;
  cJSON_ArrayForEach(window, windowData) {
    cJSON *internalId = cJSON_GetObjectItem(window, "internalId");
    cJSON *minimized = cJSON_GetObjectItem(window, "minimized");
    cJSON *xPos = cJSON_GetObjectItem(window, "xPos");
    cJSON *active = cJSON_GetObjectItem(window, "active");
    cJSON *desktopFileName = cJSON_GetObjectItem(window, "desktopFileName");

    string internalIdString = internalId->valuestring;
    bool minimizedBool = cJSON_IsTrue(minimized);
    double xPosDouble = xPos->valuedouble;
    bool activeBool = cJSON_IsTrue(active);
    string desktopFileNameString = desktopFileName->valuestring;

    indexes.push_back(counter);

    Window window{"",
                  minimizedBool,
                  internalIdString,
                  xPosDouble,
                  activeBool,
                  QString::fromStdString(desktopFileNameString)};

    windows.push_back(window);

    counter++;
  }

  std::sort(windows.begin(), windows.end(), compareByXpos);

  int activeIndex = -1;
  int sortedCounter = 0;

  QList<QString> desktopFileNames;
  QList<double> xPositions;

  bool willEmit = false;

  if (previousWindows.size() == 0)
    previousWindows = windows;

  if (previousWindows.size() != windows.size()) {
    willEmit = true;
  }

  for (Window window : windows) {
    if (window.active)
      activeIndex = sortedCounter;

    desktopFileNames.push_back(window.desktopFileName);
    xPositions.push_back(window.xPos);
    qDebug() << window.desktopFileName << " " << window.xPos;

    sortedCounter++;
  }

  // if activeIndex changes we know we immedietely need to update
  if (activeIndex != previousActiveIndex) {
    willEmit = true;
  }
  previousWindows = windows;
  previousActiveIndex = activeIndex;

  if (willEmit) {
    Q_EMIT update(activeIndex, indexes, desktopFileNames, xPositions);
  }
}

void PagerItem::handleClose(QString data) {
  isClosing = true;

  qDebug() << "We got the close signal";
  qDebug() << data;

  string id = cJSON_GetObjectItem(cJSON_Parse(&data.toStdString()[0]), "id")
                  ->valuestring;

  QList<Window> newWindows;
  QList<int> indexes;
  QList<QString> desktopFileNames;

  QList<double> xPositions;

  int counter = 0;
  for (Window window : previousWindows) {
    if (window.internalId != id) {
      newWindows.push_back(window);
      indexes.push_back(counter);
      desktopFileNames.push_back(window.desktopFileName);
      xPositions.push_back(window.xPos);
      counter++;
    }
  }
  previousWindows = newWindows;

  Q_EMIT update(previousActiveIndex, indexes, desktopFileNames, xPositions);
  isClosing = false;
}
