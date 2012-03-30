export THEOS=/home/albert/IPhone/toolchain4/theos
export SDKBINPATH=/home/albert/IPhone/toolchain4/pre/bin
export SYSROOT=/home/albert/IPhone/toolchain4/sys50
export TARGET_CXX=clang -ccc-host-triple arm-apple-darwin9 
include theos/makefiles/common.mk

APPLICATION_NAME = LiteralWord

OBJS= $(wildcard *.m)
OBJS+= $(wildcard Classes/*.m)
OBJS+= $(wildcard Classes/*/*.m)


LiteralWord_FILES = $(OBJS)

LiteralWord_FRAMEWORKS = UIKit
#LiteralWord_FRAMEWORKS+= Foundation 
#LiteralWord_FRAMEWORKS+= AVFoundation
#LiteralWord_FRAMEWORKS+= AddressBook
#LiteralWord_FRAMEWORKS+= AddressBookUI
#LiteralWord_FRAMEWORKS+= AudioToolbox
#LiteralWord_FRAMEWORKS+= AudioUnit
#LiteralWord_FRAMEWORKS+= CFNetwork
#LiteralWord_FRAMEWORKS+= CoreAudio
#LiteralWord_FRAMEWORKS+= CoreData
#LiteralWord_FRAMEWORKS+= CoreFoundation 
LiteralWord_FRAMEWORKS+= CoreGraphics
#LiteralWord_FRAMEWORKS+= GraphicsServices
#LiteralWord_FRAMEWORKS+= CoreLocation
#LiteralWord_FRAMEWORKS+= ExternalAccessory
#LiteralWord_FRAMEWORKS+= GameKit
#LiteralWord_FRAMEWORKS+= IOKit
#LiteralWord_FRAMEWORKS+= MapKit
#LiteralWord_FRAMEWORKS+= MediaPlayer
#LiteralWord_FRAMEWORKS+= MessageUI
#LiteralWord_FRAMEWORKS+= MobileCoreServices
#LiteralWord_FRAMEWORKS+= OpenAL
#LiteralWord_FRAMEWORKS+= OpenGLES
#LiteralWord_FRAMEWORKS+= QuartzCore
#LiteralWord_FRAMEWORKS+= Security
#LiteralWord_FRAMEWORKS+= StoreKit
#LiteralWord_FRAMEWORKS+= System
#LiteralWord_FRAMEWORKS+= SystemConfiguration
#LiteralWord_FRAMEWORKS+= CoreSurface
#LiteralWord_FRAMEWORKS+= GraphicsServices
#LiteralWord_FRAMEWORKS+= Celestial
#LiteralWord_FRAMEWORKS+= WebCore
#LiteralWord_FRAMEWORKS+= WebKit
#LiteralWord_FRAMEWORKS+= SpringBoardUI
#LiteralWord_FRAMEWORKS+= TelephonyUI
#LiteralWord_FRAMEWORKS+= JavaScriptCore
#LiteralWord_FRAMEWORKS+= PhotoLibrary


IPHONEOSMINVERSION:=50000

INC_DIR= -I$(SYSROOT)/usr/include -I./Classes
ADDITIONAL_CFLAGS = -D__IPHONE_OS_VERSION_MIN_REQUIRED=$(IPHONEOSMINVERSION) $(INC_DIR)
ADDITIONAL_LDFLAGS = -L$(SYSROOT)/usr/lib -lsqlite3

include $(THEOS_MAKE_PATH)/application.mk

after-clean::
	rm -rf *.deb

install_deb: clean package
	scp com.ebcsv*.deb root@$(IPHONE_IP):~/Dev
	ssh root@$(IPHONE_IP) "dpkg -r com.ebcsv.literalword; dpkg -i ~/Dev/com.ebcsv.literalword*.deb; su mobile -c \"uicache\"; rm ~/Dev/com.ebcsv.literalword*.deb"
