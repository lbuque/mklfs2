CFLAGS		?= -std=gnu99 -Os -Wall
CXXFLAGS	?= -std=gnu++11 -Os -Wall

VERSION ?= $(shell git describe --always)

ifeq ($(OS),Windows_NT)
	TARGET_OS := WINDOWS
	DIST_SUFFIX := windows
	ARCHIVE_CMD := 7z a
	ARCHIVE_EXTENSION := zip
	TARGET := mklfs2.exe
	TARGET_CFLAGS := -mno-ms-bitfields -Ilfs -I. -DVERSION=\"$(VERSION)\" -D__NO_INLINE__
	TARGET_LDFLAGS := -Wl,-static -static-libgcc
	TARGET_CXXFLAGS := -Ilfs -I. -DVERSION=\"$(VERSION)\" -D__NO_INLINE__
	CC=gcc
	CXX=g++
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		TARGET_OS := LINUX
		UNAME_P := $(shell uname -p)
		ifeq ($(UNAME_P),x86_64)
			DIST_SUFFIX := linux64
		endif
		ifneq ($(filter %86,$(UNAME_P)),)
			DIST_SUFFIX := linux32
		endif
		CC=gcc
		CXX=g++
		TARGET_CFLAGS   = -std=gnu99 -Os -Wall -Ilfs -I. -D$(TARGET_OS) -DVERSION=\"$(VERSION)\" -D__NO_INLINE__
		TARGET_CXXFLAGS = -std=gnu++11 -Os -Wall -Ilfs -I. -D$(TARGET_OS) -DVERSION=\"$(VERSION)\" -D__NO_INLINE__
	endif
	ifeq ($(UNAME_S),Darwin)
		TARGET_OS := OSX
		DIST_SUFFIX := osx
		CC=clang
		CXX=clang++
		TARGET_CFLAGS   = -std=gnu99 -Os -Wall -Ilfs -I. -D$(TARGET_OS) -DVERSION=\"$(VERSION)\" -D__NO_INLINE__ -mmacosx-version-min=10.7 -arch x86_64
		TARGET_CXXFLAGS = -std=gnu++11 -Os -Wall -Ilfs -I. -D$(TARGET_OS) -DVERSION=\"$(VERSION)\" -D__NO_INLINE__ -mmacosx-version-min=10.7 -arch x86_64 -stdlib=libc++
		TARGET_LDFLAGS  = -arch x86_64 -stdlib=libc++
	endif
	ARCHIVE_CMD := tar czf
	ARCHIVE_EXTENSION := tar.gz
	TARGET := mklfs2
endif

OBJ := \
	mklfs.o \
	littlefs/lfs.o \
	littlefs/lfs_util.o

VERSION ?= $(shell git describe --always)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJ)
	@echo "Building mklfs2 ..."
	$(CC) $(TARGET_CFLAGS) -o $(TARGET) $(OBJ) $(TARGET_LDFLAGS)

$(OBJ): %.o : %.c
	$(CC) -c $< -o $@

clean:
	@rm -f *.o
	@rm -f littlefs/*.o
	@rm -f $(TARGET)
