//
//  JFSearchTextField.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/14/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

fileprivate let _leftImagePaddingDefault: CGFloat = 12
fileprivate let _rightImagePaddingDefault: CGFloat = 20

// @IBDesignable
class JFSearchTextField: UITextField {

    var imageView: UIImageView?
    
    var hasErrorMessage: Bool = false {
        didSet {
            if hasErrorMessage {
                showError()
            } else {
                hideError()
            }
        }
    }
    
    // MARK: -
    // MARK: Constants and Properties
    @IBInspectable var leftImage: UIImage? {
        
        didSet {
            updateView()
        }
    }

    @IBInspectable var leftPadding: CGFloat = _leftImagePaddingDefault { // Default is 12 for imageview
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var selectedPlaceHolderText: String? {
        didSet {
            updateView()
        }
    }
    
    
    // MARK: -
    // MARK: Init & Override methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customTextFieldSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customTextFieldSetup()
    }
    
    var padding: UIEdgeInsets {
        get {
            if leftImage != nil {
                return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 5);
            }
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    //used to add imageview
    
    func customTextFieldSetup() {
        addTarget(self, action: #selector(editingBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingEnd), for: .editingDidEnd)
        self.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        isEmpty()
    }
    
    func updateView() {
        if #available(iOS 10, *) {
            // Disables the password autoFill accessory view.
            textContentType = UITextContentType("")
        }
        
        if let image = leftImage {
            leftViewMode = .always
            
            imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
            imageView?.image = image
            imageView?.contentMode = .scaleAspectFit
            imageView?.tintColor = UIColor.jfLightGray
            
            var width = leftPadding + 20
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                width = width + 12
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView!)
            
            leftView = view
            
        } else {
            
            leftViewMode = .never
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.jfLightGray])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !(textField.text?.isEmpty)! {
            imageView?.tintColor = UIColor.red
            
        } else {
            imageView?.tintColor = UIColor.green
        }
        
        return true
    }
    
    @objc func editingChanged() {
        
        // My custom implementation
        // Valid
        // Update color of left image
        if hasText {
            imageView?.tintColor = UIColor.swvlRed
        } else {
            imageView?.tintColor = UIColor.jfLightGray
        }
    }
    
    @objc func editingBegin() {
        setBorder()
        imageView?.tintColor = UIColor.swvlRed
        self.placeholder = selectedPlaceHolderText//"Search for anyone on Hackfest-swvl"
    }
    @objc func editingEnd() {
        isEmpty()
        imageView?.tintColor = UIColor.jfLightGray
        self.placeholder = "Search"

    }
    
    // Checking if has text the set a border accordingly
    func isEmpty() {
        if hasText {
            setBorder()
        } else {
            setBorder(enabled: false)
        }
    }
    
    func setBorder(enabled: Bool = true) {
        if !hasErrorMessage {
            tintColor = UIColor.swvlMediumRed // set cursor color
            borderStyle = .none
            layer.masksToBounds = false
            layer.backgroundColor = UIColor.white.cgColor

            if enabled {
                layer.shadowColor = UIColor.swvlMediumRed.cgColor
                
            } else {
                self.layer.shadowColor = UIColor.jfLightGray.cgColor
            }
            
            layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 0.0
        }
    }
    
    func showError() {
        layer.shadowOpacity = 0.0 //Hide bottom border
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.jfRed.cgColor
    }
    
    func hideError() {
        layer.shadowOpacity = 1.0 //Show bottom border
        layer.cornerRadius = 0.0
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        isEmpty()
    }
}
