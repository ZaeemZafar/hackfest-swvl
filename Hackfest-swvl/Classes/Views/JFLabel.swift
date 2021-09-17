//
//  JFLabel.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/12/18.
//  Copyright © 2018 maskers. All rights reserved.
//


import UIKit

// @IBDesignable
class JFLabel: UILabel {

    @IBInspectable var lineSpacing: CGFloat = 5 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text ?? "")
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = lineSpacing // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            // *** Set Attributed String to your label ***
            self.attributedText = attributedString
        }
    }
    
    @IBInspectable open var characterSpacings:CGFloat = 1 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: self.characterSpacings, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
        
    }

    // MARK: -
    // MARK: Init & Override methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
        
    }
}
