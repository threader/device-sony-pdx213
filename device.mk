# Copyright 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Device path
DEVICE_PATH := device/sony/pdx213_twrp/rootdir

DEVICE_PACKAGE_OVERLAYS += \
    device/sony/pdx213_twrp/overlay

# Device Specific Permissions
PRODUCT_COPY_FILES := \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml

# Audio Configuration
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(DEVICE_PATH)/vendor/etc/audio_io_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_io_policy.conf

# Audio calibration
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/acdbdata/Bluetooth_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Bluetooth_cal.acdb \
    $(DEVICE_PATH)/vendor/etc/acdbdata/General_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/General_cal.acdb \
    $(DEVICE_PATH)/vendor/etc/acdbdata/Global_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Global_cal.acdb \
    $(DEVICE_PATH)/vendor/etc/acdbdata/Handset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Handset_cal.acdb \
    $(DEVICE_PATH)/vendor/etc/acdbdata/Hdmi_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Hdmi_cal.acdb \
    $(DEVICE_PATH)/vendor/etc/acdbdata/Headset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Headset_cal.acdb \
    $(DEVICE_PATH)/vendor/etc/acdbdata/Speaker_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Speaker_cal.acdb \
    $(DEVICE_PATH)/vendor/etc/acdbdata/workspaceFile.qwsp:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/workspaceFile.qwsp \
    $(DEVICE_PATH)/vendor/etc/acdbdata/adsp_avs_config.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/adsp_avs_config.acdb

# NFC Configuration
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor/etc/libnfc-nxp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf


# Configure twrp
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_PACKAGES += \
    bootctrl.sony_sm6350.recovery \
    android.hardware.boot@1.1-impl-qti.recovery

# PRODUCT_RELEASE_NAME ro.twrp.device.name
PRODUCT_PROPERTY_OVERRIDES += ro.twrp.device.name=$(PRODUCT_RELEASE_NAME)

# Device Init
PRODUCT_PACKAGES += \
    fstab.pdx213 \
    ramdisk-fstab.pdx213 \
    init.recovery.pdx213 \
    init.pdx213

# Telephony Packages (AOSP)
PRODUCT_PACKAGES += \
    InCallUI \
    Stk

# SAR
PRODUCT_PACKAGES += \
    TransPowerSensors

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi hdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

PRODUCT_PROPERTY_OVERRIDES := \
    ro.sf.lcd_density=420 \
    ro.usb.pid_suffix=20d

# Inherit from those products. Most specific first.
$(call inherit-product, device/sony/lena/platform.mk)

# copy NFC firmware
$(call inherit-product-if-exists, vendor/nxp/nxp-vendor.mk)


#A/B
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    odm \
    vendor

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# System as root
BOARD_ROOT_EXTRA_FOLDERS := bluetooth dsp firmware persist
BOARD_SUPPRESS_SECURE_ERASE := true

# Workaround for error copying vendor files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

ALLOW_MISSING_DEPENDENCIES := true

# Crypto
BOARD_USES_QCOM_FBE_DECRYPTION := true
BOARD_USES_METADATA_PARTITION := true
PLATFORM_VERSION := 13
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2

# Network
BUILD_BROKEN_USES_NETWORK := true

# Tool
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
			     
# TWRP specific build flags
TW_THEME := portrait_hdpi
ifeq ($(TW_DEVICE_VERSION),)
TW_DEVICE_VERSION=12.0
endif
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_NTFS_3G := true
TW_USE_TOOLBOX := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 300
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TW_NO_SCREEN_BLANK := true
TW_EXCLUDE_APEX := true
TW_HAS_EDL_MODE := false
TW_SUPPORT_INPUT_AIDL_HAPTICS :=true
TW_BACKUP_EXCLUSIONS := /data/fonts

# include board vendor blobs
$(call inherit-product-if-exists, vendor/sony/lena-common/lena-partial.mk)
