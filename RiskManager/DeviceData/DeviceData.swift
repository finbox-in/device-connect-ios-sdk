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
import NetworkExtension
import Network
import AdSupport
import AppTrackingTransparency


/// Helper class to sync Device information
class DeviceData {
    
    private let userSuite = UserPreference()
    private let syncSuite = SyncPref()
    private let flowSuite = FlowDataPref()
    
    private let ONE_MEBI_BYTE_IN_BYTES: Int64 = 1048576;
    
    /**
     * Collects the device data
     */
    func syncDeviceData() {
        
        if !flowSuite.flowDevice {
            return
        }
        
        // Device
        let deviceInfo = DeviceInfo()
        
        // Get the device
        let device = UIDevice.current
        // Get the system os version
        let version = device.systemVersion
        
        // Mobile Model
        let mobileModel = UIDevice.current.model
        // Brand of the device
        let brand = if mobileModel.contains("iPhone") || mobileModel.contains("iPad") || mobileModel.contains("iPod") {
            "Apple"
        } else {
            "Unknown"
        }
        
        deviceInfo.brand = brand
        deviceInfo.manufacturer = brand
        deviceInfo.model = mobileModel
        
        // Get the fingerprint
        let fingerprint = getFingerprint(device: device, systemVersion: version)
        
        // Get the available RAM
        let ramAvailableMB = getAvailableRAM()
        // Get the total RAM
        
        // Set User details
        deviceInfo.username = userSuite.userName
        deviceInfo.userHash = userSuite.userHash
        // Set Sync details
        deviceInfo.syncId = syncSuite.syncId
        deviceInfo.syncMechanism = syncSuite.syncMechanism
        deviceInfo.isRealTime = syncSuite.isRealTime
        deviceInfo.sdkVersionName = CommonUtil.getVersionName()
        
        // Get the current time in millis
        let currentTimeMillis = Int64(Date().timeIntervalSince1970 * 1000)
        
        let batchId = String(describing: userSuite.userName) + String(describing: ramAvailableMB) +
                                            String(describing: fingerprint) + version +
                                            String(describing: currentTimeMillis)
        
        deviceInfo.batchId = CommonUtil.getMd5Hash(batchId)
        deviceInfo.hash = CommonUtil.getMd5Hash(batchId)
        
        if let ramAvailableMB = ramAvailableMB {
            deviceInfo.ramAvailable = Int64(ramAvailableMB)
        }
        
        // Total RAM on the device
        let totalRam = ProcessInfo.processInfo.physicalMemory / UInt64(ONE_MEBI_BYTE_IN_BYTES)
        deviceInfo.totalRam = Int64(totalRam)
        
        // Get the storage space
        let storageSpace = getStorageSpace()
        deviceInfo.availableInternalSize = storageSpace.0
        deviceInfo.totalInternalSize = storageSpace.1
        
        let deviceInfoExt = DeviceInfoExt()
        // Get the display language
        deviceInfo.displayLanguage = deviceInfoExt.getISO3LanguageCode()
        deviceInfo.networkType = deviceInfoExt.getNetworkType()
        
        // System OS Version
        deviceInfo.osVersion = version
        deviceInfo.iosId = userSuite.iosId
        deviceInfo.fingerprint = fingerprint
        deviceInfo.device = getDeviceIdentifier()

        // WIFI Ssid
        deviceInfo.ssid = getWifiSSID()
        
        // Time since last time system was rebooted
        deviceInfo.elapsedTimeMillis = deviceInfoExt.getElapsedTimeSinceBoot()
        
        // Network information
//        let networkDetails = getNetworkTypeName()
//        deviceInfo.typeName = networkDetails.0
//        deviceInfo.reason = networkDetails.1

        // Get the SIM details
        let subscriptionInfo = CTTelephonyNetworkInfo()
        if let carrier = subscriptionInfo.serviceSubscriberCellularProviders?.values.first {
            deviceInfo.sCarrierName = carrier.carrierName
            deviceInfo.sCountryIso = carrier.isoCountryCode
            deviceInfo.sIndex = 0
        }
        
        // Screen width heirgh and pixels
        deviceInfo.widthPixels = deviceInfoExt.getDisplayWidthPixels()
        deviceInfo.heightPixels = deviceInfoExt.getDisplayHeightPixels()

        
//        // Sound
//        let soundData = getSoundData()
//        
//        // Battery
//        let batteryData = getBatteryData()
//        
//        // Personalization
//        let personalizationData = getPersonaizationData()
//        
//        // Display
//        let displayData = getDisplayData()
//        
//        // Network
//        let networkInfo = getNetworkInfo()
//        
//        // System Info
//        let systemInfo = getSystemInfo()
//        
        DispatchQueue.main.async {
            // Background Refresh Status
            let backgroundRefreshStatus = UIApplication.shared.backgroundRefreshStatus.rawValue
            debugPrint("Background Refresh Status", backgroundRefreshStatus)
        }
        
        // AD ID
        deviceInfo.advertisingId = getAdvertisingId()
        
        // Bundle Device Data
//        let deviceData: [String: Any]
//        deviceData = [
//            DEVICE_INFO: deviceInfo,
//            SOUND: soundData,
//            BATTERY: batteryData,
//            PERSONALIZATION: personalizationData,
//            NETWORK: networkInfo,
//            DISPLAY: displayData,
//            SYSTEM_INFO: systemInfo,
//            AD_ID: adID
//        ]
//        
        
        // Sync Device Data
        APIService.instance.syncDeviceData(data: deviceInfo, syncItem: SyncType.DEVICE)
    }
    
