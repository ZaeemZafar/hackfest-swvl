//
//  File.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/2/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

struct JFUserSettings {
    var locations = true
    var connectFB = true
    var linkFB = true
    var notifications = true
}

struct JFPrivacySettings {
    var publicPrivacy = true
    var privatePrivacy = false
}

struct JFBlockedUser {
    var image: String
    var title: String
    var subTitle: String
}

struct JFRatingsOnOff {
    var acceptRatings = true
    var acceptAnonymous = true
    var appearance = true
    var personality = true
    var intelligence = true
}
