################################################################################
#
# qt-webkit-kiosk
#
################################################################################

QT_WEBENGINE_KIOSK_VERSION = e10953325c2b86790b48b26aa52c0b6fd7430be5
QT_WEBENGINE_KIOSK_SITE = https://github.com/mobileoverlord/qt-webengine-kiosk.git
QT_WEBENGINE_KIOSK_SITE_METHOD = git
QT_WEBENGINE_KIOSK_DEPENDENCIES = qt5webengine

define QT_WEBENGINE_KIOSK_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT5_QMAKE) PREFIX=/usr)
endef

define QT_WEBENGINE_KIOSK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT_WEBENGINE_KIOSK_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) -f Makefile \
		INSTALL_ROOT=$(TARGET_DIR) \
		install_target
endef

$(eval $(generic-package))