    private func getAdvertisingId() -> String? {
        if (isAdvertisingIdPermissionGranted()) {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        } else {
            return nil
        }
    }
    
    private func isAdvertisingIdPermissionGranted() -> Bool {
        let status = ATTrackingManager.trackingAuthorizationStatus
        return status == .authorized
    }
    
    private func getFingerprint(device: UIDevice, systemVersion: String) -> String {
        let model = device.model
        let name = device.name
        let identifierForVendor = device.identifierForVendor?.uuidString ?? "unknown"
        
        let fingerprint = "\(model)_\(name)_\(systemVersion)_\(identifierForVendor)"
        return fingerprint
    }
    
    func getAvailableRAM() -> UInt64? {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr == KERN_SUCCESS {
            return taskInfo.resident_size / UInt64(ONE_MEBI_BYTE_IN_BYTES)
        }
        else {
            return nil
        }
    }
    
    private func getNetworkTypeName() -> (String?, String?) {
        // TODO: Check and validate the delay from getting the Network details.
        // TODO: If delay is too much, move the values to the next sync.
        
        // Semaphore can be used to convert async func to sync func
        let semaphore = DispatchSemaphore(value: 0)
        
        var typeName: String? = nil
        var reason: String? = nil

        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.usesInterfaceType(.wifi) {
                typeName = "WIFI"
            } else if path.usesInterfaceType(.cellular) {
                typeName = "MOBILE"
            } else if path.usesInterfaceType(.wiredEthernet) {
                typeName = "ETHERNET"
            } else if path.usesInterfaceType(.loopback) {
                typeName = "LOOPBACK"
            } else if path.usesInterfaceType(.other) {
                typeName = "Other"
            } else {
                typeName = "No Network"
            }
            
            if path.status == .satisfied {
                if path.isExpensive {
                    reason = "expensive"
                } else {
                    reason = "non-expensive"
                }
            } else if path.status == .unsatisfied {
                reason = "No network"
            } else if path.status == .requiresConnection {
                reason = "Require connection"
            }
            
            // Stop monitoring after getting the information
            monitor.cancel()
            
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        return (typeName, reason)
    }
    
    
    
    private func getStorageSpace() -> (Int64?, Int64?) {
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let totalSpace = attributes[.systemSize] as? NSNumber,
               let freeSpace = attributes[.systemFreeSize] as? NSNumber {

                let totalSpaceInBytes = totalSpace.int64Value
                let freeSpaceInBytes = freeSpace.int64Value

                let totalSpaceInMB = totalSpaceInBytes / ONE_MEBI_BYTE_IN_BYTES
                let freeSpaceInMB = freeSpaceInBytes / ONE_MEBI_BYTE_IN_BYTES
                
                return (freeSpaceInMB, totalSpaceInMB)
            }
        }
        return (nil, nil)
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
        
        let isRealTime = false
        
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
            DISPLAY_LANGUAGE: deviceInfoExt.getISO3LanguageCode() ?? "",
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
    
    private func getSsid() -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var currentSSID: String?
        NEHotspotNetwork.fetchCurrent { network in
            currentSSID = network?.ssid
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return currentSSID
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
    private func getPersonaizationData() -> [String: Any?] {
        var country: String? = nil
        var currency: String? = nil
        if #available(iOS 16, *) {
            country = Locale.current.region?.identifier ?? "Unknown"
        }
        let keyboards = UITextInputMode.activeInputModes.compactMap { $0.primaryLanguage }
        let timezone = TimeZone.current.identifier
        let language = Locale.current.identifier
        let calendar = Calendar.current.identifier.debugDescription
        if #available(iOS 16, *) {
            currency = Locale.current.currency?.identifier ?? "Unknown"
        }
        
        return [
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
        let isMultitasking = UIDevice.current.isMultitaskingSupported
        
        systemInfo[SYSTEM_INFO_TOTAL_RAM] = totalRam
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

    private func getWifiSSID() -> String? {
        if let interfaces: NSArray = CNCopySupportedInterfaces() {
            for interface in interfaces {
                let interfaceName = interface as! String
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    return dict[kCNNetworkInfoKeySSID as String] as? String
                }
            }
        }
        return nil
    }

}

