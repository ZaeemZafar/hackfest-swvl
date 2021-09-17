//
//  StringExtension.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 28/05/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation

extension String
{
    func equalIgnoreCase(_ compare:String) -> Bool {
        return self.uppercased() == compare.uppercased()
    }
    
    var removeDigits: String {
        return (self.components(separatedBy: .decimalDigits).joined(separator: ""))
    }
    
    var clear: String {
        return ""
    }
    
    
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        
        guard toLength > self.count else { return self }
        
        let padding = String(repeating: withPad, count: toLength - self.count)
        return padding + self
    }
}
