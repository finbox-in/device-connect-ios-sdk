//
//  LocationManager.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 10/06/24.
//

import CoreLocation
import Foundation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // Singleton instance for easy access
    static let shared = LocationManager()
    
    // CLLocationManager instance
    private let locationManager = CLLocationManager()
    
    // Current location
    var currentLocation: CLLocation?
    
    // Completion handler for getLocationData
    private var locationCompletionHandler: ((CLLocation?) -> Void)?
    
    private override init() {
        super.init()
        
        // Setting the delegate
        locationManager.delegate = self
        
        // Configure location manager properties
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    // Start updating location
    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Stop updating location
    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    // To handle and process new location updates.
    // This method is called whenever new location data is available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location              // Update current location
            locationCompletionHandler?(location)    // Push data to callback
            locationCompletionHandler = nil         // Clear the handler after it's called
            stopUpdatingLocation()
        }
    }
    
    // To handle changes in location permission status.
    // This method is called whenever the app’s authorization status for using location services changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            debugPrint("Authorization: Access granted.")
            startUpdatingLocation()
        case .denied:
            debugPrint("Authorization: Location access denied by the user.")
        case .restricted:
            debugPrint("Authorization: Location access is restricted.")
        case .notDetermined:
            debugPrint("Authorization: Requesting location access.")
        @unknown default:
            fatalError("Authorization: Unknown authorization status")
        }
    }
    
    // To handle errors that occur during location updates.
    // This method is called whenever the location manager fails to retrieve a location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location update failure
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                debugPrint("Error: Location unknown. Trying again...")
                self.startUpdatingLocation()
            case .denied:
                debugPrint("Error: Access to location services denied.")
            case .network:
                debugPrint("Error: Network error. Check your connection.")
                // Handle network error, suggest the user to check network connectivity
            default:
                debugPrint("Error: Other Core Location error: \(clError.localizedDescription)")
            }
        } else {
            debugPrint("Error: Unknown error: \(error.localizedDescription)")
        }
    }
    
    // Get current location with a completion handler
    // If the location data is null, stores the callback and fetches the data again. When found, returns location in the callback.
    func getLocationData(completion: @escaping (CLLocation?) -> Void) {
        // If currentLocation is already available, immediately call the completion handler with it
        if let currentLocation = currentLocation {
            stopUpdatingLocation()
            locationCompletionHandler = nil
            completion(currentLocation)
        } else {
            // If currentLocation is nil, store the completion handler for future (// Push data to callback)
            locationCompletionHandler = completion
            startUpdatingLocation()
        }
    }
    
    // Get Location Authorization Status
    // Returns true if granted, false otherwise
    func getLocationAuthStatus() -> Bool {
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .restricted, .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
}

