//
//  JFUserDefaults.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/16/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation

enum JFUserDefaults: String {
    case user
    
    func get<Value: Codable>() -> Value? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: rawValue),
            let value = try? decoder.decode(Value.self, from: data) {
            return value
        }
        return nil
    }
    
    func set<Value: Codable>(value: Value) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            UserDefaults.standard.set(encoded, forKey: rawValue)
        }
    }
    
    func getBool() -> Bool {
        return UserDefaults.standard.bool(forKey: rawValue)
    }
    
    func getDouble() -> Double? {
        return UserDefaults.standard.double(forKey: rawValue)
    }
    
    func getInt() -> Int? {
        return UserDefaults.standard.integer(forKey: rawValue)
    }
    
    func getDate() -> Date? {
        if let timeInterval = getDouble() {
            if timeInterval != 0 {
                return Date(timeIntervalSince1970: timeInterval)
            }
        }
        return nil
    }
    
    func getString() -> String? {
        return UserDefaults.standard.string(forKey: rawValue)
    }
    
    func getArray() -> [String]? {
        if let array = UserDefaults.standard.array(forKey: rawValue) as? [String] {
            print("Array: \(array)")
            return array
        }
        return nil
    }
    
    func append(value: String) {
        var array: [String] = []
        if let tempArray = getArray() {
            array.append(contentsOf: tempArray)
        }
        array.append(value)
        UserDefaults.standard.set(array, forKey: rawValue)
    }
    
    func set(value: String) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func set(value: Double) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func set(value: Bool) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func set(value: Int) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    func set(value: Date) {
        UserDefaults.standard.set(value.timeIntervalSince1970, forKey: rawValue)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: rawValue)
    }
    
}
