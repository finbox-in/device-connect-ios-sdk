//
//  CreateUserRequest.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import Foundation

struct CreateUserRequest: Codable {
    let key: String
    let customerId: String
    let userHash: String
    let mobileModel: String
    let brand: String
    let contactsPermission: Bool
    let locationPermission: Bool
    let salt: String
    let sdkVersionName: String
    
    init(key: String, customerId: String, userHash: String, mobileModel: String, brand: String, contactsPermission: Bool, locationPermission: Bool, salt: String, sdkVersionName: String) {
        self.key = key
        self.customerId = customerId
        self.userHash = userHash
        self.mobileModel = mobileModel
        self.brand = brand
        self.contactsPermission = contactsPermission
        self.locationPermission = locationPermission
        self.salt = salt
        self.sdkVersionName = sdkVersionName
    }
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case customerId = "customer_id"
        case userHash = "ios_id"
        case mobileModel = "mobile_model"
        case brand = "brand"
        case contactsPermission = "contacts_permission"
        case locationPermission = "location_permission"
        case salt = "salt"
        case sdkVersionName = "sdkVersionName"
    }
}

