//
//  UIStoryboard+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    private enum StoryboardName: String {
        case main = "Main"
        case userRegistration = "UserRegistration"
        case profile = "Profile"
        case porfolio = "Portfolio"
        case settings = "Settings"
        case customViews = "CustomViews"
    }
    
    class var main: UIStoryboard {
        return UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    }
    
    class var userRegistration: UIStoryboard {
        return UIStoryboard(name: StoryboardName.userRegistration.rawValue, bundle: nil)
    }
    
    class var profile: UIStoryboard {
        return UIStoryboard(name: StoryboardName.profile.rawValue, bundle: nil)
    }
    
    class var portfolio: UIStoryboard {
        return UIStoryboard(name: StoryboardName.porfolio.rawValue, bundle: nil)
    }
    
    class var settings: UIStoryboard {
        return UIStoryboard(name: StoryboardName.settings.rawValue, bundle: nil)
    }
    
    class var customViews: UIStoryboard {
        return UIStoryboard(name: StoryboardName.customViews.rawValue, bundle: nil)
    }
}
