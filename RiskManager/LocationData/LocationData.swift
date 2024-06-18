//
//  LocationData.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import Foundation
import CoreLocation

/**
 A utility class for fetching device location data asynchronously using the shared LocationManager instance.
 */
class LocationData {
    
    // Singleton instance
    let locationManager = LocationManager.shared
    
    /**
     Fetches location data asynchronously and provides it via a completion handler
     */
    func getLocationData(completion: @escaping ([String: Any]) -> Void) {
        // Call LocationManager's getLocationData method to retrieve current location
        locationManager.getLocationData { location in
            var locationData: [String: Any] = [:]
            guard let location = location else {
                print("Failed to get location")
                completion(locationData)
                return
            }
            if location.coordinate.latitude.isFinite {
                locationData[LATITUDE_KEY] = location.coordinate.latitude
            } else {
                locationData[LATITUDE_KEY] = "Latitude not available"
            }
            
            if location.coordinate.longitude.isFinite {
                locationData[LONGITUDE_KEY] = location.coordinate.longitude
            } else {
                locationData[LONGITUDE_KEY] = "Longitude not available"
            }
            completion(locationData)
        }
    }
    
}
