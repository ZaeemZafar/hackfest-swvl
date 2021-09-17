//
//  JFCategoryButton.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/15/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

// @IBDesignable
class JFCategoryButton: UIButton {
    
    @IBInspectable var normalImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var defaultBorder: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedBorder: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedTitleColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var isBorder: Bool = true {
        didSet {
            if isBorder {
                layer.borderWidth = 2.0
                layer.cornerRadius = 4.0
            }
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 18 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var select: Bool = false {
        didSet {
            self.isSelected = select
            if select {
                if isBorder {
                    layer.borderColor = selectedBorder?.cgColor
                }
                titleLabel?.font = UIFont.medium(fontSize: 16.0)
                
            } else {
                
                if isBorder {
                    layer.borderColor = UIColor.jfLightGray.cgColor
                }
                titleLabel?.font = UIFont.light(fontSize: 16.0)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setImage(normalImage, for: .normal)
        setImage(normalImage, for: .highlighted)
        setImage(selectedImage, for: .selected)
        
        setTitleColor(selectedTitleColor, for: .selected)
        
        contentHorizontalAlignment = .left

        imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
    }

}
