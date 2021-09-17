//
//  UIView+JF.swift
//  Hackfest-swvl
//
//  Created by Umair on 02/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}

// MARK: -

struct FRPinConstraints {
    let topConstraint: NSLayoutConstraint
    let leadingConstraint: NSLayoutConstraint
    let bottomConstraint: NSLayoutConstraint
    let trailingConstraint: NSLayoutConstraint
    
    init(top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        self.topConstraint = top
        self.leadingConstraint = leading
        self.bottomConstraint = bottom
        self.trailingConstraint = trailing
    }
}

// MARK: -

extension UIView {
    
    // Used to circle UIView
    func circleView() {
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
    }
    
    //How to use: CustomView.loadFromNibNamed("CustomViewNibName")
    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    @discardableResult
    func addFourPinContraintsToSubview(subV: UIView,
                                       topMargin: CGFloat,
                                       leadingMargin: CGFloat,
                                       trailingMargin: CGFloat,
                                       bottomMargin: CGFloat) -> FRPinConstraints {
        
        subV.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: subV,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: topMargin)
        
        let trailingConstraint = NSLayoutConstraint (item: self,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: subV,
                                                     attribute: .trailing,
                                                     multiplier: 1,
                                                     constant: trailingMargin)
        
        let leadingConstraint = NSLayoutConstraint (item: subV,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .leading,
                                                    multiplier: 1,
                                                    constant: leadingMargin)
        
        let bottomConstraint = NSLayoutConstraint (item: self,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: subV,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: bottomMargin)
        
        self.addConstraints([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        
        return FRPinConstraints(top: topConstraint, leading: leadingConstraint, bottom: bottomConstraint, trailing: trailingConstraint)
    }
    
    func dropShadow(withShadowColor color: UIColor = .gray) {
        self.layer.contentsScale = UIScreen.main.scale
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    func addBlurView(light: Bool) {
        self.backgroundColor = UIColor.clear
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: (light == false) ? .dark: .light)
        let bfView = UIVisualEffectView(effect: blurEffect)
        bfView.frame = self.bounds
        addSubview(bfView)
        
        bfView.translatesAutoresizingMaskIntoConstraints = false
        
        let bfViewTopSpaceConstraint = NSLayoutConstraint(item: bfView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bfViewRightSpaceConstraint = NSLayoutConstraint(item: bfView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bfViewLeftSpaceConstraint = NSLayoutConstraint(item: bfView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bfViewBottomSpaceConstraint = NSLayoutConstraint(item: bfView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([bfViewTopSpaceConstraint, bfViewRightSpaceConstraint, bfViewLeftSpaceConstraint, bfViewBottomSpaceConstraint])
        
        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .extraLight))
        let vfView = UIVisualEffectView(effect: vibrancyEffect)
        vfView.frame = bfView.bounds
        
        // Add the vibrancy view to the blur view
        bfView.contentView.addSubview(vfView)
        
        vfView.translatesAutoresizingMaskIntoConstraints = false
        
        let vfViewTopSpaceConstraint = NSLayoutConstraint(item: vfView, attribute: .top, relatedBy: .equal, toItem: bfView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let vfViewRightSpaceConstraint = NSLayoutConstraint(item: vfView, attribute: .right, relatedBy: .equal, toItem: bfView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let vfViewLeftSpaceConstraint = NSLayoutConstraint(item: vfView, attribute: .left, relatedBy: .equal, toItem: bfView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let vfViewBottomSpaceConstraint = NSLayoutConstraint(item: vfView, attribute: .bottom, relatedBy: .equal, toItem: bfView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        bfView.addConstraints([vfViewTopSpaceConstraint, vfViewRightSpaceConstraint, vfViewLeftSpaceConstraint, vfViewBottomSpaceConstraint])
        
        sendSubview(toBack: bfView)
    }
    
    func containsGestureRecognizer(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let addedRecognizers = self.gestureRecognizers {
            
            for recognizer in addedRecognizers {
                
                if recognizer == gestureRecognizer {
                    return true
                }
            }
        }
        
        return false
    }
    
    func remove(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let addedRecognizers = self.gestureRecognizers {
            
            for recognizer in addedRecognizers {
                
                if recognizer == gestureRecognizer {
                    return true
                }
            }
        }
        
        return false
    }
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x, y: bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
}

enum ArchiveCopyingError: Error {
    case view
}

extension UIView {
    
    fileprivate func prepareConstraintsForArchiving() {
        constraints.forEach { $0.shouldBeArchived = true }
        subviews.forEach { $0.prepareConstraintsForArchiving() }
    }
    
    public func copyView() throws -> UIView {
        prepareConstraintsForArchiving()
        guard let view = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView else { throw ArchiveCopyingError.view }
        return view
    }
}

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = ((_ gesture: UITapGestureRecognizer) -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    @discardableResult
    public func addTapGestureRecognizer(action: ((_ gesture: UITapGestureRecognizer) -> Void)?) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        return tapGestureRecognizer
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?(sender)
        } else {
            print("no action")
        }
    }
    
}

