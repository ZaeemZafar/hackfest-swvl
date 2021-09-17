//
//  FollowedByRelation.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 26/06/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

struct FollowedByRelation : Codable {
    let acceptRequest : Bool?
    let isSeen : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case acceptRequest = "acceptRequest"
        case isSeen = "isSeen"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        acceptRequest = try container.decodeIfPresent(Bool.self, forKey: .acceptRequest)
        isSeen = try container.decodeIfPresent(Bool.self, forKey: .isSeen)
    }
    
}
