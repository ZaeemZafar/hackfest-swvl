//
//  JFPercentageLabel.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/26/18.
//  Copyright © 2018 maskers. All rights reserved.
//


import UIKit

// @IBDesignable
class JFPercentageLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    override func layoutSubviews() {
        applyApparance()
    }
    
    override var text: String? {
        didSet {
            applyApparance()
        }
    }
    
    func applyApparance() {
        let simpleText = self.text?.replace(string: "%", replacement: "")
        textColor = .clear
        backgroundColor = .clear
        
        if let txt = simpleText, let doubleValue = Double(txt) {
            textColor = UIColor.white
            backgroundColor = UIColor.jfRed
            
            if doubleValue > 0 {
                backgroundColor = UIColor.jfGreen
                
            } else if doubleValue == 0 {
                backgroundColor = UIColor.jfLightGray
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
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        textAlignment = .center
        textColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
    
}
