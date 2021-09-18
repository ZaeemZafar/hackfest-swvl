/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct GraphUserData : Codable {
	let id : Int?
	let userId : Int?
	let jfIndex : Double?
	let jfMultiplier : Double?
	let rateOfChange : Double?
    
    let trait1Average: Double?
    let trait2Average: Double?
    let trait3Average: Double?
    let trait4Average: Double?
    let trait5Average: Double?
    let trait6Average: Double?
    let trait7Average: Double?
    let trait8Average: Double?
    let trait9Average: Double?
    
    let trait1RateOfChange: Double?
    let trait2RateOfChange: Double?
    let trait3RateOfChange: Double?
    let trait4RateOfChange: Double?
    let trait5RateOfChange: Double?
    let trait6RateOfChange: Double?
    let trait7RateOfChange: Double?
    let trait8RateOfChange: Double?
    let trait9RateOfChange: Double?
    
    let status : Bool?
	let isDeleted : Bool?
	let createdAt : String?
	let updatedAt : String?
	let graphData : [GraphData]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case userId = "userId"
		case jfIndex = "jfIndex"
		case jfMultiplier = "jfMultiplier"
		case rateOfChange = "rateOfChange"
		
        
        case trait1Average = "trait1Average"
        case trait2Average = "trait2Average"
        case trait3Average = "trait3Average"
        case trait4Average = "trait4Average"
        case trait5Average = "trait5Average"
        case trait6Average = "trait6Average"
        case trait7Average = "trait7Average"
        case trait8Average = "trait8Average"
        case trait9Average = "trait9Average"
        
        case trait1RateOfChange = "trait1RateOfChange"
        case trait2RateOfChange = "trait2RateOfChange"
        case trait3RateOfChange = "trait3RateOfChange"
        case trait4RateOfChange = "trait4RateOfChange"
        case trait5RateOfChange = "trait5RateOfChange"
        case trait6RateOfChange = "trait6RateOfChange"
        case trait7RateOfChange = "trait7RateOfChange"
        case trait8RateOfChange = "trait8RateOfChange"
        case trait9RateOfChange = "trait9RateOfChange"
        
        case status = "status"
		case isDeleted = "isDeleted"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case graphData = "graphData"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		userId = try values.decodeIfPresent(Int.self, forKey: .userId)
		jfIndex = try values.decodeIfPresent(Double.self, forKey: .jfIndex)
		jfMultiplier = try values.decodeIfPresent(Double.self, forKey: .jfMultiplier)
		rateOfChange = try values.decodeIfPresent(Double.self, forKey: .rateOfChange)
        
        trait1Average = try values.decodeIfPresent(Double.self, forKey: .trait1Average)
        trait2Average = try values.decodeIfPresent(Double.self, forKey: .trait2Average)
        trait3Average = try values.decodeIfPresent(Double.self, forKey: .trait3Average)
        trait4Average = try values.decodeIfPresent(Double.self, forKey: .trait4Average)
        trait5Average = try values.decodeIfPresent(Double.self, forKey: .trait5Average)
        trait6Average = try values.decodeIfPresent(Double.self, forKey: .trait6Average)
        trait7Average = try values.decodeIfPresent(Double.self, forKey: .trait7Average)
        trait8Average = try values.decodeIfPresent(Double.self, forKey: .trait8Average)
        trait9Average = try values.decodeIfPresent(Double.self, forKey: .trait9Average)
        
        trait1RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait1RateOfChange)
        trait2RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait2RateOfChange)
        trait3RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait3RateOfChange)
        trait4RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait4RateOfChange)
        trait5RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait5RateOfChange)
        trait6RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait6RateOfChange)
        trait7RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait7RateOfChange)
        trait8RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait8RateOfChange)
        trait9RateOfChange = try values.decodeIfPresent(Double.self, forKey: .trait9RateOfChange)
        
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		graphData = try values.decodeIfPresent([GraphData].self, forKey: .graphData)
	}

}
