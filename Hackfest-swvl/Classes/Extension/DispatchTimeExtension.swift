//
//  DispatchTimeExtension.swift
//  VTO
//
//  Created by Mohsin on 8/23/17.
//  Copyright © 2017 Mohsin. All rights reserved.
//

import Foundation

extension DispatchTime {
    
    static func executeAfter(seconds: TimeInterval, completionHandler: @escaping () -> ()) {
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + seconds
        
        mainQueue.asyncAfter(deadline: deadline) {
            completionHandler()
        }
    }
    
    static func executeAfter(milliSeconds: TimeInterval, completionHandler: @escaping () -> ()) {
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .milliseconds(Int(milliSeconds))
        
        mainQueue.asyncAfter(deadline: deadline) {
            completionHandler()
        }
    }
}
