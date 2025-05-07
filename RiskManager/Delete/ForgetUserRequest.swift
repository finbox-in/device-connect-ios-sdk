//
//  ForgetUserRequest.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 05/05/25.
//


import Foundation

/// Forget user request model
///
/// - Parameters:
///   - username: Unique ID of the user
///   - userHash: Unique ID of the device
///   - sdkVersionName: Version number of the SDK
struct ForgetUserRequest: Codable {
    
    /// Unique ID of the user
    let username: String
    
    /// Unique hash given to the device and the user
    let userHash: String
    
    /// SDK version name
    let sdkVersionName: String

    init(username: String, userHash: String, sdkVersionName: String) {
        self.username = username
        self.userHash = userHash
        self.sdkVersionName = sdkVersionName
    }
}
