/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct RatingsHistoryData : Codable {
	let id : Int?
	let userId : Int?
	let fromUserId : Int?
	let traitAppearance1 : Double?
	let traitAppearance2 : Double?
	let traitAppearance3 : Double?
	let traitPersonality1 : Double?
	let traitPersonality2 : Double?
	let traitPersonality3 : Double?
	let traitIntelligence1 : Double?
	let traitIntelligence2 : Double?
	let traitIntelligence3 : Double?
	let count : Int?
	let isAnonymous : Bool?
	let status : Int?
	let isDeleted : Bool?
	let createdAt : String?
	let updatedAt : String?
	let ratingGivenBy : RatingGivenBy?

    var updatedDate: Date {
        get {
            return Date(fromString: updatedAt ?? "", format: .isoDateTimeMilliSec) ?? Date()
        }
    }
    
	enum CodingKeys: String, CodingKey {

		case id = "id"
		case userId = "userId"
		case fromUserId = "fromUserId"
		case traitAppearance1 = "traitAppearance1"
		case traitAppearance2 = "traitAppearance2"
		case traitAppearance3 = "traitAppearance3"
		case traitPersonality1 = "traitPersonality1"
		case traitPersonality2 = "traitPersonality2"
		case traitPersonality3 = "traitPersonality3"
		case traitIntelligence1 = "traitIntelligence1"
		case traitIntelligence2 = "traitIntelligence2"
		case traitIntelligence3 = "traitIntelligence3"
		case count = "count"
		case isAnonymous = "isAnonymous"
		case status = "status"
		case isDeleted = "isDeleted"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case ratingGivenBy = "ratingGivenBy"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		userId = try values.decodeIfPresent(Int.self, forKey: .userId)
		fromUserId = try values.decodeIfPresent(Int.self, forKey: .fromUserId)
        
        do {
		traitAppearance1 = try values.decodeIfPresent(Double.self, forKey: .traitAppearance1)
        } catch {
            traitAppearance1 = nil
        }
        
        do {
		traitAppearance2 = try values.decodeIfPresent(Double.self, forKey: .traitAppearance2)
        } catch {
            traitAppearance2 = nil
        }
        
        do {
		traitAppearance3 = try values.decodeIfPresent(Double.self, forKey: .traitAppearance3)
        } catch {
            traitAppearance3 = nil
        }
        
        do {
		traitPersonality1 = try values.decodeIfPresent(Double.self, forKey: .traitPersonality1)
        } catch {
            traitPersonality1 = nil
        }
        
        do {
		traitPersonality2 = try values.decodeIfPresent(Double.self, forKey: .traitPersonality2)
        } catch {
            traitPersonality2 = nil
        }
        
        do {
		traitPersonality3 = try values.decodeIfPresent(Double.self, forKey: .traitPersonality3)
        } catch {
            traitPersonality3 = nil
        }
        
        do {
		traitIntelligence1 = try values.decodeIfPresent(Double.self, forKey: .traitIntelligence1)
        } catch {
            traitIntelligence1 = nil
        }
        
        do {
		traitIntelligence2 = try values.decodeIfPresent(Double.self, forKey: .traitIntelligence2)
        } catch {
            traitIntelligence2 = nil
        }
        
        do {
		traitIntelligence3 = try values.decodeIfPresent(Double.self, forKey: .traitIntelligence3)
        } catch {
            traitIntelligence3 = nil
        }
        
        do {
		count = try values.decodeIfPresent(Int.self, forKey: .count)
        } catch {
            count = nil
        }
		isAnonymous = try values.decodeIfPresent(Bool.self, forKey: .isAnonymous)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		ratingGivenBy = try values.decodeIfPresent(RatingGivenBy.self, forKey: .ratingGivenBy)
	}

}
