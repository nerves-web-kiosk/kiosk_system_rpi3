################################################################################
#
# noto-fonts
#
################################################################################

NOTO_FONTS_VERSION = v2017-09-19-phase3-second
NOTO_FONTS_SITE = $(call github,googlei18n,noto-fonts,$(NOTO_FONTS_VERSION))
NOTO_FONTS_LICENSE = OFL-1.1
NOTO_FONTS_LICENSE_FILES = LICENSE

NOTO_FONTS_FONTS = \
	$(call qstrip,$(BR2_PACKAGE_NOTO_FONTS_FONTS))

define NOTO_FONTS_INSTALL_TARGET_CMDS
	for i in $(NOTO_FONTS_FONTS); \
	do \
		$(INSTALL) -d $(TARGET_DIR)/usr/share/fonts/noto && \
		$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/fonts/noto $(@D)/hinted/$$i.ttf || exit 1; \
	done
endef

$(eval $(generic-package))
