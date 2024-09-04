//
//  PermissionModel.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 29/08/24.
//

final class PermissionModel: CommonRequest {
    
    var permissionEntityList: [PermissionEntity]?
    
    // Custom Initializer
    override init() {
        self.permissionEntityList = nil
        super.init()
    }
    
    // Initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        permissionEntityList = try container.decodeIfPresent([PermissionEntity].self, forKey: .permissionEntityList)
        try super.init(from: decoder)
    }
    
    // Method for encoding
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(permissionEntityList, forKey: .permissionEntityList)
        try super.encode(to: encoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case permissionEntityList = "permission"
    }
}
