//
//  JFButton.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/3/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

// @IBDesignable
class JFButton: UIButton {

    // MARK: -
    // MARK: Constants and Properties
    @IBInspectable var orangeButton: Bool = true { //Used to change background color, title color, border color & width accordingly
        didSet {
            if orangeButton {
                backgroundColor = UIColor.jfDarkBrown
                setTitleColor(UIColor.white, for: .normal)
                
                
            } else  {
                backgroundColor = UIColor.white
                layer.borderWidth = 1.7
                layer.borderColor = UIColor.jfDarkBrown.cgColor
                setTitleColor(UIColor.jfDarkBrown, for: .normal)
            }
        }
    }
    
    @IBInspectable var addTextSpacing: CGFloat = 1.5 {
        didSet {
            let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text ?? "")!)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: addTextSpacing, range: NSRange(location: 0, length: (self.titleLabel?.text?.count ?? 0)!))
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                alpha = 1.0
            } else {
                alpha = 0.6
            }
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
        layer.cornerRadius = 4.0
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 0.5
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.baselineAdjustment = .alignCenters
    }

     func addSpacingWithTitle(spacing: CGFloat = 1.5, title: String) {
        
        let attributedString = NSMutableAttributedString(string: title )
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (title.count )))
        self.setAttributedTitle(attributedString, for: .normal)
        
    }
    
    // TODO: Background camel notation violation ~ Fixed
    func customizeButton(titleColor: UIColor = UIColor.white, backgroundColor: UIColor, borderColor: UIColor = UIColor.clear, withRoundCorner: Bool = true, cornerRadius: CGFloat = 5) {
        
        if withRoundCorner {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = 1
            self.layer.borderColor = borderColor.cgColor
        }
        self.backgroundColor = backgroundColor
        self.titleLabel?.textColor = titleColor
    }
}
