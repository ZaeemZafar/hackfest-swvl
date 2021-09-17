//
//  JFNewNotificationIndicatorView.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/29/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFNewNotificationIndicatorView: UIView {

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
    
    var newNotificaton: Bool = false {
        didSet {
            setupUI()
        }
    }
    
//    override var backgroundColor: UIColor? {
//        didSet {
//            if newNotificaton {
//                self.backgroundColor = UIColor.jfMediumBrown
//                
//            } else {
//                self.backgroundColor = UIColor.white
//            }
//        }
//    }
    
    func setupUI() {
        circleView()
        if newNotificaton {
            self.backgroundColor = UIColor.jfMediumBrown
            
        } else {
            self.backgroundColor = UIColor.white
        }
    }
}
