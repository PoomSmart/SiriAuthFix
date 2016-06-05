GO_EASY_ON_ME = 1
SDKVERSION = 6.0

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = SiriAuthFix
SiriAuthFix_FILES = Tweak.xm
SiriAuthFix_PRIVATE_FRAMEWORKS = IOKit

include $(THEOS_MAKE_PATH)/tweak.mk

