INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CCCalc

CCCalc_FILES = Tweak.xm $(wildcard CCCalcUI/*.m)
CCCalc_CFLAGS = -fobjc-arc
CCCalc_PRIVATE_FRAMEWORKS = TelephonyUI

include $(THEOS_MAKE_PATH)/tweak.mk
