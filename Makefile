SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

TARGET ?= aarch64-linux-android
APP_NAME ?= NoSaveChat
DX ?= dx
TAILWIND ?= tailwindcss
ICON_SCRIPT ?= ./scripts/build-android-apk-with-icon.sh

PROJECT_VERSION := $(strip $(shell awk '/^\s*version\s*=/ {gsub(/"/, "", $$3); print $$3; exit}' Cargo.toml))
ifeq ($(PROJECT_VERSION),)
PROJECT_VERSION := 0.0.0
endif

RELEASE_APK_PATH ?= dist/$(APP_NAME)-v$(PROJECT_VERSION)-$(TARGET)-release.apk
DEBUG_APK_PATH ?= dist/$(APP_NAME)-v$(PROJECT_VERSION)-$(TARGET)-debug.apk

.PHONY: help
help:
	@echo "NoSave Chat build targets:"
	@echo "  make android-build            - Build Android APK with icon workaround (default: aarch64-linux-android)"
	@echo "  make android-release-build    - Build signed release APK with icon workaround"
	@echo "  make android-release-bundle   - Build Android App Bundle (AAB)"
	@echo "  make android-apk-bundle       - Build Android APK directly"
	@echo "  make tailwind                - Build assets/tailwind.css once"
	@echo "  make tailwind-watch          - Watch Tailwind changes"
	@echo "  make serve                   - Run dx serve --android"
	@echo "  make install-apk             - Install debug APK on connected device/emulator"
	@echo "  make install-release-apk      - Install release APK on connected device/emulator"
	@echo "  make release                 - Build release APK with icon workaround"
	@echo "  make clean                   - Remove Rust build artifacts"
	@echo
	@echo "Target vars:"
	@echo "  TARGET=<aarch64-linux-android|x86_64-linux-android>"
	@echo "  APP_NAME=<Name>"
	@echo "  PROJECT_VERSION=<version override>"

.PHONY: android-build
android-build:
	$(ICON_SCRIPT) $(TARGET) debug $(DEBUG_APK_PATH)

.PHONY: android-release-build
android-release-build:
	$(ICON_SCRIPT) $(TARGET) release $(RELEASE_APK_PATH)

.PHONY: android-release-bundle
android-release-bundle:
	$(DX) bundle --android --release --package-types aab --target $(TARGET)

.PHONY: android-apk-bundle
android-apk-bundle:
	$(DX) bundle --android --release --package-types apk --target $(TARGET)

.PHONY: tailwind
tailwind:
	$(TAILWIND) -i ./tailwind.css -o ./assets/tailwind.css

.PHONY: tailwind-watch
tailwind-watch:
	$(TAILWIND) -i ./tailwind.css -o ./assets/tailwind.css --watch

.PHONY: serve
serve:
	$(DX) serve --android

.PHONY: install-apk
install-apk:
	@if [[ ! -f "$(DEBUG_APK_PATH)" ]]; then \
		echo "Missing built debug APK: $(DEBUG_APK_PATH)"; \
		echo "Run: make android-build"; \
		exit 1; \
	fi
	adb install -r "$(DEBUG_APK_PATH)"

.PHONY: install-release-apk
install-release-apk:
	@if [[ ! -f "$(RELEASE_APK_PATH)" ]]; then \
		echo "Missing built release APK: $(RELEASE_APK_PATH)"; \
		echo "Run: make android-release-build"; \
		exit 1; \
	fi
	adb install -r "$(RELEASE_APK_PATH)"

.PHONY: clean
clean:
	cargo clean

.PHONY: release
release:
	$(MAKE) android-release-build
