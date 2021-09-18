/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SettingsData : Codable {
	let id : Int?
	let userId : Int?
	var traitAppearance : Bool?
	var traitPersonality : Bool?
	var traitIntelligence : Bool?
	let traitNone : Bool?
	var notificationsEnabled : Bool?
	var locationEnabled : Bool?
	let scoreScope : String?
    var isPublicProfile : Bool?
	var acceptAnonymousRating : Bool?
	var facebookConnected : Bool?
	var displayFacebookProfile : Bool?
	var acceptRating : Bool?
    

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case userId = "userId"
        case traitAppearance = "traitAppearance"
        case traitPersonality = "traitPersonality"
        case traitIntelligence = "traitIntelligence"
        case traitNone = "traitNone"
        case notificationsEnabled = "notificationsEnabled"
        case locationEnabled = "locationEnabled"
        case scoreScope = "scoreScope"
        case isPublicProfile = "isPublicProfile"
        case acceptAnonymousRating = "acceptAnonymousRating"
        case facebookConnected = "facebookConnected"
        case displayFacebookProfile = "displayFacebookProfile"
        case acceptRating = "acceptRating"
    }

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id)
		userId = try container.decodeIfPresent(Int.self, forKey: .userId)
		traitAppearance = try container.decodeIfPresent(Bool.self, forKey: .traitAppearance)
		traitPersonality = try container.decodeIfPresent(Bool.self, forKey: .traitPersonality)
		traitIntelligence = try container.decodeIfPresent(Bool.self, forKey: .traitIntelligence)
		traitNone = try container.decodeIfPresent(Bool.self, forKey: .traitNone)
		notificationsEnabled = try container.decodeIfPresent(Bool.self, forKey: .notificationsEnabled)
		locationEnabled = try container.decodeIfPresent(Bool.self, forKey: .locationEnabled)
		scoreScope = try container.decodeIfPresent(String.self, forKey: .scoreScope)
		isPublicProfile = try container.decodeIfPresent(Bool.self, forKey: .isPublicProfile)
		acceptAnonymousRating = try container.decodeIfPresent(Bool.self, forKey: .acceptAnonymousRating)
		facebookConnected = try container.decodeIfPresent(Bool.self, forKey: .facebookConnected)
		displayFacebookProfile = try container.decodeIfPresent(Bool.self, forKey: .displayFacebookProfile)
		acceptRating = try container.decodeIfPresent(Bool.self, forKey: .acceptRating)
	}
    
    func getRatingTextForSettings() -> String {
        if acceptRating != nil {
            if acceptRating == true {
                var numberOfCategoriesOn = 0
                numberOfCategoriesOn += (
                    (traitAppearance ?? false ? 1 : 0) +
                    (traitPersonality ?? false ? 1 : 0) +
                    (traitIntelligence ?? false ? 1 : 0)
                )
                
                return (numberOfCategoriesOn == 0) ? "On" : (numberOfCategoriesOn == 1 ? "On, 1 Category" : (numberOfCategoriesOn > 1) ? "On, \(numberOfCategoriesOn) Categories" : "On")
                
            } else {
                return "Not accepting ratings"
            }
        } else {
            return "--"
        }
    }
}
