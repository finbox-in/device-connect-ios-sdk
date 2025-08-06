//
//  PrefUtils.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 07/05/25.
//

/// A utility class for managing and clearing app-related `UserDefaults` preferences.
class PrefUtils {
    
    /// Clears all the predefined UserDefaults suites used within the SDK.
    ///
    /// This includes sync preferences, account details, and flow-related data.
    func clearAllPrefs() {
        clearCustomSuites(suiteName: USER_DEFAULT_SUITE_SYNC_PREF)
        clearCustomSuites(suiteName: USER_DEFAULT_SUITE_ACCOUNT_DETAILS)
        clearCustomSuites(suiteName: USER_DEFAULT_SUITE_FLOW_DATA)
    }
    
    /// Clears all values stored in the specified UserDefaults suite.
    ///
    /// - Parameter suiteName: The suite name of the UserDefaults to clear.
    ///
    /// This function removes all key-value pairs for the given suite.
    func clearCustomSuites(suiteName: String) {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
        UserDefaults.standard.synchronize()
    }
}
