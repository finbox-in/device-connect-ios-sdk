//
//  DeviceData.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 06/06/24.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork
import AVFoundation
import CoreLocation
import CoreTelephony
import CryptoKit

class DeviceData {
    
    /**
     Collects and returns device data.
     - Returns: A dictionary containing categorized device information.
     */
    func getDeviceData() -> [String: Any] {
        
        // Device
        let deviceInfo = getDeviceInfo()
        
        // Sound
        let soundData = getSoundData()
        
        // Battery
        let batteryData = getBatteryData()
        
        // Personalization
        let personalizationData = getPersonaizationData()
        
        // Display
        let displayData = getDisplayData()
        
        // Network
        let networkInfo = getNetworkInfo()
        
        // System Info
        let systemInfo = getSystemInfo()
        
        // Background Refresh Status
        let backgroundRefreshStatus = UIApplication.shared.backgroundRefreshStatus.rawValue
        
        // AD ID
        let adID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        // Bundle Device Data
        let deviceData: [String: Any]
        deviceData = [
            DEVICE_INFO: deviceInfo,
            SOUND: soundData,
            BATTERY: batteryData,
            PERSONALIZATION: personalizationData,
            NETWORK: networkInfo,
            DISPLAY: displayData,
            SYSTEM_INFO: systemInfo,
            AD_ID: adID,
            BACKGROUND_REFRESH_STATUS: backgroundRefreshStatus
        ]
        
        return deviceData
    }
    
    /**
     Collects device information.
     
     - Returns: A tuple containing device details, kernel information, and device identifier.
     */
    private func getDeviceInfo() -> [String: Any] {
        // Collect device information
        let device = UIDevice.current
        
        // Get device details
        let deviceName = device.name
        let deviceModel = device.model
        let deviceModelRawName = getRawModelName()
        let systemName = device.systemName
        let systemVersion = device.systemVersion
        
        // Get kernel information
        let kernelInfo = getKernelInfo()
        
        // Get device identifier
        let deviceIdentifier = getDeviceIdentifier()
        
        // Misc Data
        let deviceInfoExt = DeviceInfoExt()
        
        var isRealTime = false
        
        // Device Info
        let deviceInfo: [String: Any] = [
            HW_TARGET: deviceIdentifier,
            KERN_OSTYPE: kernelInfo.osType,
            KERN_HOSTNAME: kernelInfo.hostname,
            DEVICE_MODEL_RAW_NAME: deviceModelRawName,
            OS_VERSION: systemVersion,
            KERN_OSVERSION: kernelInfo.osVersion,
            KERN_VERSION: kernelInfo.version,
            DEVICE_NAME: deviceName,
            HW_MACHINE: deviceModel,
            HW_MODEL: deviceIdentifier,
            KERN_OSRELEASE: kernelInfo.osRelease,
            HW_PRODUCT: deviceModel,
            LOCALIZED_MODEL: device.localizedModel,
            SYSTEM_NAME: systemName,
            DISPLAY_LANGUAGE: deviceInfoExt.getISO3LanguageCode(),
            VENDOR_ID: deviceInfoExt.getVendorIdentifier(),
            SDK_VERSION_NAME: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
            IS_REAL_TIME: isRealTime,
            NETWORK_TYPE: deviceInfoExt.getNetworkType(),
            ACTIVE_NETWORK_TYPE_NAME: deviceInfoExt.getActiveNetworkTypeName(),
            SYNC_MECHANISM: 1,
            SYNC_ID: UUID().uuidString,
            BATCH_ID: UUID().uuidString,
            USER_HASH: UUID().uuidString,
            USER_NAME: UserDefaults.standard.string(forKey: "DC_CUSTOMER_ID") ?? ""
        ]
        
        return deviceInfo
    }
    
    /**
     Collects sound information.
     
     - Returns: A dictionary containing sound-related information.
     */
    private func getSoundData() -> [String: Any] {
        let volume = AVAudioSession.sharedInstance().outputVolume
        let input = AVAudioSession.sharedInstance().currentRoute.inputs.map { $0.portName }
        let output = AVAudioSession.sharedInstance().currentRoute.outputs.map { $0.portName }
        
        return [
            Sound.VOLUME: volume,
            Sound.INPUT: input,
            Sound.OUTPUT: output
        ]
    }
    
    /**
     Collects battery information.
     
     - Returns: A dictionary containing battery-related information.
     */
    private func getBatteryData() -> [String: Any] {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryStatus = UIDevice.current.batteryState.rawValue
        let batteryLevel = UIDevice.current.batteryLevel * 100
        
        return [
            Battery.STATUS: batteryStatus,
            Battery.LEVEL: batteryLevel
        ]
    }
    
    /**
     Collects personalization information.
     
     - Returns: A dictionary containing personalization-related information.
     */
    private func getPersonaizationData() -> [String: Any] {
        let fontFamilies = UIFont.familyNames
        let country = Locale.current.regionCode ?? "Unknown"
        let keyboards = UITextInputMode.activeInputModes.compactMap { $0.primaryLanguage }
        let timezone = TimeZone.current.identifier
        let language = Locale.current.identifier
        let calendar = Calendar.current.identifier
        let currency = Locale.current.currencyCode ?? "Unknown"
        
        return [
            Personalization.FONTS: fontFamilies,
            Personalization.CURRENCY: currency,
            Personalization.TIMEZONE: timezone,
            Personalization.CALENDAR: calendar,
            Personalization.COUNTRY: country,
            Personalization.KEYBOARDS: keyboards,
            Personalization.LANGUAGE: language
        ]
    }
    
