//
//  PermissionEntity.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 29/08/24.
//

import Foundation

class PermissionEntity: Codable {
    
    var permissionName: String?
    
    var granted: Bool?
    
    init() {
        self.permissionName = nil
        self.granted = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case permissionName = "permission_name"
        case granted = "granted"
    }
    
}
