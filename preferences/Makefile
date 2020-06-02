include $(THEOS)/makefiles/common.mk
ARCHS = arm64 arm64e

BUNDLE_NAME = iPadBar13
iPadBar13_FILES = $(wildcard *.m) $(wildcard SkittyPrefs/*.m)
iPadBar13_INSTALL_PATH = /Library/PreferenceBundles
iPadBar13_FRAMEWORKS = CoreGraphics UIKit
iPadBar13_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/iPadBar13.plist$(ECHO_END)
