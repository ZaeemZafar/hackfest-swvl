//
//  UILabel+JF.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/3/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func attributedString(text: String, addSpacing: CGFloat = 20) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = addSpacing // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        //label.attributedText = attributedString;
        return attributedString
    }
    
    func addCharactersSpacing(_ value: CGFloat = 1.15) {
        if let textString = text {
            let attrs: [NSAttributedStringKey : Any] = [.kern: value]
            attributedText = NSAttributedString(string: textString, attributes: attrs)
        }
    }
    
    func addSpacingWithTitle(spacing: CGFloat, title: String) {
        
        let attributedString = NSMutableAttributedString(string: title )
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (title.count )))
        self.attributedText = attributedString
        
    }
    
//    @IBInspectable
//    var letterSpace: CGFloat {
//        set {
//            let attributedString: NSMutableAttributedString!
//            if let currentAttrString = attributedText {
//                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
//            }
//            else {
//                attributedString = NSMutableAttributedString(string: text ?? "")
//                text = nil
//            }
//
//            attributedString.addAttribute(NSAttributedStringKey.kern,
//                                          value: newValue,
//                                          range: NSRange(location: 0, length: attributedString.length))
//
//            attributedText = attributedString
//        }
//
//        get {
//            if let currentLetterSpace = attributedText?.attribute(NSAttributedStringKey.kern, at: 0, effectiveRange: .none) as? CGFloat {
//                return currentLetterSpace
//            }
//            else {
//                return 0
//            }
//        }
//    }
}
