//
//  JFUser.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/16/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import Foundation

typealias ImageCompletion = ((UIImage) -> ())

class JFUser: Codable {

    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var profilePrivacy: ProfilePrivacyLevel
    var imagePath: String?
    
//    private var _cachedImage = #imageLiteral(resourceName: "profile_icon_grey_large")
    
    func imageURL(thumbnail: Bool = false) -> URL? {
        let imageBaseURL = thumbnail ? JFConstants.s3ThumbnailImageURL : JFConstants.s3ImageURL
        let urlString =  JFConstants.s3ImageURL + (imagePath ?? "")
        return URL(string: urlString)
    }
    
//    var image: ImageCompletion?
    
    required init() {
        id                  = ""
        firstName           = ""
        lastName            = ""
        email               = ""
        phone               = ""
        profilePrivacy      = .publicProfile
        imagePath = ""
    }
    
    convenience init(profileData: NetworkData) {
        self.init()
        
        self.id = "\(profileData.id ?? 0)"
        self.firstName = profileData.firstName ?? ""
        self.lastName = profileData.lastName ?? ""
        self.profilePrivacy = (profileData.settings?.isCaptainProfile ?? false) ? .publicProfile : .privateProfile
        self.imagePath = profileData.image
        
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        id = aDecoder.decodeObject(forKey: "id") as! String
//        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
//        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
//        email = aDecoder.decodeObject(forKey: "email") as! String
//        phone = aDecoder.decodeObject(forKey: "phone") as! String
//        imagePath = aDecoder.decodeObject(forKey: "imagePath") as! String
//        profilePrivacy = aDecoder.decodeObject(forKey: "profilePrivacy") as! ProfilePrivacyLevel
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(firstName, forKey: "firstName")
//        aCoder.encode(lastName, forKey: "lastName")
//        aCoder.encode(email, forKey: "email")
//        aCoder.encode(profilePrivacy, forKey: "profilePrivacy")
//        aCoder.encode(imagePath, forKey: "imagePath")
//    }

    
}
