//
//  KeyboardProtocol.swift
//  ZENFoods
//
//  Created by Abdul Baseer Khan on 01/02/2018.
//  Copyright © 2018 Loviza Tahir. All rights reserved.
//

import Foundation
import UIKit

enum CBAppDelegateEvent {
    case didBecomeActive, willEnterForeground, didEnterBackground
    
    var notificationSystemName: Notification.Name {
        switch self {
        case .didBecomeActive: return Notification.Name.UIApplicationDidBecomeActive
        case .willEnterForeground: return Notification.Name.UIApplicationWillEnterForeground
        case .didEnterBackground: return Notification.Name.UIApplicationDidEnterBackground
        }
    }
}

protocol CBAppEventProtocol {
    func onAppStateChange(_ state: CBAppDelegateEvent)
}

extension CBAppEventProtocol where Self: UIViewController {
   
    func configureAppEvents(for notification_types: [CBAppDelegateEvent]) {
        
        notification_types.forEach { (anEventType) in
            NotificationCenter.default.addObserver(forName: anEventType.notificationSystemName, object: nil, queue: nil) { [weak self] (notification) in
                self?.onAppStateChange(anEventType)
            }
        }
        
    }
    
}
