//
//  UserPrefs.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 31/07/24.
//

import Foundation

import Combine


/// UserDefaults Class for storing basic user details
class UserPreference {
    
    // Instance of user defaults
    private let userDefaults = UserDefaults.standard
    
    // API Key
    var apiKey: String? {
        get {
            return userDefaults.object(forKey: FINBOX_DEVICE_CONNECT_API_KEY) as? String ?? nil
        }
        set {
            userDefaults.set(newValue, forKey: FINBOX_DEVICE_CONNECT_API_KEY)
        }
    }
    
}
