//
//  JFAPIConfig.swift
//  Hackfest-swvl
//
//  Created by Umair on 13/04/2018.
//  Copyright © 2018 maskers. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


protocol JFAPIConfig {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: Parameters? { get }
    var setAuth: Bool { get }
}
