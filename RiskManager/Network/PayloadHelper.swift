//
//  PayloadHelper.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 13/08/24.
//

import CryptoKit
import CommonCrypto
import Foundation

class PayloadHelper {
    
    internal let encrypKey = SymmetricKey(data: "jtKih9gLs2CvAZq8TrWxJtNTwt04eUCN".data(using: .utf8)!)
    internal let decryptKey = SymmetricKey(data: "jtKih9gLs2CvAZq8TrWxJtNTwt04eUCN".data(using: .utf8)!)
    internal let TAG_LENGTH = 16
    
    func encrypt(cipherText: Data, iv: String) -> String {
        // Compute Nonce/Iv
        let nonce = try! AES.GCM.Nonce(data: Data(base64Encoded: iv)!)
        // Encrypt
        let sealedBox = try! AES.GCM.seal(cipherText, using: encrypKey, nonce: nonce)
        // Return the cipher text
        return (sealedBox.ciphertext + sealedBox.tag).base64EncodedString()
    }
    
    func decrypt(cipherTagText: String, iv: String) -> Data? {
        // Compute Nonce/Iv
        let nonce = try! AES.GCM.Nonce(data: Data(base64Encoded: iv)!)
        
        // Base64 decode the cipher text and tag
        if let cipherTagTextData = Data(base64Encoded: cipherTagText) {
            
            // Get the size of the Cipher Text
            let ciphertextLength = cipherTagTextData.count - TAG_LENGTH
            // Get the cipher text
            let cipherText = cipherTagTextData.subdata(in: 0..<ciphertextLength)
            // Get the tag
            let tag = cipherTagTextData.subdata(in: ciphertextLength..<cipherTagTextData.count)
            
            // Decrypt
            let sealedBox = try! AES.GCM.SealedBox(nonce: nonce, ciphertext: cipherText, tag: tag)
            let decryptedData = try! AES.GCM.open(sealedBox, using: decryptKey)
            
            
            return decryptedData
        }
        
        return nil
    }
    
    /// Generate Initialization Vector
    func generateIv() -> String {
        // Left bound
        let leftLimit = 48
        // Right bound
        let rightLimit = 122
        // Total length of the random string
        let targetLength = 12
        
        // Create a char array with target length
        var charArray = [Character](repeating: " ", count: targetLength)
        
        for i in 0..<targetLength {
            // Get a random Int between the bounds
            let charInt = Int.random(in: leftLimit...rightLimit)
            // Add the character to the character array
            charArray[i] = Character(UnicodeScalar(charInt)!)
        }
        
        // Return the base 64 encoded iv
        return CommonUtil.getBase64Encode(text: String(charArray))
    }
    
}
