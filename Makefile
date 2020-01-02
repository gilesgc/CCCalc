INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang::10.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCCalc
BUNDLE_NAME = com.gilesgc.cccalc
com.gilesgc.cccalc_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

CCCalc_FILES = Tweak.xm $(wildcard CCCalcUI/*.m)
CCCalc_CFLAGS = -fobjc-arc
CCCalc_PRIVATE_FRAMEWORKS = TelephonyUI

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk
