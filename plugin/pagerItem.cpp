#include "pagerItem.h"
#include "DBusService.h"
#include "cJSON.h"
#include <KConfig>
#include <KConfigGroup>
#include <Plasma/Plasma>
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDebug>
#include <QObject>
#include <QRandomGenerator>
#include <QString>
#include <bits/stdc++.h>
#include <cstdlib>
#include <qcontainerfwd.h>
#include <qdbusconnection.h>
#include <qlist.h>
#include <qlogging.h>
#include <qmap.h>
#include <qmath.h>
#include <qobject.h>
#include <qobjectdefs.h>
#include <qtmetamacros.h>
#include <qvariant.h>
#include <string>
#include <unistd.h>
#include <vector>

using namespace std;
using namespace chrono;

std::vector<std::string> split(const std::string &str, char delimiter) {
  std::vector<std::string> tokens;
  size_t start = 0;
  size_t end = str.find(delimiter);

  while (end != std::string::npos) {
    tokens.push_back(str.substr(start, end - start));
    start = end + 1;
    end = str.find(delimiter, start);
  }

  tokens.push_back(str.substr(start));
  return tokens;
}

bool compareByXpos(const Window &a, const Window &b) {
  return a.xPos <= b.xPos;
}

PagerItem::PagerItem(QObject *parent)
    : QObject(parent), dbusSuccess(false), isClosing(false), ignoreList(),
      dbusService(parent) {

  QObject::connect(&dbusService, &DBusService::dataPassed, this,
                   &PagerItem::handlePassedData);

  QObject::connect(&dbusService, &DBusService::handleClose, this,
                   &PagerItem::handleClose);

  previousActiveIndex = 0;
  QList<Window> list;
  previousWindows = list;

  registerDBusService();
}

void PagerItem::setIgnoreList(QString ignoreList) {
  PagerItem::ignoreList = ignoreList;
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


void PagerItem::handlePassedData(QString data) {
    Q_EMIT update(data);
}

void PagerItem::handleClose(QString data) {

  string id = cJSON_GetObjectItem(cJSON_Parse(&data.toStdString()[0]), "id")
                  ->valuestring;

  closedWindowIds.push_back(QString::fromStdString(id));
}
