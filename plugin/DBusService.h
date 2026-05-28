#pragma once

#include <QObject>
#include <QString>

#define SERVICE_NAME "dev.hunterwhite.pager"

class DBusService : public QObject {
  Q_OBJECT
  Q_CLASSINFO("D-Bus Interface", SERVICE_NAME)

public:
  DBusService(QObject *parent = nullptr);

public Q_SLOTS:
  void pass(QString data);
  void close(QString data);

Q_SIGNALS:
  void dataPassed(QString data);
  void handleClose(QString data);
};
