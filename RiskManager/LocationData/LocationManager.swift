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
    
    // Flag to control visibility of Alert
    // Used to avoid calling show alert when it's already visible
    var alertPresented = false
    
    // Flag to track access grant status
    // Used to control visibility of alert
    var accessGranted = true
    
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
        
        // Request location permissions
        requestLocationAuthorization()
    }
    
    // Start updating location
    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Stop updating location
    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // Request authorization
    private func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    // To handle and process new location updates.
    // This method is called whenever new location data is available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location              // Update current location
            locationCompletionHandler?(location)    // Push data to callback
            locationCompletionHandler = nil         // Clear the handler after it's called
        }
    }
    
    // To handle changes in location permission status.
    // This method is called whenever the app’s authorization status for using location services changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            debugPrint("Access granted.")
            accessGranted = true
            startUpdatingLocation()
        case .denied:
            debugPrint("Location access denied by the user.")
            showLocationAccessDeniedAlert()
        case .restricted:
            debugPrint("Location access is restricted.")
        case .notDetermined:
            requestLocationAuthorization()
            debugPrint("Requesting location access.")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    // To handle errors that occur during location updates.
    // This method is called whenever the location manager fails to retrieve a location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location update failure
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                debugPrint("Location unknown. Trying again...")
                self.startUpdatingLocation()
            case .denied:
                debugPrint("Access to location services denied.")
                showLocationAccessDeniedAlert()
            case .network:
                debugPrint("Network error. Check your connection.")
                // Handle network error, suggest the user to check network connectivity
            default:
                debugPrint("Other Core Location error: \(clError.localizedDescription)")
            }
        } else {
            debugPrint("Unknown error: \(error.localizedDescription)")
        }
    }
    
    // Show alert to request location access
    private func showLocationAccessDeniedAlert() {
        if accessGranted { return }                 // If access is granted, don't show the alert
        if alertPresented { return }                // If alert is already displayed, don't show again
        alertPresented = true                       // Toggle flag when alert is displayed
        
        // The purpose of this code snippet is to obtain a reference to the topmost view controller in your application's view controller hierarchy.
        // This is often necessary when you want to present a new view controller modally (such as an alert, action sheet, or another screen), because UIKit requires a reference to a view controller to manage the presentation.
        guard let topController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        // Create alert
        let alert = UIAlertController(
            title: "Location Permission Needed",
            message: "Please enable location permissions in Settings to continue using the app.",
            preferredStyle: .alert
        )
        
        // Create "Go To Settings" action
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            self.alertPresented = false
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        // Add action to alert
        alert.addAction(settingsAction)
        
        // Show alert
        topController.present(alert, animated: true, completion: nil)
    }
    
    // Get current location with a completion handler
    func getLocationData(completion: @escaping (CLLocation?) -> Void) {
        // If currentLocation is already available, immediately call the completion handler with it
        if let currentLocation = currentLocation {
            completion(currentLocation)
        } else {
            // If currentLocation is nil, store the completion handler for future use
            locationCompletionHandler = completion
            startUpdatingLocation()
        }
    }
}

