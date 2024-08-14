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
    private let userDefaults = UserDefaults(suiteName: USER_DEFAULT_SUITE_ACCOUNT_DETAILS)
    
    // API Key
    var apiKey: String? {
        get {
            return userDefaults?.object(forKey: FINBOX_DEVICE_CONNECT_API_KEY) as? String ?? nil
        }
        set {
            userDefaults?.set(newValue, forKey: FINBOX_DEVICE_CONNECT_API_KEY)
        }
    }
    
    var userName: String? {
        get {
            return userDefaults?.object(forKey: USER_DEFAULT_USER_NAME) as? String ?? nil
        }
        set {
            userDefaults?.set(newValue, forKey: USER_DEFAULT_USER_NAME)
        }
    }
    
    var userHash: String? {
        get {
            return userDefaults?.object(forKey: USER_DEFAULT_USER_HASH) as? String ?? nil
        }
        set {
            userDefaults?.set(newValue, forKey: USER_DEFAULT_USER_HASH)
        }
    }
    
    var accessToken: String? {
        get {
            return userDefaults?.object(forKey: USER_DEFAULT_ACCESS_TOKEN) as? String ?? nil
        }
        set {
            userDefaults?.set(newValue, forKey: USER_DEFAULT_ACCESS_TOKEN)
        }
    }
}
