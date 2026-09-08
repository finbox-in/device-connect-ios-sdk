//
//  ContactsManager.swift
//  RiskManager
//
//  Created by Shashwat Anand on 03/09/26.
//

import Contacts

class ContactsManager {
    static let shared = ContactsManager()
    
    func getContactsCount() -> Int? {
        guard getContactsAuthStatus() else {
            return nil
        }
        
        let store = CNContactStore()
        let keysToFetch = [CNContactIdentifierKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var count = 0
        do {
            try store.enumerateContacts(with: request) { _, _ in
                count += 1
            }
        } catch {
            debugPrint(error)
            return nil
        }
        return count
    }
    
    func getContactsAuthStatus() -> Bool {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized:
            return true
        case .denied, .restricted, .notDetermined, .limited:
            return false
        @unknown default:
            return false
        }
    }
}
