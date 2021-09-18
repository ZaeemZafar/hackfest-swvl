//
//  UIColor+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    class func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: (red/255.0), green: (green/255.0), blue: (blue/255.0), alpha: 1.0)
    }
    
    class var swvlRed: UIColor {
        return jfRed
    }
    
    class var swvlMediumRed: UIColor {
        return UIColor.fromRGB(red: 255.0, green: 47.0, blue: 71.0)
    }
    
    class var swvlLightRed: UIColor {
        return swvlMediumRed.withAlphaComponent(0.7)
    }
    
    class var jfDarkGray: UIColor {
        return UIColor.fromRGB(red: 73.0, green: 73.0, blue: 73.0)
    }
    
    class var jfMediumGray: UIColor {
        return UIColor.fromRGB(red: 118.0, green: 118.0, blue: 118.0)
    }
    
    class var jfLightGray: UIColor {
        return UIColor.fromRGB(red: 198.0, green: 198.0, blue: 198.0)
    }

    class var jfRed: UIColor {
        return UIColor.fromRGB(red: 253.0, green: 2.0, blue: 47.0)
    }
    
    class var jfFacebookLink: UIColor {
        return UIColor.fromRGB(red: 66.0, green: 103.0, blue: 178.0)
    }
    
    class var jfGreen: UIColor {
        return UIColor.fromRGB(red: 0.0, green: 210.0, blue: 136.0)
    }
    
    class var jfCategoryOrange: UIColor {
        return UIColor.fromRGB(red: 239.0, green: 122.0, blue: 60.0)
    }
    
    class var jfCategoryBlue: UIColor {
        return UIColor.fromRGB(red: 3.0, green: 147.0, blue: 191.0)
    }

    class var jfCategoryRed: UIColor {
        return UIColor.fromRGB(red: 188.0, green: 22.0, blue: 128.0)
    }
    
    class var appBackGroundColor: UIColor {
        return UIColor.fromRGB(red: 247.0, green: 247.0, blue: 247.0)
    }
    
    class var jfChooseWordsBlack: UIColor {
        return UIColor.fromRGB(red: 34.0, green: 34.0, blue: 34.0)
    }
    
    class var jfChooseWordsGreen: UIColor {
        return UIColor.fromRGB(red: 50.0, green: 210.0, blue: 132.0)
    }
   
    class var jfChooseWordsLightWhite: UIColor {
        return UIColor.fromRGB(red: 248.0, green: 248.0, blue: 248.0)
    }
    
    class var jfChooseWordsBorder: UIColor {
        return UIColor.fromRGB(red: 248.0, green: 248.0, blue: 248.0)
    }
    
    class var jfChooseWordsRed: UIColor {
        return UIColor.fromRGB(red: 255.0, green: 59.0, blue: 48.0)
    }
    
}

