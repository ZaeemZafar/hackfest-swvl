//
//  Notification.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/2/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

struct JFUserNotification {
    let profileImage: String
    let nTitle: String
    let nSubTitle: String
    let time: String
    var new: Bool
}

struct JFFollowRequests {
    let profileImage: String?
    let name: String?
    let jfIndex: String?
    var pending: Bool?
    var profileStates: Int

    init(image: String, name: String, jfIndex: String, pending: Bool, userProfileState: Int = 0) {
        self.profileImage = image
        self.name = name
        self.jfIndex = jfIndex
        self.pending = pending
        self.profileStates = userProfileState
    }
}
