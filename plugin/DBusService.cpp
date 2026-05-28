#include "DBusService.h"

DBusService::DBusService(QObject *parent) : QObject(parent) {}

void DBusService::pass(QString data) { Q_EMIT dataPassed(data); }

void DBusService::close(QString data) { Q_EMIT handleClose(data); }
