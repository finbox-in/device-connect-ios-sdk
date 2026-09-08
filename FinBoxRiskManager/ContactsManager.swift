//
//  ContactsManager.swift
//  RiskManager
//
//  Created by Shashwat Anand on 07/09/26.
//

import Contacts

class ContactsManager: ObservableObject {
    private let store = CNContactStore()

    @Published var contactsAuthStatus: CNAuthorizationStatus = .notDetermined

    init() {

    }

    func checkContactsPermission() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        contactsAuthStatus = status

        if status == .notDetermined {
            store.requestAccess(for: .contacts) { _, _ in
                DispatchQueue.main.async {
                    self.contactsAuthStatus = CNContactStore.authorizationStatus(for: .contacts)
                }
            }
        }
    }
}
