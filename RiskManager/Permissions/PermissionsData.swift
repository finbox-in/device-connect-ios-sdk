//
//  PermissionsData.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 29/08/24.
//

import Foundation
import CoreLocation

class PermissionsData {
    
    init() {
        
    }
    
    func syncPermissionsData() {
        let permissions = readPermissions()
        let permissionEntity = self.getPermissionsEntity(permissionGranted: permissions)
        let permissionsModel = self.getPermissionsModel(permissionEntity: permissionEntity)
        
        APIService.instance.syncPermissions(data: permissionsModel, syncType: SyncType.PERMISSIONS)
    }
    
    private func readPermissions() -> Bool {
        let locationAuthStatus = LocationManager.shared.getLocationAuthStatus()
        return locationAuthStatus
    }
    
    private func getPermissionsEntity(permissionGranted: Bool) -> PermissionEntity {
        let permissionEntity = PermissionEntity()
        
        permissionEntity.permissionName = "location"
        permissionEntity.granted = permissionGranted
        
        return permissionEntity
    }
    
    private func getPermissionsModel(permissionEntity: PermissionEntity) -> PermissionModel {
        let permissionModel = PermissionModel()
        let accountSuite = UserPreference()
        let syncSuite = SyncPref()
        
        permissionModel.batchId = UUID().uuidString
        permissionModel.username = accountSuite.userName
        permissionModel.userHash = accountSuite.userHash
        permissionModel.sdkVersionName = VERSION_NAME
        permissionModel.syncId = syncSuite.syncId
        permissionModel.syncMechanism = syncSuite.syncMechanism
        permissionModel.isRealTime = syncSuite.isRealTime
        permissionModel.permissionEntityList = [permissionEntity]
        
        return permissionModel
    }
}
