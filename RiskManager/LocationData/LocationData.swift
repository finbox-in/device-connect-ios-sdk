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
    
    let accountSuite = UserPreference()
    let syncSuite = SyncPref()
    let flowSuite = FlowDataPref()
    
    init() {
        
    }
    
    private func getLocationEntity(location: CLLocation) -> LocationEntity {
        let locationEntity = LocationEntity()
        
        if location.coordinate.latitude.isFinite {
            locationEntity.latitude = location.coordinate.latitude
        } else {
            
        }
        
        if location.coordinate.longitude.isFinite {
            locationEntity.longitude = location.coordinate.longitude
        } else {
            
        }
        
        if location.horizontalAccuracy.isFinite {
            locationEntity.accuracy = location.horizontalAccuracy
        } else {
            
        }
        
        if location.timestamp.timeIntervalSince1970.isFinite {
            locationEntity.time = location.timestamp.timeIntervalSince1970
        } else {
            
        }
        
        // Compute the location hash
        if let username = accountSuite.userName {
            let locationHash = username + String(describing: locationEntity.latitude) +
            String(describing: locationEntity.longitude) + String(describing: locationEntity.time)
            
            // Compute the hash
            locationEntity.id = CommonUtil.getMd5Hash(locationHash);
        }
        
        return locationEntity
    }
    
    private func getLocationModel(locationEntity: LocationEntity) -> LocationModel {
        let locationModel = LocationModel()
        locationModel.batchId = UUID().uuidString
        locationModel.username = accountSuite.userName
        locationModel.userHash = accountSuite.userHash
        locationModel.sdkVersionName = VERSION_NAME
        locationModel.syncId = syncSuite.syncId
        locationModel.syncMechanism = syncSuite.syncMechanism
        locationModel.isRealTime = syncSuite.isRealTime
        locationModel.locationEntityList = [locationEntity]
        return locationModel
    }
    
    /**
     Fetches location data asynchronously and provides it via a completion handler
     */
    func syncLocationData() {
        if (flowSuite.flowLocation && locationManager.getLocationAuthStatus()) {
            // Call LocationManager to retrieve current location
            locationManager.getLocationData { location in
                if let location = location {
                    
                    // Create the location variable
                    let locationEntity = self.getLocationEntity(location: location)
                    
                    let locationModel = self.getLocationModel(locationEntity: locationEntity)
                    
                    // Send the data to the server
                    APIService.instance.syncLocationData(data: locationModel, syncItem: SyncType.LOCATION)
                } else {
                    debugPrint("No location data")
                }
            }
        } else {
            debugPrint("Location Access Denied?", locationManager.getLocationAuthStatus())
            debugPrint("Location Denied from Server?", flowSuite.flowLocation)
        }
    }
    
}
