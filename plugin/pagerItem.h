#pragma once

#include "DBusService.h"
#include <QObject>
#include <qcontainerfwd.h>
#include <qlist.h>
#include <qobject.h>
using namespace std;

typedef struct {
  QString caption;
  bool minimized;
  string internalId;
  double xPos;
  bool active;
  QString desktopFileName;
  QString resourceClass;

} Window;

bool compareByXpos(const Window &a, const Window &b);

class PagerItem : public QObject {
  Q_OBJECT

public:
  explicit PagerItem(QObject *parent = nullptr);
  ~PagerItem() override;

  void handlePassedData(QString data);
  void handleClose(QString data);

  void registerDBusService();
  bool dbusSuccess;
  bool isClosing;
  int previousActiveIndex;
  QList<Window> previousWindows;
  QList<QString> previousDesktopNames;
  QString ignoreList;
  QList<QString> closedWindowIds;

  void checkScript();
  void debounceEmit();

  Q_INVOKABLE
  void setIgnoreList(QString ignoreList);

Q_SIGNALS:
  void update(int activeIndex, QList<int> windowArr,
              QList<QString> desktopFileNames, QList<double> xPositions,
              QList<QString> captions, QList<QString> resourceClasses);

private:
  DBusService dbusService;
};
