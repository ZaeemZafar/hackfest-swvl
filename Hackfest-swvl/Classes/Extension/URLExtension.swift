//
//  URLExtension.swift
//  Hackfest-swvl
//
//  Created by ZaeemZafar on 23/05/2018.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
