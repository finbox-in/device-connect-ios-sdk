//
//  DeviceInfo.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import Foundation
import SystemConfiguration
import CoreTelephony
import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreMotion
import Network

// Ads
import AdSupport
import AppTrackingTransparency

class DeviceInfoExt {
    
    func getNetworkType() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return "NO INTERNET"
        }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(reachability, &flags) else {
            return "NO INTERNET"
        }
        
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if isReachable {
            if isWWAN {
                let networkInfo = CTTelephonyNetworkInfo()
                let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
                
                guard let carrierTypeName = carrierType?.first?.value else {
                    return "UNKNOWN"
                }
                
                switch carrierTypeName {
                case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                    return "2G"
                case CTRadioAccessTechnologyLTE:
                    return "4G"
                default:
                    return "3G"
                }
            } else {
                return "WIFI"
            }
        } else {
            return "NO INTERNET"
        }
    }
    
    func getOSInfo(version: Int)->String {
        if (version == 0) {
            // Returns 17.0.0
            let os = ProcessInfo.processInfo.operatingSystemVersion
            return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
        } else {
            // Returns 17.0
            let systemVersion = UIDevice.current.systemVersion
            return systemVersion
        }
    }
    
    func getDeviceCPUArchitecture() -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return "Machine: \(String(cString: machine))"
    }
    
    // TODO: Get back on this
    func getSSID() -> String {
        if let interfaceList = CNCopySupportedInterfaces() as? [String] {
            debugPrint("interfaceList")
            for interface in interfaceList {
                debugPrint("for interfaceList")
                if let networkInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
                    debugPrint("networkInfo")
                    if let ssid = networkInfo[kCNNetworkInfoKeySSID] as? String {
                        return "SSID: \(ssid)"
                    }
                }
            }
        }
        return "No Data Found"
    }
    
    // Screen wake time
    func getTimeSinceBoot() -> String {
        var msg = "Elapsed Time: \(ProcessInfo.processInfo.systemUptime)"
        //        msg.append(" : \(CMLogItem().timestamp)")
        return msg
    }
    
    func getNetworkStateName() -> String {
        let semaphore = DispatchSemaphore(value: 0)
        var status = ""
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                status = "Connected"
            } else {
                status = "Not Connected"
            }
            
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        // Wait for the semaphore to be signaled (when the path update handler is called)
        _ = semaphore.wait(timeout: .now() + 10) // Adjust the timeout as needed
        
        // Stop monitoring once we have the result
        monitor.cancel()
        
        return status
    }
    
    func getActiveNetworkTypeName() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return "NO INTERNET"
        }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(reachability, &flags) else {
            return "NO INTERNET"
        }
        
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if isReachable {
            if isWWAN {
                let networkInfo = CTTelephonyNetworkInfo()
                let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
                
                guard let carrierTypeName = carrierType?.first?.value else {
                    return "UNKNOWN"
                }
                
                return "MOBILE"
            } else {
                return "WIFI"
            }
        } else {
            return "NO INTERNET"
        }
    }
    
    // Wait for view to load or assign a button click
    func getADID() -> String {
        var res = ""
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown and we are authorized
                    // Now that we are authorized we can get the IDFA
                    res = "ID: \(ASIdentifierManager.shared().advertisingIdentifier)"
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    res = "Denied"
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    res = "Not Determined"
                case .restricted:
                    res = "Restricted"
                @unknown default:
                    res = "Unknown"
                }
            }
        }
        return res
    }
    
    func getCarrierName() -> String {
        // Setup the Network Info and create a CTCarrier object
        let networkInfo = CTTelephonyNetworkInfo()
        let carriers = networkInfo.serviceSubscriberCellularProviders

        guard let carriers = carriers else {
            return "No Carriers"
        }
        
        var carrierNames: [String] = []
        
        for (_, carrier) in carriers {
            if let carrierName = carrier.isoCountryCode {
                carrierNames.append(carrierName)
            }
        }
        
        
        return "Carrier Name: \(carrierNames)"
    }
    
    func getCountryISOFromSIM() -> String {
        var state = self.getNetworkStateName()
        if (state == "Connected") {
            if let carriers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                
                var countryCodes: [String] = []
                
                for (_, carrier) in carriers {
                    if let countryCode = carrier.isoCountryCode {
                        countryCodes.append(countryCode)
                    }
                }
                return "countryCodes: \(countryCodes)"
            } else {
                print("Unable to retrieve cellular provider information.")
            }
        }
        
        // Else
        return getISO3CountryCode()
    }
    
    func getISO3CountryCode() -> String {
        if let iso3CountryCode = Locale.current.regionCode {
            return "ISO 3166-1 alpha-3 three-letter country code: \(iso3CountryCode)"
        } else {
            return "Unable to determine the country code."
        }
    }
    
    // In iOS, the screen uses a system of points to define dimensions, where one point does not necessarily equal one pixel. The screen scale factor (UIScreen.main.scale) indicates how many pixels are there in a single point. For example, on a standard retina display, the scale factor is 2.0, meaning there are 2 pixels for each point.
    
    // So, to get the width and height in pixels, you need to multiply the width and height in points by the scale factor. This ensures that you get the actual pixel dimensions on the screen. If you're working with images, UI elements, or anything else where pixel precision matters, using the scale factor is important.
    
    func getDisplayWidthPixels() -> String {
        let screenWidth = UIScreen.main.bounds.width * UIScreen.main.scale
        return "Width: \(screenWidth) + [\(UIScreen.main.bounds.width)]"
    }
    
    func getDisplayHeightPixels() -> String {
        let screenHeight = UIScreen.main.bounds.height * UIScreen.main.scale
        return "Height: \(screenHeight) + [\(UIScreen.main.bounds.height)]"
    }
    
    func enabledInputMethodSubtypes() -> String {
        return "Types: \(UITextInputMode.activeInputModes)"
    }
    
    func getVendorIdentifier() -> String {
        if let vendorIdentifier = UIDevice.current.identifierForVendor {
            return "\(vendorIdentifier.uuidString)"
        } else {
            print("Unable to retrieve vendor identifier")
            return ""
        }
    }

    func getCarrierInfo() -> String {
        let telephonyNetworkInfo = CTTelephonyNetworkInfo()
        var st = ""
        
        if let carrier = telephonyNetworkInfo.subscriberCellularProvider {
            print("Carrier Name: \(carrier.carrierName ?? "Unknown")")
            print("Mobile Country Code (MCC): \(carrier.mobileCountryCode ?? "Unknown")")
            st.append("MCC: \(carrier.mobileCountryCode)")
            print("Mobile Network Code (MNC): \(carrier.mobileNetworkCode ?? "Unknown")")
            st.append("MNC: \(carrier.mobileNetworkCode)")
        } else {
            print("Unable to retrieve carrier information")
        }
        
        return st
    }
    
    func getISO3LanguageCode() -> String {
        if let iso3LanguageCode = Locale.current.language.languageCode {
            return "\(iso3LanguageCode)"
        } else {
            return "null"
        }
    }
    
    func getElapsedTimeSinceBoot() -> String {
        let elapsedTimeMilliseconds = Int(ProcessInfo.processInfo.systemUptime * 1000)
        return "\(elapsedTimeMilliseconds)"
    }
}
