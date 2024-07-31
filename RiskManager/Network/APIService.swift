//
//  APIService.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 31/07/24.
//

import Foundation

/// Service struct that encapsulates API-related functionalities
/// -
struct APIService {
    
    /// Singleton instance of the `APIService`.
    static let instance = APIService()
    
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
