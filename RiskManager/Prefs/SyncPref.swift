//
//  SyncPrefs.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 02/07/24.
//

import Foundation
import Combine

/// UserDefaults Class for storing Sync Data
class SyncPref {
    
    // Instance of user defaults
    private let userDefaults = UserDefaults(suiteName: USER_DEFAULT_SUITE_SYNC_PREF)
    
    // Sync Frequency
    var syncFrequency: TimeInterval {
        get {
            guard let savedSyncFrequency = userDefaults?.double(forKey: PREF_KEY_SYNC_FREQUENCY) else {
                return DEFAULT_SYNC_FREQUENCY
            }
            // If value from Defaults is 0, send default
            return savedSyncFrequency > 0 ? savedSyncFrequency : DEFAULT_SYNC_FREQUENCY
        }
        set {
            userDefaults?.set(newValue, forKey: PREF_KEY_SYNC_FREQUENCY)
        }
    }
    
    // Sync Mechanism
    var syncMechanism: Int {
        get {
            // Return the value stored in preferences
            return userDefaults?.integer(forKey: PREF_KEY_SYNC_MECHANISM) ?? -1
        }
        set {
            userDefaults?.set(newValue, forKey: PREF_KEY_SYNC_MECHANISM)
        }
    }
    
    // Sync Id
    var syncId: Int64 {
        get {
            // Retrieve the saved sync number
            let savedSyncId = userDefaults?.integer(forKey: PREF_KEY_SYNC_ID) as NSNumber?
            return savedSyncId?.int64Value ?? 0
        }
        set {
            userDefaults?.set(NSNumber(value: newValue), forKey: PREF_KEY_SYNC_ID)
        }
    }
    
    // Sync Id
    var isRealTime: Bool {
        get {
            // Retrieve the details about Realtime status
            return userDefaults?.bool(forKey: PREF_KEY_IS_REAL_TIME) ?? false
        }
        set {
            userDefaults?.set(newValue, forKey: PREF_KEY_IS_REAL_TIME)
        }
    }
    
    
}
