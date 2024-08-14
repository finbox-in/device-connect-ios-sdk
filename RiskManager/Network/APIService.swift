//
//  APIService.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 31/07/24.
//

import Foundation
import OSLog

/// Service struct that encapsulates API-related functionalities
struct APIService {
    
    /// Singleton instance of the `APIService`.
    static let instance = APIService()
    
    // Logger instance
    private let logger = Logger()

    func createUser(createUserRequest: CreateUserRequest, error: @escaping (FinBoxErrorCode) -> Void, accountSuite: UserPreference, success: @escaping (String, CreateUserResponse) -> Void) {
        
        let requestBody = self.getCreateUserRequestBody(createUserRequest: createUserRequest, error: error)
        
        guard let requestBody = requestBody else {
            debugPrint("Request Body is null")
            return
        }
        
        // Create the CreateUser URL
        let url = AUTH_BASE_URL + CREATE_USER_ENDPOINT
        
        let requestParams = NetworkUtils.postRequest(urlStr: url, body: requestBody)
        
        guard let requestParams = requestParams else {
            debugPrint("Request Params null")
            return
        }
        
        // Make the API call using URLSession
        let task = URLSession.shared.dataTask(with: requestParams) { (data, response, error) in
            if let apiError = error {
                logger.error("Error during API call: \(error)")
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                logger.error("Invalid data or response received from API")
                return
            }
            
            logger.info("API response status code: \(httpResponse.statusCode)")
            
            parseResponse(response: data, success: success)
        }
        
        task.resume()
    }
    
    private func parseResponse(response: Data, success: @escaping (String, CreateUserResponse) -> Void) {
        let decoder = JSONDecoder()
        guard let createUserEncryptResponse = try? decoder.decode(EncryptPayload.self, from: response) else {
            // Handle encoding errors
            logger.error("Failed to parse Encrypt Response JSON")
            return
        }
        
        let payloadHelper = PayloadHelper()
        // You can decode the response data into a specific model or process it as needed
        guard let createUserResponseJson = payloadHelper.decrypt(cipherTagText: createUserEncryptResponse.cipherText, iv: createUserEncryptResponse.iv) else {
            logger.error("Failed to decrypt the Create User API")
            return
        }
        
        guard let createUserResponse = try? decoder.decode(CreateUserResponse.self, from: createUserResponseJson) else {
            // Handle encoding errors
            logger.error("Failed to parse Create User JSON")
            return
        }
        
        guard let accessToken = createUserResponse.accessToken else {
            logger.info("Access Token is null")
            return
        }
        
        // Return the success token
        success(accessToken, createUserResponse)
    }
    
    func syncData(data: [String: Any], syncItem: SyncType) {
        // Get the request body
        let requestBody = self.getRequestBody(syncData: data)
        
        guard let syncDataBody = requestBody else {
            debugPrint("Request body is null")
            return
        }
        
        // Make the api call
        let requestParams = NetworkUtils.postRequest(urlStr: getSyncURL(syncItem: syncItem), body: syncDataBody)
        
        guard let requestParams = requestParams else {
            debugPrint("Request Params null")
            return
        }
        
        // Create a network request task
        let task = URLSession.shared.dataTask(with: requestParams) { data, response, error in
            if let error = error {
                self.handleError(error: error)
                return
            }
            
            // Check if there is a response and data
            guard let httpResponse = response as? HTTPURLResponse, let _ = data else {
                debugPrint("Invalid response or no data")
                return
            }
            
            // Handle the HTTP response
            switch httpResponse.statusCode {
            case 200...299:
                debugPrint("Sync Successful: \(httpResponse.statusCode)")
                // Process the data here
                guard let data = data else {
                    self.handleClientError(error: "Invalid Sync Response")
                    return
                }
                
            case 400...499:
                // Handle client error
                debugPrint("Client Error: \(httpResponse.statusCode)")
                var errorMessage: String? = nil
                if let data = data, let errMessage = String(data: data, encoding: .utf8) {
                    errorMessage = errMessage
                }
                self.handleClientError(error: errorMessage ?? "Client Error Occured")
                
            case 500...599:
                // Handle server error
                debugPrint("Server Error: \(httpResponse.statusCode)")
                self.handleServerError(error: error ?? "Server Error Occured")
                
            default:
                // Handle other status codes
                debugPrint("Unexpected status code: \(httpResponse.statusCode)")
            }
        }
        
        // Initiate the network request
        task.resume()
    }
    
    /// Converts Data DIctionary to a JSON
    func getRequestBody(syncData: [String: Any]) -> Data? {
        // Convert the dictionary to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: syncData, options: []) else {
            print("Error: Cannot convert dictionary to JSON data")
            return nil
        }
        
        return jsonData
    }
    
    func getCreateUserRequestBody(createUserRequest: CreateUserRequest, error: @escaping (FinBoxErrorCode) -> Void) -> Data? {
        let encoder = JSONEncoder()
        
        // Convert the User Model to Json Data
        guard let createUserRequestJson = try? encoder.encode(createUserRequest) else {
            // Handle encoding errors
            error(FinBoxErrorCode.ENCODE_FORMAT_ERROR)
            return nil
        }
        
        // Create an instance of Payload Helper
        let payloadHelper = PayloadHelper()
        // Generate IV
        let iv = payloadHelper.generateIv()
        // Encrypt the Payload
        let cipherText = payloadHelper.encrypt(cipherText: createUserRequestJson, iv: iv)
        
        let createUserEncryptRequest = EncryptPayload(iv: iv, cipherText: cipherText)
        
        // Convert the User Model to Json Data
        guard let createUserEncryptRequestJson = try? encoder.encode(createUserEncryptRequest) else {
            // Handle encoding errors
            error(FinBoxErrorCode.ENCODE_FORMAT_ERROR)
            return nil
        }
        
        return createUserRequestJson
    }
    
    /// Returns Sync URL based on Sync Item Type
    func getSyncURL(syncItem: SyncType) -> String {
        if syncItem == SyncType.DEVICE { return DATA_SYNC_BASE_URL + DEVICE_ENDPOINT }
        return DATA_SYNC_BASE_URL + LOCATION_ENDPOINT
    }
    
    /// Handles client errors
    func handleClientError(error: Any) {
        debugPrint("Response Error Client: \(error as Any)")
    }
    
    /// Handles server errors
    func handleServerError(error: Any) {
        debugPrint("Response Error Server: \(String(describing: error))")
    }
    
    /// Handles generic errors
    func handleError(error: Any) {
        debugPrint("Response Error Generic: \(String(describing: error))")
    }
}
