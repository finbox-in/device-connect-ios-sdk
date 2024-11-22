//
//  Constants.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 06/06/24.
//

import Foundation

// ****************************************************************************************************
// Device Data Start
// ****************************************************************************************************

// Generic Keys
let OS_BUILD = "osBuild"
let SOUND = "sound"
let BATTERY = "battery"
let PERSONALIZATION = "personalization"
let NETWORK = "network"
let SYSTEM_INFO = "systemInfo"
let DISPLAY = "display"
let DEVICE_INFO = "deviceInfo"

// Device Info keys
let HW_TARGET = "hwTarget"
let KERN_OSTYPE = "kernOSType"
let KERN_HOSTNAME = "kernHostname"
let OS_VERSION = "osVersion"
let KERN_OSVERSION = "kernOSVersion"
let KERN_VERSION = "kernVersion"
let DEVICE_NAME = "deviceName"
let DEVICE_MODEL_RAW_NAME = "deviceModelRawName"
let HW_MACHINE = "hwMachine"
let HW_MODEL = "hwModel"
let KERN_OSRELEASE = "kernOSRelease"
let HW_PRODUCT = "hwProduct"
let LOCALIZED_MODEL = "localizedModel"
let SYSTEM_NAME = "systemName"

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
let TOTAL_SPACE = "totalSpace"
let FREE_SPACE = "freeSpace"

// System Info keys
let SYSTEM_INFO_TOTAL_RAM = "totalRam"
let SYSTEM_INFO_UPTIME = "uptime"
let SYSTEM_INFO_IS_MULTITASKING = "isMultitasking"
let SYSTEM_INFO_ELAPSED_TIME_IN_MILLIS = "elapsedTimeMillis"

// Network Keys
let NETWORK_TYPE = "networkType"
let ACTIVE_NETWORK_TYPE_NAME = "activeNetworkTypeName"

// Misc Keys
let BACKGROUND_REFRESH_STATUS = "backgroundRefreshStatus"
let AD_ID = "adverisementId"
let DISPLAY_LANGUAGE = "displayLanguage"
let VENDOR_ID = "vendorId"
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

// ****************************************************************************************************
// Device Data End
// ****************************************************************************************************

// ****************************************************************************************************
// Location Data Start
// ****************************************************************************************************

let ALLOW_BACKGROUND_LOCATION_UPDATES_KEY = "allowsBackgroundLocationUpdates"
let SHOWS_BACKGROUND_LOCATION_INDICATOR_KEY = "showsBackgroundLocationIndicator"
let HEADING_ORIENTATION_KEY = "headingOrientation"
let MAGNETIC_HEADER_KEY = "magneticHeading"
let TRUE_HEADING_KEY = "trueHeading"
let TIMESTAMP_KEY = "timestamp"
let HEADING_ACCURACY_KEY = "headingAccuracy"
let ALTITUDE_KEY = "altitude"
let ELLIPSOIDAL_ALTITUDE_KEY = "ellipsoidalAltitude"
let IS_PRODUCED_BY_ACCESSORY_KEY = "isProducedByAccessory"
let IS_SIMULATED_BY_SOFTWARE_KEY = "isSimulatedBySoftware"
let HORIZONTAL_ACCURACY_KEY = "horizontalAccuracy"
let VERTICAL_ACCURACY_KEY = "verticalAccuracy"
let SPEED_KEY = "speed"
let SPEED_ACCURACY_KEY = "speedAccuracy"
let COURSE_KEY = "course"
let COURSE_ACCURACY_KEY = "courseAccuracy"

// ****************************************************************************************************
// Location Data End
// ****************************************************************************************************

// ****************************************************************************************************
// Misc Keys Start
// ****************************************************************************************************

// BG Task Identifier - Sync
let BACKGROUND_TASK_IDENTIFIER = "in.finbox.riskmanager.SyncTask"
let DEFAULT_SYNC_FREQUENCY: TimeInterval = 28800                             // Default Sync Frequency - 8 hours


// Pref Keys
let FINBOX_DEVICE_CONNECT_API_KEY = "random_api_key"

// User Default Suite Name
public let USER_DEFAULT_SUITE_ACCOUNT_DETAILS = "user-default-suite-account-details"
// User Defaults - API Key
public let USER_DEFAULT_API_KEY = "user-default-api-key"
// User Defaults - Access Token
public let USER_DEFAULT_ACCESS_TOKEN = "user-default-access-token"
// User Defaults - IOS Id
public let USER_DEFAULT_IOS_ID = "user-default-ios-id"
// User Defaults - Username
public let USER_DEFAULT_USER_NAME = "user-default-username"
// User Defaults - User Hash
public let USER_DEFAULT_USER_HASH = "user-default-user-hash"

// User Default Suite Name
public let USER_DEFAULT_SUITE_FLOW_DATA = "user-default-suite-flow-data"
// User Defaults - Location
public let USER_DEFAULT_FLOW_LOCATION = "user-default-flow-location"
// User Defaults - Device
public let USER_DEFAULT_FLOW_DEVICE = "user-default-flow-device"


// User Defaults Suite name
public let USER_DEFAULT_SUITE_SYNC_PREF = "user-default-suite-sync-pref"
public let PREF_KEY_SYNC_FREQUENCY = "finbox_risk_manager_key_sync_frequency"
public let PREF_KEY_SYNC_MECHANISM = "finbox_risk_manager_key_sync_mechanism"
public let PREF_KEY_SYNC_ID = "finbox_risk_manager_key_sync_id"
public let PREF_KEY_IS_REAL_TIME = "finbox_risk_manager_key_is_real_time"

// Sync Type Keys
enum SyncType {
    case CREATE_USER
    case FCM
    case DEVICE
    case LOCATION
    case PERMISSIONS
}

let AUTH_BASE_URL = "https://auth.apis.finbox.in/v6/"
let DATA_SYNC_BASE_URL = "https://riskmanager.apis.finbox.in/v6/datasource/ios/"
let FCM_ENDPOINT = "fcmtoken"
let CREATE_USER_ENDPOINT = "token_generator"
let DEVICE_ENDPOINT = "device/details"
let LOCATION_ENDPOINT = "location"
let PERMISSIONS_ENDPOINT = "permissions"

// App Version number
public let APP_VERSION_NAME = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
// App Version code
public let APP_VERSION_CODE = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"

