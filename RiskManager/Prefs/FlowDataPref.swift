//
//  FlowDataPref.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import Foundation
import Combine

class FlowDataPref {
    
    private let userDefaults = UserDefaults(suiteName: USER_DEFAULT_SUITE_FLOW_DATA)
    
    var flowDevice: Bool {
        get {
            return userDefaults?.bool(forKey: USER_DEFAULT_FLOW_DEVICE) ?? false
        }
        set {
            userDefaults?.set(newValue, forKey: USER_DEFAULT_FLOW_DEVICE)
        }
    }
    
    var flowLocation: Bool {
        get {
            return userDefaults?.bool(forKey: USER_DEFAULT_FLOW_LOCATION) ?? false
        }
        set {
            userDefaults?.set(newValue, forKey: USER_DEFAULT_FLOW_LOCATION)
        }
    }
}
