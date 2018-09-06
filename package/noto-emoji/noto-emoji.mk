################################################################################
#
# noto-emoji
#
################################################################################

NOTO_EMOJI_VERSION = v2018-08-10-unicode11
NOTO_EMOJI_SITE = $(call github,googlei18n,noto-emoji,$(NOTO_EMOJI_VERSION))
NOTO_EMOJI_LICENSE = OFL-1.1
NOTO_EMOJI_LICENSE_FILES = fonts/LICENSE

define NOTO_EMOJI_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/share/fonts/noto-emoji
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/fonts/noto-emoji $(@D)/fonts/*.ttf
endef

$(eval $(generic-package))
