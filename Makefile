APP_NAME = ColorBlender

SOURCE_DIR = ColorBlender
BUILD_DIR = build

APP_DIR = $(BUILD_DIR)/$(APP_NAME).app
CONTENTS_DIR = $(APP_DIR)/Contents
MACOS_DIR = $(CONTENTS_DIR)/MacOS
RESOURCES_DIR = $(CONTENTS_DIR)/Resources

CC = clang

SOURCES := $(shell find $(SOURCE_DIR) -name "*.m")

HEADER_PATHS = \
	-I$(SOURCE_DIR)/App \
	-I$(SOURCE_DIR)/Controllers \
	-I$(SOURCE_DIR)/Models \
	-I$(SOURCE_DIR)/Services \
	-I$(SOURCE_DIR)/Views

CFLAGS = \
	-fobjc-arc \
	-fmodules \
	$(HEADER_PATHS) \
	-framework Cocoa

all: $(APP_DIR)

$(APP_DIR):
	@echo "Building $(APP_NAME)..."

	mkdir -p $(MACOS_DIR)
	mkdir -p $(RESOURCES_DIR)

	$(CC) \
		$(SOURCES) \
		$(CFLAGS) \
		-o $(MACOS_DIR)/$(APP_NAME)

	@echo '<?xml version="1.0" encoding="UTF-8"?>' > $(CONTENTS_DIR)/Info.plist
	@echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $(CONTENTS_DIR)/Info.plist
	@echo '<plist version="1.0">' >> $(CONTENTS_DIR)/Info.plist
	@echo '<dict>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>CFBundleExecutable</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<string>$(APP_NAME)</string>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>CFBundleIdentifier</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<string>com.local.colorblender</string>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>CFBundleName</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<string>$(APP_NAME)</string>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>CFBundleDisplayName</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<string>Color Blender</string>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>CFBundlePackageType</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<string>APPL</string>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>CFBundleVersion</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<string>1</string>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>CFBundleShortVersionString</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<string>0.1.0</string>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<key>NSHighResolutionCapable</key>' >> $(CONTENTS_DIR)/Info.plist
	@echo '<true/>' >> $(CONTENTS_DIR)/Info.plist
	@echo '</dict>' >> $(CONTENTS_DIR)/Info.plist
	@echo '</plist>' >> $(CONTENTS_DIR)/Info.plist

	@echo "Build complete: $(APP_DIR)"

clean:
	rm -rf $(BUILD_DIR)

rebuild: clean all

run: all
	open $(APP_DIR)

.PHONY: all clean rebuild run