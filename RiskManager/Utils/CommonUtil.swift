//
//  CommonUtil.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import CryptoKit
import Foundation

struct CommonUtil {
    
    // Salt string used in Hash calculation
    private static let saltString = "YRuQnIL0kmYCB9EHCy#H*Ys$K98vtp)"
    
    /// Convert SHA256Digest to Base64 Encoding
    static func getBase64Encode(bytes: SHA256Digest) -> String {
        return Data(bytes).base64EncodedString()
    }
    
    /// Convert String to Base64 Encoding
    static func getBase64Encode(text: String) -> String {
        // Convert string to data
        let data = text.data(using: .utf8)
        // Convert data to Encoded String
        return data!.base64EncodedString()
    }
    
    static func getBase64Decode(text: String) -> String {
        return String(data: Data(base64Encoded: text)!, encoding: .utf8)!
    }
    
    /// Encode String with SHA 256
    static func get256Encoded(message: String) -> String? {
        if let data = message.data(using: .utf8) {
            // Perform SHA 256 Encoding on the message
            let digest = SHA256.hash(data: data)
            // Convert SHA 256 bytes to Base64 Encoded string
            return CommonUtil.getBase64Encode(bytes: digest)
        } else {
            return nil
        }
    }
    
    /// Convert String to md5 Hash
    private static func getMd5Hash(salt: String) -> String? {
        if let data = salt.data(using: .utf8) {
            let digest = Insecure.MD5.hash(data: data)
            return digest.map { String(format: "%02hhx", $0) }.joined()
        } else {
            return nil
        }
    }
    
    /// Generate Hash to be used in API Headers
    static func getHash(token: String) -> String? {
        // Compute the md5 hash
        if let md5Hash = getMd5Hash(salt: token + saltString) {
            // Return the computed hash
            return get256Encoded(message: md5Hash + saltString)
        } else {
            return nil
        }
    }
    
    
}
