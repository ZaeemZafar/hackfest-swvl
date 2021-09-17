//
//  JFView.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/4/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFView: UIView {

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
        clipsToBounds = true
    }
    
    
}
