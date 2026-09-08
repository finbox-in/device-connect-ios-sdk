//
//  PhotoLibraryManager.swift
//  RiskManager
//
//  Created by Shashwat Anand on 08/09/26.
//

import Photos

class PhotoLibraryManager: ObservableObject {
    @Published var photosAuthStatus: PHAuthorizationStatus = .notDetermined

    init() {

    }

    func checkPhotosPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        photosAuthStatus = status

        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.photosAuthStatus = status
                }
            }
        }
    }
}
