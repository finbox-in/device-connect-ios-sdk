//
//  Constants.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 06/06/24.
//

import Foundation

// *****************
// Device Data Start
// *****************

// Generic Keys
let OS_BUILD = "osBuild"
let SOUND = "sound"
let BATTERY = "battery"
let PERSONALIZATION = "personalization"
let NETWORK = "network"
let SYSTEM_INFO = "systemInfo"
let DISPLAY = "display"
let DEVICE_INFO = "device_info"

// Device Info keys
let HW_TARGET = "hw_target"
let KERN_OSTYPE = "kern_os_type"
let KERN_HOSTNAME = "kern_hostname"
let OS_VERSION = "os_version"
let KERN_OSVERSION = "kern_os_version"
let KERN_VERSION = "kernVersion"
let DEVICE_NAME = "device_name"
let DEVICE_MODEL_RAW_NAME = "device_model_raw_name"
let HW_MACHINE = "hw_machine"
let HW_MODEL = "hw_model"
let KERN_OSRELEASE = "kern_os_release"
let HW_PRODUCT = "hw_product"
let LOCALIZED_MODEL = "localized_model"
let SYSTEM_NAME = "system_name"

// Kernel Info keys
let SYS_KERNEL_HOSTNAME = "kern.hostname"
let SYS_KERNEL_OSRELEASE = "kern.osrelease"
let SYS_KERNEL_OSTYPE = "kern.ostype"
let SYS_KERNEL_OSVERSION = "kern.osversion"
let SYS_KERNEL_VERSION = "kern.version"

// CPU keys
let SYS_CPU = "cpu"
let SYS_AVAILABLE_PROCESSORS = "availableProcessors"

// Storage keys
let STORAGE = "storage"
let TOTAL_SPACE = "total_space"
let FREE_SPACE = "free_space"

// System Info keys
let SYSTEM_INFO_TOTAL_RAM = "total_ram"
let SYSTEM_INFO_UPTIME = "uptime"
let SYSTEM_INFO_IS_MULTITASKING = "is_multitasking"
let SYSTEM_INFO_ELAPSED_TIME_IN_MILLIS = "elapsed_time_millis"

// Network Keys
let NETWORK_TYPE = "networkType"
let ACTIVE_NETWORK_TYPE_NAME = "activeNetworkTypeName"

// Misc Keys
let BACKGROUND_REFRESH_STATUS = "background_refresh_status"
let AD_ID = "adverisement-id"
let DISPLAY_LANGUAGE = "display_language"
let VENDOR_ID = "vendor_id"
let SDK_VERSION_NAME = "sdkVersionName"
let IS_REAL_TIME = "isRealTime"
let SYNC_MECHANISM = "syncMechanism"
let SYNC_ID = "syncId"
let BATCH_ID = "batchId"
let USER_HASH = "userHash"
let USER_NAME = "userName"


// Display Keys
struct Display {
    static let SCREEN_WIDTH_KEY = "widthPixels"
    static let SCREEN_HEIGHT_KEY = "heightPixels"
}

// Sound keys
struct Sound {
    static let VOLUME = "volume"
    static let INPUT = "input"
    static let OUTPUT = "output"
}

// Battery keys
struct Battery {
    static let STATUS = "status"
    static let LEVEL = "level"
}

// Personalization keys
struct Personalization {
    static let FONTS = "fonts"
    static let CURRENCY = "currency"
    static let TIMEZONE = "timezone"
    static let CALENDAR = "calendar"
    static let COUNTRY = "country"
    static let KEYBOARDS = "keyboards"
    static let LANGUAGE = "language"
}

// Network keys
struct Network {
    static let ADDRESSES = "addresses"
    struct Address {
        static let IFA_NAME = "ifaName"
        static let IP = "ip"
    }
}

// ***************
// Device Data End
// ***************

// *******************
// Location Data Start
// *******************

let ALLOW_BACKGROUND_LOCATION_UPDATES_KEY = "allows_background_location_updates"
let SHOWS_BACKGROUND_LOCATION_INDICATOR_KEY = "shows_background_location_indicator"
let HEADING_ORIENTATION_KEY = "heading_orientation"
let LONGITUDE_KEY = "longitude"
let LATITUDE_KEY = "latitude"
let MAGNETIC_HEADER_KEY = "magnetic_heading"
let TRUE_HEADING_KEY = "true_heading"
let TIMESTAMP_KEY = "timestamp"
let HEADING_ACCURACY_KEY = "heading_accuracy"
let ALTITUDE_KEY = "altitude"
let ELLIPSOIDAL_ALTITUDE_KEY = "ellipsoidal_altitude"
let IS_PRODUCED_BY_ACCESSORY_KEY = "is_produced_by_accessory"
let IS_SIMULATED_BY_SOFTWARE_KEY = "is_simulated_by_software"
let HORIZONTAL_ACCURACY_KEY = "horizontal_accuracy"
let VERTICAL_ACCURACY_KEY = "vertical_accuracy"
let SPEED_KEY = "speed"
let SPEED_ACCURACY_KEY = "speed_accuracy"
let COURSE_KEY = "course"
let COURSE_ACCURACY_KEY = "course_accuracy"
