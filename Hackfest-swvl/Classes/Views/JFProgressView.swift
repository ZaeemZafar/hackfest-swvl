//
//  JFProgressView.swift
//  Hackfest-swvl
//
//  Created by Umair on 16/04/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

// @IBDesignable
class JFProgressView: UIView {
    @IBInspectable var trackColor: UIColor = UIColor.white
    @IBInspectable var barColor: UIColor = UIColor.jfDarkBrown
    
    @IBInspectable var progressValue: Int = 0 {
        
        didSet {
            
            if (progressValue >= 100) {
                progressValue = 100
                
            } else if (progressValue <= 0) {
                progressValue = 0
            }
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        // Track
        let trackPath = UIBezierPath(rect: rect)
        trackColor.setFill()
        trackPath.lineWidth = self.frame.size.height
        trackPath.fill()
        
        // Progress
        var progressRect = rect
        progressRect.size.width = progressWidth()
        
        let progressPath = UIBezierPath(rect: progressRect)
        barColor.setFill()
        progressPath.lineWidth = self.frame.size.height
        progressPath.fill()
    }
    
    fileprivate func progressWidth() -> CGFloat {
        let width = ((CGFloat(progressValue) / 100.0) * self.frame.size.width)
        return width < 0 ? 0 : width
    }
}
