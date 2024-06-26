#Generated by VisualGDB project wizard. 
#Feel free to modify any flags you want
#Visit http://visualgdb.com/makefiles for more details

SRCPATH := $(PWD)/../src/

# Set this variable to the location of the Steamworks SDK
ifeq ($(STEAMWORKS_SDK),)
    STEAMWORKS_SDK := $(PWD)/../steamworkslib/
endif
STEAM_API := libsteam_api.so

# Uncomment this line to use the Steam Linux Runtime SDK
# If you do this you should run the SDK setup.sh to download updates
USE_STEAM_RUNTIME=false
ifeq ($(USE_STEAM_RUNTIME),true)
    ifeq ($(STEAM_RUNTIME_SDK),)
        STEAM_RUNTIME_SDK := $(STEAMWORKS_SDK)/tools/linux
    endif
    ifeq ($(STEAM_RUNTIME_TARGET_ARCH),)
        STEAM_RUNTIME_TARGET_ARCH := i386
        export STEAM_RUNTIME_TARGET_ARCH
    endif
    ifeq ($(STEAM_RUNTIME_ROOT),)
        STEAM_RUNTIME_ROOT := $(STEAM_RUNTIME_SDK)/runtime/$(STEAM_RUNTIME_TARGET_ARCH)
        export STEAM_RUNTIME_ROOT
    endif
    STEAM_TOOLS_BIN := $(STEAM_RUNTIME_SDK)/bin/

    ifeq ($(realpath $(STEAM_TOOLS_BIN)),)
steam-runtime-setup:
	bash $(STEAM_RUNTIME_SDK)/setup.sh --auto-upgrade
	make

    endif
endif # USE_STEAM_RUNTIME

CC ?= $(STEAM_TOOLS_BIN)gcc
CXX ?= $(STEAM_TOOLS_BIN)g++
LD := $(CXX)
AR ?= $(STEAM_TOOLS_BIN)ar
OBJCOPY ?= $(STEAM_TOOLS_BIN)objcopy
CP := cp
SDL_CONFIG := $(STEAM_TOOLS_BIN)sdl2-config

# Since this is an example, we'll build Debug by default
CONFIG ?= DEBUG

COMMON_MACROS := 
DEBUG_MACROS := DEBUG
RELEASE_MACROS := NDEBUG RELEASE

MCUFLAGS := 

INCLUDE_DIRS := $(STEAMWORKS_SDK)/public
LIBRARY_DIRS := $(STEAMWORKS_SDK)/public/steam/lib/linux64 $(STEAMWORKS_SDK)/redistributable_bin/linux64
LIBRARY_NAMES := steam_api

CFLAGS := -DPOSIX -DSDL \
        $(shell pkg-config --cflags sdl2) \
        $(shell pkg-config --cflags SDL2_ttf)

DEBUG_CFLAGS := -g -O0
RELEASE_CFLAGS := -O3

CXXFLAGS := $(CFLAGS)
DEBUG_CXXFLAGS := $(DEBUG_CFLAGS)
RELEASE_CXXFLAGS := $(RELEASE_CFLAGS)

MACOS_FRAMEWORKS := 

LDFLAGS := \
           $(shell pkg-config --libs sdl2) \
           $(shell pkg-config --libs SDL2_ttf) \
           $(shell pkg-config --libs glew) \
           $(shell pkg-config --libs openal)

DEBUG_LDFLAGS := 
RELEASE_LDGLAGS :=

START_GROUP := -Wl,--start-group
END_GROUP := -Wl,--end-group

USE_DEL_TO_CLEAN := 0
GENERATE_BIN_FILE := 0
ADDITIONAL_MAKE_FILES :=
IS_LINUX_PROJECT := 1

include $(ADDITIONAL_MAKE_FILES)
