/*
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct RateButtonInfo : Codable {
	let isAnonymous : Bool?
	let lastActionTime : String?
	let count : Int?
    let trait1 : [Int]?
    let trait2 : [Int]?
    let trait3 : [Int]?
    let trait4 : [Int]?
    let trait5 : [Int]?
    let trait6 : [Int]?
    let trait7 : [Int]?
    let trait8 : [Int]?
    let trait9 : [Int]?
    
	enum CodingKeys: String, CodingKey {

		case isAnonymous = "isAnonymous"
		case lastActionTime = "lastActionTime"
		case count = "count"
        case trait1 = "trait1"
        case trait2 = "trait2"
        case trait3 = "trait3"
        case trait4 = "trait4"
        case trait5 = "trait5"
        case trait6 = "trait6"
        case trait7 = "trait7"
        case trait8 = "trait8"
        case trait9 = "trait9"
	}

	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

		isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
		lastActionTime = try container.decodeIfPresent(String.self, forKey: .lastActionTime)
		count = try container.decodeIfPresent(Int.self, forKey: .count)
		
        trait1 = try container.decodeIfPresent([Int].self, forKey: .trait1)
        trait2 = try container.decodeIfPresent([Int].self, forKey: .trait2)
        trait3 = try container.decodeIfPresent([Int].self, forKey: .trait3)
        trait4 = try container.decodeIfPresent([Int].self, forKey: .trait4)
        trait5 = try container.decodeIfPresent([Int].self, forKey: .trait5)
        trait6 = try container.decodeIfPresent([Int].self, forKey: .trait6)
        trait7 = try container.decodeIfPresent([Int].self, forKey: .trait7)
        trait8 = try container.decodeIfPresent([Int].self, forKey: .trait8)
        trait9 = try container.decodeIfPresent([Int].self, forKey: .trait9)
        
    }

}
