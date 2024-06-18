//
//  FinBox.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import Foundation

public class FinBox {
    var userCreated = false
    
    public init() {}
    
    public func createUser() {
        userCreated = true
    }
    
    public func startPeriodicSync() {
        if userCreated {
            startPeriodicDataSync()
        }
    }
    
    private func startPeriodicDataSync() {
        // Fetch Device Data
        let deviceData = DeviceData().getDeviceData()
        print("Device Data", deviceData)
        
        // Fetch Location Data
        LocationData().getLocationData { location in
            print("Location Data: \(location)")
        }
    }
}
