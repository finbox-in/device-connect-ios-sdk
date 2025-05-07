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

    func createUser(createUserRequest: CreateUserRequest, createError: @escaping (FinBoxErrorCode) -> Void, accountSuite: UserPreference, success: @escaping (String, CreateUserResponse) -> Void) {
        
        let requestBody = self.getCreateUserRequestBody(createUserRequest: createUserRequest, error: createError)
        
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
                logger.error("Error during API call: \(apiError)")
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                logger.error("Invalid data or response received from API")
                return
            }
            
            logger.info("API response status code: \(httpResponse.statusCode)")
            
            parseResponse(response: data, error: createError, success: success)
        }
        
        task.resume()
    }
    
    private func parseResponse(response: Data, error: @escaping (FinBoxErrorCode) -> Void, success: @escaping (String, CreateUserResponse) -> Void) {
        let decoder = JSONDecoder()
        guard let createUserEncryptResponse = try? decoder.decode(EncryptPayload.self, from: response) else {
            // Handle encoding errors
            logger.error("Failed to parse Encrypt Response JSON")
            error(FinBoxErrorCode.ENCODE_FORMAT_ERROR)
            return
        }
        
        let payloadHelper = PayloadHelper()
        // You can decode the response data into a specific model or process it as needed
        guard let createUserResponseJson = payloadHelper.decrypt(cipherTagText: createUserEncryptResponse.cipherText, iv: createUserEncryptResponse.iv) else {
            logger.error("Failed to decrypt the Create User API")
            error(FinBoxErrorCode.ENCODE_FORMAT_ERROR)
            return
        }
        
        guard let createUserResponse = try? decoder.decode(CreateUserResponse.self, from: createUserResponseJson) else {
            // Handle encoding errors
            logger.error("Failed to parse Create User JSON")
            error(FinBoxErrorCode.ENCODE_FORMAT_ERROR)
            return
        }
        
        guard let accessToken = createUserResponse.accessToken else {
            logger.info("Access Token is null")
            error(FinBoxErrorCode.ACCESS_TOKEN_NULL)
            return
        }
        
        // Return the success token
        success(accessToken, createUserResponse)
    }
    
    func syncDeviceData(data: DeviceInfo, syncItem: SyncType) {
        // Get the request body
        let requestBody = self.getDeviceRequestBody(deviceInfo: data)
        
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
                debugPrint("Device Sync Successful: \(httpResponse.statusCode)")
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

    func syncLocationData(data: LocationModel, syncItem: SyncType) {
        // Get the request body
        let requestBody = self.getLocationRequestBody(locationModel: data)
        
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
                debugPrint("Location Sync Successful: \(httpResponse.statusCode)")
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
        
        return createUserEncryptRequestJson
    }
    
    func syncPermissions(data: PermissionModel, syncType: SyncType) {
        let requestBody = self.getPermissionsRequestBody(permissionModel: data)
        
        guard let syncDataBody = requestBody else {
            debugPrint("Request body is null")
            return
        }
        
        // Make the api call
        let requestParams = NetworkUtils.postRequest(urlStr: getSyncURL(syncItem: syncType), body: syncDataBody)
        
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
                debugPrint("Permissions Sync Successful: \(httpResponse.statusCode)")
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
    
    func getPermissionsRequestBody(permissionModel: PermissionModel) -> Data? {
        let encoder = JSONEncoder()
        
        // Convert the Permission Model to Json Data
        guard let permissionModelRequestJson = try? encoder.encode(permissionModel) else {
            // Handle encoding errors
            return nil
        }
        
        // Create an instance of Payload Helper
        let payloadHelper = PayloadHelper()
        // Generate IV
        let iv = payloadHelper.generateIv()
        // Encrypt the Payload
        let cipherText = payloadHelper.encrypt(cipherText: permissionModelRequestJson, iv: iv)
        
        let permissionModelEncryptRequest = EncryptPayload(iv: iv, cipherText: cipherText)
        
        // Convert the User Model to Json Data
        guard let permissionModelEncryptRequestJson = try? encoder.encode(permissionModelEncryptRequest) else {
            // Handle encoding errors
            return nil
        }
        
        return permissionModelEncryptRequestJson
    }
    
    func getLocationRequestBody(locationModel: LocationModel) -> Data? {
        let encoder = JSONEncoder()
        
        // Convert the User Model to Json Data
        guard let locationModelRequestJson = try? encoder.encode(locationModel) else {
            // Handle encoding errors
            return nil
        }
        
        // Create an instance of Payload Helper
        let payloadHelper = PayloadHelper()
        // Generate IV
        let iv = payloadHelper.generateIv()
        // Encrypt the Payload
        let cipherText = payloadHelper.encrypt(cipherText: locationModelRequestJson, iv: iv)
        
        let locationModelEncryptRequest = EncryptPayload(iv: iv, cipherText: cipherText)
        
        // Convert the User Model to Json Data
        guard let locationModelEncryptRequestJson = try? encoder.encode(locationModelEncryptRequest) else {
            // Handle encoding errors
            return nil
        }
        
        return locationModelEncryptRequestJson
    }
    
    func getDeviceRequestBody(deviceInfo: DeviceInfo) -> Data? {
        let encoder = JSONEncoder()
        
        // Convert the User Model to Json Data
        guard let deviceInfoRequestJson = try? encoder.encode(deviceInfo) else {
            // Handle encoding errors
            return nil
        }
        
        // Create an instance of Payload Helper
        let payloadHelper = PayloadHelper()
        // Generate IV
        let iv = payloadHelper.generateIv()
        // Encrypt the Payload
        let cipherText = payloadHelper.encrypt(cipherText: deviceInfoRequestJson, iv: iv)
        
        let deviceInfoEncryptRequest = EncryptPayload(iv: iv, cipherText: cipherText)
        
        // Convert the User Model to Json Data
        guard let deviceInfoEncryptRequestJson = try? encoder.encode(deviceInfoEncryptRequest) else {
            // Handle encoding errors
            return nil
        }
        
        return deviceInfoEncryptRequestJson
    }
    
    /// Returns Sync URL based on Sync Item Type
    func getSyncURL(syncItem: SyncType) -> String {
        if syncItem == SyncType.DEVICE {
            return DATA_SYNC_URL + DEVICE_ENDPOINT
        } else if syncItem == SyncType.LOCATION {
            return DATA_SYNC_URL + LOCATION_ENDPOINT
        } else if syncItem == SyncType.PERMISSIONS {
            return DATA_SYNC_URL + PERMISSIONS_ENDPOINT
        } else {
            return ""
        }
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

    /// Deletes DC User
    func deleteData(forgetUserRequest: ForgetUserRequest) {
        let requestBody = self.getForgetUserRequestBody(forgetUserRequest: forgetUserRequest)

        guard let forgetUserRequestBody = requestBody else {
            debugPrint("Request body is null")
            return
        }

        // Make the api call
        let requestParams = NetworkUtils.postRequest(urlStr: getDeleteUserURL(), body: forgetUserRequestBody)

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
                debugPrint("User Deletion Successful: \(httpResponse.statusCode)")
                // Process the data here
                guard let data = data else {
                    self.handleClientError(error: "Invalid Response")
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

    /// Prepares the encrypted request body for the forget user API.
    ///
    /// This function takes a `ForgetUserRequest` model, serializes it to JSON,
    /// encrypts the payload using a generated IV, wraps the result in an
    /// `EncryptPayload` model, and returns the final JSON data to be sent in
    /// the network request.
    ///
    /// - Parameter forgetUserRequest: The forget user request model containing user-related info.
    /// - Returns: Encrypted JSON data (`Data?`) ready for transmission, or `nil` if encoding fails.
    func getForgetUserRequestBody(forgetUserRequest: ForgetUserRequest) -> Data? {
        let encoder = JSONEncoder()

        // Convert the ForgetUserRequest model to JSON data
        guard let forgetUserRequestJson = try? encoder.encode(forgetUserRequest) else {
            // Handle encoding errors
            return nil
        }

        // Create an instance of PayloadHelper
        let payloadHelper = PayloadHelper()
        // Generate IV
        let iv = payloadHelper.generateIv()
        // Encrypt the payload
        let cipherText = payloadHelper.encrypt(cipherText: forgetUserRequestJson, iv: iv)

        let forgetUserEncryptRequest = EncryptPayload(iv: iv, cipherText: cipherText)

        // Convert the encrypted payload to JSON data
        guard let forgetUserEncryptRequestJson = try? encoder.encode(forgetUserEncryptRequest) else {
            // Handle encoding errors
            return nil
        }

        return forgetUserEncryptRequestJson
    }

    private func getDeleteUserURL() -> String {
        return AUTH_BASE_URL + DELETE_USER_ENDPOINT
    }
}
