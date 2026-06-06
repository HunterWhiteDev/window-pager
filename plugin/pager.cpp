#include "pager.h"
#include "pagerItem.h"
#include <cstdio>
#include <qglobal.h>

void Pager::registerTypes(const char *uri) {
  Q_ASSERT(QLatin1String(uri) == QLatin1String("dev.hunterwhite.pager"));
  qmlRegisterType<PagerItem>(uri, 1, 0, "Pager");
}
