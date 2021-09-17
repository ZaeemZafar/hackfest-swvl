//
//  Bundle+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

extension Bundle {
    
    var appVersion: String {
        var versionString = "1.0"
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionString = version
        }
        
        return versionString
    }
}
