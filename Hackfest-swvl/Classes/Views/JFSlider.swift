//
//  JFSlider.swift
//  Hackfest-swvl
//
//  Created by zaktech on 6/6/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFSlider: UISlider {

    var segmentsAdded = false
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 8.0))
    }
    
    func addSegment() {
        let segmentWidth = Int(self.frame.size.width / 3)
        
        for i in 1...2 {
            let aView = UIView(frame: CGRect(x: segmentWidth * i, y: 0, width: 2, height: 8))
            aView.backgroundColor = .white
            aView.tag = 50
            aView.layer.zPosition = 0
            addSubview(aView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if segmentsAdded == false {
            addSegment()
            segmentsAdded = true
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
}
