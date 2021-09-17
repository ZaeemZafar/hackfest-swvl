//
//  LayoutConstraint+JF.swift
//  Hackfest-swvl
//
//  Created by zaktech on 5/28/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem ?? 0, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
