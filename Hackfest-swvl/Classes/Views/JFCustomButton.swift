//
//  JFCustomButton.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/4/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

// @IBDesignable
class JFCustomButton: UIButton {
    
    @IBInspectable var addTextSpacing: CGFloat = 0 {
        didSet {
            let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: addTextSpacing, range: NSRange(location: 0, length: (self.titleLabel?.text?.count ?? 0)!))
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    @IBInspectable var cornorRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornorRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView != nil {
            contentHorizontalAlignment = .left
            
            //imageView.alignmen
            imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 16.0, bottom: 5.0, right: 16.0)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: (imageView?.frame.width)! + 8.0, bottom: 0, right: 0)
            
            titleLabel?.textAlignment = NSTextAlignment.center
        }
    }
    
    internal func setupUI() {
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 0.5
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.baselineAdjustment = .alignCenters
    }
}
