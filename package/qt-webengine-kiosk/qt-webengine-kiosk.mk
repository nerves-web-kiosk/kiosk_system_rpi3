################################################################################
#
# qt-webkit-kiosk
#
################################################################################

QT_WEBENGINE_KIOSK_VERSION = 40745158d2cde953b919c35281217f504a488468
QT_WEBENGINE_KIOSK_SITE = https://github.com/mobileoverlord/qt-webengine-kiosk-1
QT_WEBENGINE_KIOSK_SITE_METHOD = git
QT_WEBENGINE_KIOSK_DEPENDENCIES = qt5webengine
QT_WEBENGINE_KIOSK_LICENSE = LGPL-3.0
QT_WEBENGINE_KIOSK_LICENSE_FILES = doc/lgpl.html

define QT_WEBENGINE_KIOSK_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT5_QMAKE) PREFIX=/usr)
endef

define QT_WEBENGINE_KIOSK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT_WEBENGINE_KIOSK_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src -f Makefile.qt-webengine-kiosk \
		INSTALL_ROOT=$(TARGET_DIR) \
		install_target
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		INSTALL_ROOT=$(TARGET_DIR)
endef

$(eval $(generic-package))
