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
    var trait1 : Bool?
    var trait2 : Bool?
    var trait3 : Bool?
    var trait4 : Bool?
    var trait5 : Bool?
    var trait6 : Bool?
    var trait7 : Bool?
    var trait8 : Bool?
    var trait9 : Bool?
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
        case trait1 = "trait1"
        case trait2 = "trait2"
        case trait3 = "trait3"
        case trait4 = "trait4"
        case trait5 = "trait5"
        case trait6 = "trait6"
        case trait7 = "trait7"
        case trait8 = "trait8"
        case trait9 = "trait9"
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
        
        trait1 = try container.decodeIfPresent(Bool.self, forKey: .trait1)
        trait2 = try container.decodeIfPresent(Bool.self, forKey: .trait2)
        trait3 = try container.decodeIfPresent(Bool.self, forKey: .trait3)
        trait4 = try container.decodeIfPresent(Bool.self, forKey: .trait4)
        trait5 = try container.decodeIfPresent(Bool.self, forKey: .trait5)
        trait6 = try container.decodeIfPresent(Bool.self, forKey: .trait6)
        trait7 = try container.decodeIfPresent(Bool.self, forKey: .trait7)
        trait8 = try container.decodeIfPresent(Bool.self, forKey: .trait8)
        trait9 = try container.decodeIfPresent(Bool.self, forKey: .trait9)
        
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
                    (trait1! ? 1 : 0) +
                    (trait2! ? 1 : 0) +
                    (trait3! ? 1 : 0) +
                    (trait4! ? 1 : 0) +
                    (trait5! ? 1 : 0) +
                    (trait6! ? 1 : 0) +
                    (trait7! ? 1 : 0) +
                    (trait8! ? 1 : 0) +
                    (trait9! ? 1 : 0)
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
