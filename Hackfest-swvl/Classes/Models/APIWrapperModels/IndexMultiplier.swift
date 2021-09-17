/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct IndexMultiplier : Codable {
	let jfIndex : Double?
	let jfMultiplier : Double?
	let rateOfChange : Double?
    let appearanceAverage: Double?
    let personalityAverage: Double?
    let intelligenceAverage: Double?
    
	enum CodingKeys: String, CodingKey {

		case jfIndex = "jfIndex"
		case jfMultiplier = "jfMultiplier"
		case rateOfChange = "rateOfChange"
        case appearanceAverage = "appearanceAverage"
        case personalityAverage = "personalityAverage"
        case intelligenceAverage = "intelligenceAverage"
	}

	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
		jfIndex = try container.decodeIfPresent(Double.self, forKey: .jfIndex)
		jfMultiplier = try container.decodeIfPresent(Double.self, forKey: .jfMultiplier)
		rateOfChange = try container.decodeIfPresent(Double.self, forKey: .rateOfChange)
        appearanceAverage = try container.decodeIfPresent(Double.self, forKey: .appearanceAverage)
        personalityAverage = try container.decodeIfPresent(Double.self, forKey: .personalityAverage)
        intelligenceAverage = try container.decodeIfPresent(Double.self, forKey: .intelligenceAverage)
	}
}
