//
//  JFContacts.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 09/07/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import SwiftyContacts
import Contacts
import CoreTelephony

class JFContacts {
    var hasBeenAuthorized = false
    private var contactCount = 0
    
    var countUpdated: ( (Int) -> Void )?
    
    static var shared = JFContacts()
    
    func loadInitialData() {
        JFContacts.shared.contactAuthorizationStatus { (status) in
            switch status {
            case .authorized:
                JFContacts.shared.hasBeenAuthorized = true
                
                JFContacts.shared.fetchContactListOnBackgroundThread(completionHandler: { (result) in
                    switch result{
                    case .Success(response: let contacts):
                        // Call API instead
                        JFContacts.shared.contactCount = contacts.count
                        break
                    case .Error(error: let error):
                        print(error)
                        break
                    }
                })
                
            default:
                JFContacts.shared.hasBeenAuthorized = false
            }
        }
    }
    
    func requestContactAccess(_ requestGranted: @escaping (Bool) -> ()) {

        requestAccess { (granted) in
            JFContacts.shared.hasBeenAuthorized = granted
            requestGranted(granted)
        }
    }
    
    func contactAuthorizationStatus(_ requestStatus: @escaping (CNAuthorizationStatus) -> ()) {
        authorizationStatus(requestStatus)
    }
    
    func fetchContactList(completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        fetchContacts { (fetchResult) in
            
            switch fetchResult {
            case .Success(response: let contacts):
                // Call API instead
                JFContacts.shared.contactCount = contacts.count
            default:
                break
            }
            
            completionHandler(fetchResult)
        }
    }
    
    func fetchContactsList(ContactsSortorder sortOrder: CNContactSortOrder, completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        fetchContacts(ContactsSortorder: sortOrder, completionHandler: completionHandler)
    }
    
    func fetchContactListOnBackgroundThread(completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        fetchContactsOnBackgroundThread(completionHandler: completionHandler)
    }
    
    func searchContactList(SearchString string: String, completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        searchContact(SearchString: string, completionHandler: completionHandler)
    }
    
    func getContactFromIDs(Identifires identifiers: [String], completionHandler: @escaping (_ result: ContactsFetchResult) -> ()) {
        getContactFromID(Identifires: identifiers, completionHandler: completionHandler)
    }
    
    func addNewContact(Contact mutContact: CNMutableContact, completionHandler: @escaping (_ result: ContactOperationResult) -> ()) {
        addContact(Contact: mutContact, completionHandler: completionHandler)
    }
}

extension JFContacts {
    // API call for get network count
    func api() {
        JFContacts.shared.contactCount = 9
        JFContacts.shared.countUpdated?(JFContacts.shared.contactCount)
    }
}
