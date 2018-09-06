################################################################################
#
# noto-cjk
#
################################################################################

NOTO_CJK_VERSION = v2017-06-01-serif-cjk-1-1
NOTO_CJK_SITE = $(call github,googlei18n,noto-cjk,$(NOTO_CJK_VERSION))
NOTO_CJK_LICENSE = OFL-1.1
NOTO_CJK_LICENSE_FILES = LICENSE

define NOTO_CJK_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/share/fonts/noto-cjk
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/fonts/noto-cjk $(@D)/*.ttc
endef

$(eval $(generic-package))
