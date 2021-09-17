//
//  ArrayExtension.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 12/07/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
    
    
    
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
            self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
            self.index(endIndex, offsetBy: distance, limitedBy: startIndex)
        
        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }
    
    mutating func shiftInPlace(withDistance distance: Int = 1) {
        self = shift(withDistance: distance)
    }
    
    
    
}


extension Array where Element: JFProfile {
    mutating func updateJFProfile(userProfile: JFProfile) {
        if let row = self.index(where: {$0.id == userProfile.id}) {
            self[row] = userProfile as! Element
        }
    }
    
    mutating func setJFProfile(userProfile: JFProfile) {
        if let row = self.index(where: {$0.id == userProfile.id}) {
            self[row] = userProfile as! Element
        } else {
            self.append(userProfile as! Element)
        }
    }
}


extension Array where Element: JFGraph {
    mutating func setGraph(graph: JFGraph?) {
        
        if let graphToSet = graph {
            if let index = self.index(where: {$0.type == graphToSet.type}) {
                self.remove(at: index)
            } else {
                self.append(graphToSet as! Element)
            }
        }
        
    }
}

extension Array {
    mutating func setGraphType(graphType: JFIndexMultiplierType?) {
        
        if let index = self.index(where: {($0 as? JFIndexMultiplierType) == graphType}) {
            self.remove(at: index)
        } else {
            self.append(graphType as! Element)
        }
        
    }

}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
