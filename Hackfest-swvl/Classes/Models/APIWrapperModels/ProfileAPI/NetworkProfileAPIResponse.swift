/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct NetworkProfileAPIResponse : Codable {
	let id : Int?
	let firstName : String?
	let lastName : String?
    let facebookId: String?
    let fbProfileLink: String?
	let image : String?
	let biography : String?
	let location : String?
    let latitude : Double?
    let longitude : Double?
	let indexMultiplier : IndexMultiplier?
	let multiplierInfo : MultiplierInfo?
	let settings : SettingsData?
    
    let blockedByMe : BlockedByMe?
    let blockedByThem : BlockedByThem?
    
	let rateButtonInfo : RateButtonInfo?
	let requestButtonInfo : RequestButtonInfo?
    
    let friendRelation : FollowingRelation?
    let followedByRelation : FollowedByRelation?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case firstName = "firstName"
		case lastName = "lastName"
        case facebookId = "facebookId"
        case fbProfileLink = "fbProfileLink"
		case image = "image"
		case biography = "biography"
		case location = "location"
		case indexMultiplier = "indexMultiplier"
		case multiplierInfo = "multiplierInfo"
		case settings = "settings"
        case blockedByMe = "blockedByMe"
        case blockedByThem = "blockedByThem"
		case friendRelation = "friendRelation"
        case followedByRelation = "followedByRelation"
		case rateButtonInfo = "rateButtonInfo"
		case requestButtonInfo = "requestButtonInfo"
        case latitude = "latitude"
        case longitude = "longitude"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        facebookId = try values.decodeIfPresent(String.self, forKey: .facebookId)
        fbProfileLink = try values.decodeIfPresent(String.self, forKey: .fbProfileLink)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		biography = try values.decodeIfPresent(String.self, forKey: .biography)
		location = try values.decodeIfPresent(String.self, forKey: .location)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        
        do {
            indexMultiplier = try values.decodeIfPresent(IndexMultiplier.self, forKey: .indexMultiplier)
        } catch {indexMultiplier = nil}
        
        do {
            multiplierInfo = try values.decodeIfPresent(MultiplierInfo.self, forKey: .multiplierInfo)
        } catch {multiplierInfo = nil}
        
        do {
            settings = try values.decodeIfPresent(SettingsData.self, forKey: .settings)
        } catch {settings = nil}
        
        do {
            blockedByMe = try values.decodeIfPresent(BlockedByMe.self, forKey: .blockedByMe)
        } catch {blockedByMe = nil}
        
        do {
            blockedByThem = try values.decodeIfPresent(BlockedByThem.self, forKey: .blockedByThem)
        } catch {blockedByThem = nil}
		
        do {
            friendRelation = try values.decodeIfPresent(FollowingRelation.self, forKey: .friendRelation)
        } catch {friendRelation = nil}
        
        do {
            followedByRelation = try values.decodeIfPresent(FollowedByRelation.self, forKey: .followedByRelation)
        } catch {followedByRelation = nil}
        
        do {
            requestButtonInfo = try values.decodeIfPresent(RequestButtonInfo.self, forKey: .requestButtonInfo)
        } catch {requestButtonInfo = nil}
        
        do {
            rateButtonInfo = try values.decodeIfPresent(RateButtonInfo.self, forKey: .rateButtonInfo)
        } catch {rateButtonInfo = nil}
	}

}
