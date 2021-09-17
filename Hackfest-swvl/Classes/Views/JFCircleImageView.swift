//
//  JFCircleImageView.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/29/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class JFCircleImageView: UIImageView {
    
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
        circleView()
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
