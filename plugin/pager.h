#pragma once
#include <QQmlEngine>
#include <QQmlExtensionPlugin>

class Pager : public QQmlExtensionPlugin {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
  void registerTypes(const char *uri) override;
};
