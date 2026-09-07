//
//  PhotoLibraryManager.swift
//  RiskManager
//
//  Created by Shashwat Anand on 07/09/26.
//

import Photos

class PhotoLibraryManager {
    static let shared = PhotoLibraryManager()
    
    func getPhotosCount() -> Int? {
        let result = PHAsset.fetchAssets(with: .image, options: nil)
        return result.count
    }
    
    func getPhotosAuthStatus() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            return false
        default:
            return false
        }
    }
}
