/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct MultiplierInfos : Codable {
	let id : Int?
	let userId : Int?
	let isPublicProfile : Bool?
	let anonymousRatingGiven : Bool?
	let acceptAnonymousFeedback : Bool?
	let ratingsRequested : Int?
	let peopleInvited : Int?
	let ratingsGiven : Int?
	let followers : Int?
	let ratingsReceived : Int?
	let lastActivityTime : String?
	let loginDays : Int?
	let lastRatingGiven : String?
	let signupTime : String?
	let lastRatingRequested : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case userId = "userId"
		case isPublicProfile = "isPublicProfile"
		case anonymousRatingGiven = "anonymousRatingGiven"
		case acceptAnonymousFeedback = "acceptAnonymousFeedback"
		case ratingsRequested = "ratingsRequested"
		case peopleInvited = "peopleInvited"
		case ratingsGiven = "ratingsGiven"
		case followers = "followers"
		case ratingsReceived = "ratingsReceived"
		case lastActivityTime = "lastActivityTime"
		case loginDays = "loginDays"
		case lastRatingGiven = "lastRatingGiven"
		case signupTime = "signupTime"
		case lastRatingRequested = "lastRatingRequested"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		userId = try values.decodeIfPresent(Int.self, forKey: .userId)
		isPublicProfile = try values.decodeIfPresent(Bool.self, forKey: .isPublicProfile)
		anonymousRatingGiven = try values.decodeIfPresent(Bool.self, forKey: .anonymousRatingGiven)
		acceptAnonymousFeedback = try values.decodeIfPresent(Bool.self, forKey: .acceptAnonymousFeedback)
		ratingsRequested = try values.decodeIfPresent(Int.self, forKey: .ratingsRequested)
		peopleInvited = try values.decodeIfPresent(Int.self, forKey: .peopleInvited)
		ratingsGiven = try values.decodeIfPresent(Int.self, forKey: .ratingsGiven)
		followers = try values.decodeIfPresent(Int.self, forKey: .followers)
		ratingsReceived = try values.decodeIfPresent(Int.self, forKey: .ratingsReceived)
		lastActivityTime = try values.decodeIfPresent(String.self, forKey: .lastActivityTime)
		loginDays = try values.decodeIfPresent(Int.self, forKey: .loginDays)
		lastRatingGiven = try values.decodeIfPresent(String.self, forKey: .lastRatingGiven)
		signupTime = try values.decodeIfPresent(String.self, forKey: .signupTime)
		lastRatingRequested = try values.decodeIfPresent(String.self, forKey: .lastRatingRequested)
	}

}
