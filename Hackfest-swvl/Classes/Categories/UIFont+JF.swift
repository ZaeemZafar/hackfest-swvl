//
//  UIFont+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import Foundation

extension UIFont {
    
    class func normal(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: fontSize)!
    }
    
    class func medium(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: fontSize)!
    }
    
    class func semiBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: fontSize)!
    }
    
    class func bold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: fontSize)!
    }
    
    class func extraBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-ExtraBold", size: fontSize)!
    }
    
    class func light(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: fontSize)!
    }
    
    class func extraLight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-ExtraLight", size: fontSize)!
    }
    
    class func thin(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Thin", size: fontSize)!
    }
    
    class func boldItalic(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-BoldItalic", size: fontSize)!
    }
    
    class func extraBoldItalic(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-ExtraBoldItalic", size: fontSize)!
    }
    
    class func italic(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Italic", size: fontSize)!
    }
    
    class func lightItalic(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-LightItalic", size: fontSize)!
    }
    
    class func semiBoldItalic(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-SemiBoldItalic", size: fontSize)!
    }
}

