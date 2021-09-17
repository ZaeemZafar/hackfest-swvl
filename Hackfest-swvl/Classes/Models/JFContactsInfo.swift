//
//  JFContactsInfo.swift
//  Hackfest-swvl
//
//  Created by zaktech on 7/12/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import Contacts

enum ContactStatus {
    case invited, networkUser, none
}

@objc enum InviteMedium: Int {
    case viaSMS, viaEmail, Both
    
    var inviteHelpText: String {
        switch self {
        case .viaEmail: return "Invite Via Email"
        case .viaSMS: return "Invite Via SMS"
        default:
            return ""
        }
    }
    
    var inviteMessageHelpText: String {
        switch self {
        case .viaEmail: return "Please enter email address that you want to send invite"
        case .viaSMS: return "Please enter phone number that you want to send invite"
        default:
            return ""
        }
    }
}

class JFContactInfo {
    
    var fullName: String
    var isInvited: Bool
    var image: UIImage
    var phoneNumber: String
    var email: String
    var status: ContactStatus = .none
    var canInvite: InviteMedium = .viaSMS
    
    // MARK: - Computed properties
    
    
    // PhoneNumber should be prioritize as per client requirement e.g. Mobile, Home, Other etc
    
    init(withContactInfo info: CNContact) {
        fullName = info.givenName + " " + info.familyName
        isInvited = false
        
        if let imageData =  info.imageData {
            image = UIImage(data: imageData)!
        } else {
            image = #imageLiteral(resourceName: "profile_icon_placeholder")
        }
        
        let cnPhoneNumber = JFContactInfo.getPhoneNumberFromContact(info)
        phoneNumber = (cnPhoneNumber?.stringValue ?? "").extractNumbers()
        
        if phoneNumber.count >= JFConstants.minPhoneNumberDigits {
            phoneNumber = String(phoneNumber.suffix(JFConstants.minPhoneNumberDigits))
            
            // Default country is US, so in case of nil, we are using 1
            phoneNumber = "+\(JFUtility.getCountryCode() ?? "1")" + phoneNumber
        }
        
        email = info.emailAddresses.first?.value as String? ?? ""
        
        if phoneNumber.isEmpty == false && email.isEmpty == false {
            canInvite = .Both
        } else if phoneNumber.isEmpty == false {
            canInvite = .viaSMS
        } else if email.isEmpty == false {
            canInvite = .viaEmail
        }
    }
    
    class func getPhoneNumberFromContact(_ aContact: CNContact) -> CNPhoneNumber? {
        
        for phoneNumber in aContact.phoneNumbers {
            
            // Priortizing phone number type
            if phoneNumber.label == CNLabelPhoneNumberiPhone {
                //iPhone number.
                return phoneNumber.value
                
            } else if phoneNumber.label == CNLabelPhoneNumberMobile {
                //Mobile phone number.
                return phoneNumber.value
                
            } else if phoneNumber.label == CNLabelPhoneNumberMain {
                //Main phone number.
                return phoneNumber.value
            } else if phoneNumber.value.stringValue.count > 0 {
                // Any other number
                return phoneNumber.value
            }
        }
        
        return nil
    }
}
