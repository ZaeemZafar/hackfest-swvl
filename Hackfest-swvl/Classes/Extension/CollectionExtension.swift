//
//  CollectionExtension.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 23/05/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
