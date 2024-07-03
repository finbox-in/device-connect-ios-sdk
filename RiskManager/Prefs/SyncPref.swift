//
//  SyncPrefs.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 02/07/24.
//

import Foundation

/// UserDefaults Class for storing Sync Data
class SyncPref {
    
    // Instance of user defaults
    private let userDefaults = UserDefaults.standard
    
    // Sync Frequency
    var syncFrequency: TimeInterval {
        get {
            // If value from Defaults is 0, send default
            return UserDefaults.standard.double(forKey: PREF_KEY_SYNC_FREQUENCY) == 0 ? DEFAULTSYNC_FREQUENCY : UserDefaults.standard.double(forKey: PREF_KEY_SYNC_FREQUENCY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PREF_KEY_SYNC_FREQUENCY)
        }
    }
}
