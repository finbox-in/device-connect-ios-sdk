//
//  FinBox.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import Foundation
import OSLog
import UIKit
import Contacts
import CoreLocation

public class FinBox {

    public init() {}
    
    // Logger instance
    private static let logger = Logger()
    
    public static func createUser(apiKey: String, customerId: String, success: @escaping (String) -> Void,
                           error: @escaping (FinBoxErrorCode) -> Void) {
        
        // Validate the data
        // Crash the application if the values are empty
        let valid = try! isDataValid(apiKey: apiKey, customerId: customerId)
        
        
        if (valid) {
            // Save API Key
            let accountSuite = UserPreference()
            accountSuite.apiKey = apiKey
            
            // Create a unique id and save it to keychain
            // Get the unique id from key chain, if already created
            let iosId = getUniqueId()
            logger.debug("Generated Unique identifier \(iosId)")
            
            // Create the create user payload
            let createUserRequest = getCreateUserPayload(apiKey: apiKey, customerId: customerId, iosId: iosId)
            
            APIService.instance.createUser(
                createUserRequest: createUserRequest,
                createError: error, accountSuite: accountSuite,
                success: { accessToken, createUserResponse in
                    // Save Account Details
                    saveAccountUserDefaults(username: createUserResponse.username, userHash: createUserResponse.userHash, accessToken: accessToken)
                    saveFlowDataDefaults(flowData: createUserResponse.flowData)
                    success(accessToken)
                }
            )
        }
    }
    
    private static func getCreateUserPayload(apiKey: String, customerId: String, iosId: String) -> CreateUserRequest {
            // Mobile Model
            let mobileModel = UIDevice.current.model
            // Brand of the device
            let brand = if mobileModel.contains("iPhone") || mobileModel.contains("iPad") || mobileModel.contains("iPod") {
                "Apple"
            } else {
                "Unknown"
            }
            
            // Compute Salt
            let salt = AuthClient().getSalt(customerId: customerId)
            
            // Get the location permission granted status
            let locationStatus = CLLocationManager().authorizationStatus
            let locationPermissionGranted = locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse
            
            // Get the contacts permission granted status
            let contactPermissionStatus = CNContactStore.authorizationStatus(for: .contacts)
            let contactPermissionGranted = contactPermissionStatus == .authorized
            
            // Create a User Model
        return CreateUserRequest(key: apiKey, customerId: customerId, userHash: iosId, mobileModel: mobileModel, brand: brand, contactsPermission: contactPermissionGranted, locationPermission: locationPermissionGranted, salt: salt, sdkVersionName: CommonUtil.getVersionName())
        }
    
    public static func getUniqueId() -> String {
        // Create a secret account details
        let server = "in.finbox.mobileriskmanager" + "_" + ""
        
        
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier!,
            kSecAttrAccount as String: server, // Optional, if used when storing
            kSecReturnData as String: kCFBooleanTrue as CFBoolean, // Specify returning data
            kSecMatchLimit as String: kSecMatchLimitOne // Only return one item
        ]
        
        var dataRef: AnyObject?
        let queryStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataRef)
        
        if queryStatus == errSecSuccess {
            if let data = dataRef as? Data {
                // Return the secret key
                return String(decoding: data, as: UTF8.self)
            } else {
                logger.error("Unexpected data type retrieved from Keychain")
            }
        } else {
            logger.error("Keychain access failed with status \(queryStatus)")
            // Handle potential errors (e.g., item not found)
        }
        
        // Generate a fresh unique id
        let uuidStr = UUID().uuidString
        let uniqueId = CommonUtil.getMd5Hash(uuidStr) ?? uuidStr
        
        // Write the data to the
        writeUniqueId(uniqueId: uniqueId, account: server)
        
        return uniqueId
    }
    
    private static func writeUniqueId(uniqueId: String, account: String) {
        // Create the secret data
        let secretKeyData = Data(uniqueId.utf8)
        logger.debug("Secret Key data \(secretKeyData)")
        
        // Create the chain item to write the data
        let keychainItem: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Bundle.main.bundleIdentifier!,
            kSecAttrAccount as String: account,
            kSecValueData as String: secretKeyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly // Accessibility options
        ]
        
        // Write the data to the keychain
        let writeStatus = SecItemAdd(keychainItem as CFDictionary, nil)
        
        if writeStatus == errSecSuccess {
            // Key chain data is successfully written
            logger.debug("Secret key stored")
        } else {
            // Failed to write the data to key chain
            logger.error("Secret key failed to store \(writeStatus)")
        }
    }
    
    private static func isDataValid(apiKey: String, customerId: String) throws -> Bool {
        if apiKey.isEmpty {
            throw RiskManagerError.empty(message: "Api Key is empty")
        } else if customerId.isEmpty {
            throw RiskManagerError.empty(message: "Customer id is empty")
        }
        return true
    }
    
    private static func saveAccountUserDefaults(username: String, userHash: String, accessToken: String) {
        let userPref = UserPreference()
        userPref.userName = username
        userPref.userHash = userHash
        userPref.accessToken = accessToken
    }
    
    private static func saveFlowDataDefaults(flowData: FlowData?) {
        guard let flowData = flowData else {
            return
        }
        
        let flowDataSuite = UserDefaults(suiteName: USER_DEFAULT_SUITE_FLOW_DATA)
        flowDataSuite?.set(flowData.flowDevice, forKey: USER_DEFAULT_FLOW_DEVICE)
        flowDataSuite?.set(flowData.flowLocation, forKey: USER_DEFAULT_FLOW_LOCATION)
    }
    
    public func startPeriodicSync() {
        saveSyncId()
        
        // Start Instant Sync
        
        self.startDeviceDataSync()
        
        DispatchQueue.main.async {
            self.startPermissionsSync()
            self.startLocationSync()
        }
        
        // Create and start a Periodic Sync Task
        // TODO: Add impl of startPeriodicTask()
        // startPeriodicTask()
    }
    
    private func saveSyncId() {
        let syncSuite = SyncPref()
        // Update Sync Id
        syncSuite.syncId = syncSuite.syncId + 1
        // Update Sync Mechanism
        syncSuite.syncMechanism = 8
    }
    
    private func startDeviceDataSync() {
        // Fetch Device Data
        let deviceData = DeviceData()
        deviceData.syncDeviceData()
    }
    
    private func startLocationSync() {
        // Fetch Location Data
        let locationData = LocationData()
        locationData.syncLocationData()
    }
    
    private func startPermissionsSync() {
        PermissionsData().syncPermissionsData()
    }

    /// Forgets/Deletes the user data
    public static func forgetUser() {
        let userPref = UserPreference()
        let username = userPref.userName
        let userHash = userPref.userHash
        
        let forgetUserRequest = ForgetUserRequest(username: username!, userHash: userHash!, sdkVersionName: "0.3.0")
        
        APIService.instance.deleteData(forgetUserRequest: forgetUserRequest)
    }
    
    /// Stop Periodic Sync
    public static func stopPeriodicSync() {
        // Function not implemented yet
    }
}
