//
//  UITableViewExtension.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 21/05/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

extension UITableView {
    
    func registerCell(identifier: Swift.AnyClass) {
        register(UINib(nibName: String(describing: identifier.self), bundle: nil), forCellReuseIdentifier: String(describing: identifier.self))
    }
    
    func register(identifiers: [Swift.AnyClass]) {
        
        for identifier in identifiers {
            registerCell(identifier: identifier)
        }
    }
}
