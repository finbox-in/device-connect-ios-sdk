//
//  NetworkUtils.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 31/07/24.
//

import Foundation


/// A utility struct for common network-related functions
struct NetworkUtils {
    
    /// Creates a URLRequest with the specified URL string.
    ///
    /// - Parameters:
    ///   - urlStr: The URL string to create the URLRequest.
    /// - Returns: A URLRequest object.
    static func getRequest(urlStr: String) -> URLRequest {
        // Force unwrap is used assuming that the input urlStr is a valid URL.
        // If there's a possibility of the URL being invalid, additional checks or error handling might be needed.
        return URLRequest(url: URL(string: urlStr)!)
    }
    
    /// Creates a POST URLRequest with the specified URL string and HTTP body data.
    ///
    /// - Parameters:
    ///   - urlStr: The URL string to create the URLRequest.
    ///   - body: The HTTP body data for the POST request.
    /// - Returns: A URLRequest object for a POST request or `nil` if the URL string is invalid or API Key is not found.
    static func postRequest(urlStr: String, body: Data) -> URLRequest? {
        guard let url = URL(string: urlStr) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        
        let userPref = UserPreference()
        let accessToken = userPref.accessToken
        
        guard let apiKey = userPref.apiKey else {
            return nil
        }
        
        urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.setValue(PACKAGE_VERSION_NAME, forHTTPHeaderField: "sdkVersionName")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        
        if let accessToken = accessToken {
            urlRequest.addValue("Bearer " + (userPref.accessToken!), forHTTPHeaderField: "Authorization")
            let hash = CommonUtil.getHash(token: userPref.accessToken!) ?? nil
            if let hash = hash {
                urlRequest.addValue(hash, forHTTPHeaderField: "hash")
            }
        }
        
        return urlRequest
    }
    
}
