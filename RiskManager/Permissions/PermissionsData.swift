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
        let permissionEntityList = getPermissionsEntityList()
        let permissionsModel = self.getPermissionsModel(permissionEntityList: permissionEntityList)
        
        APIService.instance.syncPermissions(data: permissionsModel, syncType: SyncType.PERMISSIONS)
    }
    
    private func getPermissionsEntityList() -> [PermissionEntity] {
        let locationEntity = PermissionEntity()
        locationEntity.permissionName = "location"
        locationEntity.granted = LocationManager.shared.getLocationAuthStatus()
        
        let contactsEntity = PermissionEntity()
        contactsEntity.permissionName = "contacts"
        contactsEntity.granted = ContactsManager.shared.getContactsAuthStatus()
        
        let photosEntity = PermissionEntity()
        photosEntity.permissionName = "photos"
        photosEntity.granted = PhotoLibraryManager.shared.getPhotosAuthStatus()
        
        return [locationEntity, contactsEntity, photosEntity]
    }
    
    private func getPermissionsModel(permissionEntityList: [PermissionEntity]) -> PermissionModel {
        let permissionModel = PermissionModel()
        let accountSuite = UserPreference()
        let syncSuite = SyncPref()
        
        permissionModel.batchId = CommonUtil.getMd5Hash(UUID().uuidString)
        permissionModel.username = accountSuite.userName
        permissionModel.userHash = accountSuite.userHash
        permissionModel.sdkVersionName = CommonUtil.getVersionName()
        permissionModel.syncId = syncSuite.syncId
        permissionModel.syncMechanism = syncSuite.syncMechanism
        permissionModel.isRealTime = syncSuite.isRealTime
        permissionModel.permissionEntityList = permissionEntityList
        
        return permissionModel
    }
}
