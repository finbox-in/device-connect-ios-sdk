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

/// Only entry point to the Library
public class FinBox {

    public init() {}
    
    // Logger instance
    private static let logger = Logger()
    
    /// Makes a request to an endpoint to check if the user exists; if not, creates the user.
    ///
    /// - Parameters:
    ///   - apiKey: API Key.
    ///   - customerId: Unique ID given to the borrower.
    ///   - success: Callback interface that notifies about the success creating or fetching the user..
    ///   - error:  Callback interface that notifies about the failure of creating or fetching the user.
    public static func createUser(apiKey: String, customerId: String, success: @escaping (String) -> Void,
                           error: @escaping (FinBoxErrorCode) -> Void) {
        
        // Validate the data
        // Crash the application if the values are empty
        let valid = try! isDataValid(apiKey: apiKey, customerId: customerId)
        
        
        if (valid) {
            // Save API Key
            let accountSuite = UserPreference()
            accountSuite.apiKey = apiKey
            
            // Create a unique id and save it to user defaults
            let uuidStr = UUID().uuidString
            let vendorId = UIDevice.current.identifierForVendor?.uuidString ?? uuidStr
            
            let iosId = CommonUtil.getMd5Hash(vendorId) ?? uuidStr
            logger.debug("Generated Unique identifier \(iosId)")
            
            // Create the create user payload
            let createUserRequest = getCreateUserPayload(apiKey: apiKey, customerId: customerId, iosId: iosId)
            
            APIService.instance.createUser(
                createUserRequest: createUserRequest,
                createError: error, accountSuite: accountSuite,
                success: { accessToken, createUserResponse in
                    // Save Account Details
                    saveAccountUserDefaults(username: createUserResponse.username, userHash: createUserResponse.userHash, accessToken: accessToken, iosId: createUserRequest.userHash)
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
    
    private static func getUniqueId() -> String {
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
    
    private static func saveAccountUserDefaults(username: String, userHash: String, accessToken: String, iosId: String) {
        let userPref = UserPreference()
        userPref.userName = username
        userPref.userHash = userHash
        userPref.accessToken = accessToken
        userPref.iosId = iosId
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
        
        FinBox.syncDeviceData()
        
        DispatchQueue.main.async {
            self.startPermissionsSync()
            FinBox.syncLocationData()
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
    
    /// Sync Device Details
    public static func syncDeviceData() {
        // Fetch Device Data
        let deviceData = DeviceData()
        deviceData.syncDeviceData()
    }
    
    /// Sync Location Data
    public static func syncLocationData() {
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
        
        let forgetUserRequest = ForgetUserRequest(username: userHash!, userHash: username!, sdkVersionName: CommonUtil.getVersionName())
        
        APIService.instance.deleteData(forgetUserRequest: forgetUserRequest)
    }
    
    /// Stop Periodic Sync
    public func stopPeriodicSync() {
        // Function not implemented yet
    }
    
    // Sync Once
    public func syncOnce() {
        saveSyncId()
        
        // Start Instant Sync
        
        FinBox.syncDeviceData()
        
        DispatchQueue.main.async {
            self.startPermissionsSync()
            FinBox.syncLocationData()
        }
    }
    
    /// Resets all saved data
    public static func resetData() {
        clearPrefs()
    }
    
    private static func clearPrefs() {
        PrefUtils().clearAllPrefs()
    }
}