    /**
     Collects display information.
     
     - Returns: A dictionary containing display-related information.
     */
    private func getDisplayData() -> [String: Any] {
        let widthPixels = UIScreen.main.bounds.width
        let heightPixels = UIScreen.main.bounds.height
        
        return [
            Display.SCREEN_WIDTH_KEY: widthPixels,
            Display.SCREEN_HEIGHT_KEY: heightPixels
        ]
    }
    
    /**
     Collects network information.
     
     - Returns: A dictionary containing network-related information.
     */
    private func getNetworkInfo() -> [String: Any] {
        let addresses = getWiFiAddresses()
        
        return [
            Network.ADDRESSES: addresses.map { [
                Network.Address.IFA_NAME: $0.ifaName,
                Network.Address.IP: $0.ip
            ]},
            NETWORK_TYPE: DeviceInfoExt().getNetworkType(),
            ACTIVE_NETWORK_TYPE_NAME: DeviceInfoExt().getActiveNetworkTypeName(),
        ]
    }
    
    /**
     Retrieves the raw model name of the device.
     - Returns: A string representing the raw model name of the device.
     */
    private func getRawModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /**
     Gets the device identifier.
     - Returns: A string representing the device identifier.
     */
    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0) ?? ""
            }
        }
    }
    
    /**
     Retrieves kernel information.
     - Returns: A tuple containing hostname, osRelease, osType, osVersion, and version.
     */
    private func getKernelInfo() -> (hostname: String, osRelease: String, osType: String, osVersion: String, version: String) {
        var sysctlValue = [CChar](repeating: 0, count: Int(NAME_MAX))
        var size = sysctlValue.count
        sysctlbyname(SYS_KERNEL_HOSTNAME, &sysctlValue, &size, nil, 0)
        let hostname = String(cString: sysctlValue)
        
        size = sysctlValue.count
        sysctlbyname(SYS_KERNEL_OSRELEASE, &sysctlValue, &size, nil, 0)
        let osRelease = String(cString: sysctlValue)
        
        size = sysctlValue.count
        sysctlbyname(SYS_KERNEL_OSTYPE, &sysctlValue, &size, nil, 0)
        let osType = String(cString: sysctlValue)
        
        size = sysctlValue.count
        sysctlbyname(SYS_KERNEL_OSVERSION, &sysctlValue, &size, nil, 0)
        let osVersion = String(cString: sysctlValue)
        
        size = sysctlValue.count
        sysctlbyname(SYS_KERNEL_VERSION, &sysctlValue, &size, nil, 0)
        let version = String(cString: sysctlValue)
        
        return (hostname, osRelease, osType, osVersion, version)
    }
    
    /**
     Retrieves system information including CPU, storage, and other system details.
     - Returns: A dictionary containing system information.
     */
    private func getSystemInfo() -> [String: Any] {
        var systemInfo: [String: Any] = [:]
        
        // CPU Information
        let availableProcessors = ProcessInfo.processInfo.processorCount
        systemInfo[SYS_CPU] = [SYS_AVAILABLE_PROCESSORS: availableProcessors]
        
        // Storage Information
        if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: FileManager.default.currentDirectoryPath),
           let totalSpace = systemAttributes[.systemSize] as? NSNumber,
           let freeSpace = systemAttributes[.systemFreeSize] as? NSNumber {
            systemInfo[STORAGE] = [TOTAL_SPACE: totalSpace.int64Value, FREE_SPACE: freeSpace.int64Value]
        }
        
        // System Info
        let totalRam = ProcessInfo.processInfo.physicalMemory
        let uptime = ProcessInfo.processInfo.systemUptime
        let isMultitasking = UIDevice.current.isMultitaskingSupported
        
        systemInfo[SYSTEM_INFO_TOTAL_RAM] = totalRam
        systemInfo[SYSTEM_INFO_UPTIME] = uptime
        systemInfo[SYSTEM_INFO_IS_MULTITASKING] = isMultitasking
        systemInfo[SYSTEM_INFO_ELAPSED_TIME_IN_MILLIS] = DeviceInfoExt().getElapsedTimeSinceBoot()
        
        return systemInfo
    }
    
    /**
     Retrieves WiFi addresses.
     - Returns: An array of tuples containing interface names and IP addresses.
     */
    private func getWiFiAddresses() -> [(ifaName: String, ip: String)] {
        var addresses: [(ifaName: String, ip: String)] = []
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                if let interface = ptr?.pointee {
                    let name = String(cString: interface.ifa_name)
                    let addr = interface.ifa_addr.pointee
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                       &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                            let ip = String(cString: hostname)
                            addresses.append((ifaName: name, ip: ip))
                        }
                    }
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    private func getMiscData() -> [String: Any] {
        var miscData: [String: Any] = [:]
        
        var isRealTime = false
        
        let deviceInfo = DeviceInfoExt()
        
        miscData[SDK_VERSION_NAME] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        miscData[IS_REAL_TIME] = isRealTime
        miscData[DISPLAY_LANGUAGE] = deviceInfo.getISO3LanguageCode()
        miscData[NETWORK_TYPE] = deviceInfo.getNetworkType()
        miscData[ACTIVE_NETWORK_TYPE_NAME] = deviceInfo.getActiveNetworkTypeName()
        miscData[SYNC_MECHANISM] = 1
        miscData[SYNC_ID] = UUID().uuidString
        miscData[BATCH_ID] = UUID().uuidString
        // TODO: Update this once user is created and hash is recevied.
        miscData[USER_HASH] = UUID().uuidString
        miscData[USER_NAME] = UserDefaults.standard.string(forKey: "DC_CUSTOMER_ID") ?? ""
        
        return miscData
    }
}
// Line 193
